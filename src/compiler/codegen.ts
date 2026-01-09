// Code generator for 6510 assembly

import {
  ProgramNode,
  ProcedureNode,
  FunctionNode,
  StatementNode,
  ExpressionNode,
  VarDecl,
  DataType,
  VarType,
  isArrayType,
  ArrayType,
} from "./ast";

interface Variable {
  name: string;
  varType: VarType;
  address: number;
  size: number;
}

export class CodeGenerator {
  private output: string[] = [];
  private variables: Map<string, Variable> = new Map();
  private nextZpAddress: number = 0x02; // Start after zero page system locations
  private nextRamAddress: number = 0x0800; // Start of free RAM on C64
  private labelCounter: number = 0;
  private currentProc: string = "";

  generate(program: ProgramNode): string {
    this.output = [];
    this.variables.clear();
    this.nextZpAddress = 0x02;
    this.nextRamAddress = 0x0800;
    this.labelCounter = 0;

    // Header
    this.emit(`; pas6510 compiled program: ${program.name}`);
    this.emit(`;`);
    this.emit("");

    if (program.org !== undefined) {
      // Custom origin - no BASIC stub
      const orgHex = program.org.toString(16).toUpperCase().padStart(4, "0");
      this.emit(`  .org $${orgHex}`);
      this.emit("");
      this.emit("; Program start");
      this.emit("start:");
      this.emit("  jsr main");
      this.emit("  rts");
      this.emit("");
    } else {
      // Default: C64 BASIC start with auto-run stub
      this.emit("  .org $0801");
      this.emit("");
      this.emit("; BASIC stub: 10 SYS 2062");
      this.emit("  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $32, $00, $00, $00");
      this.emit("");
      this.emit("; Program start");
      this.emit("start:");
      this.emit("  jsr main");
      this.emit("  rts");
      this.emit("");
    }

    // Generate all procedures and functions
    for (const proc of program.procedures) {
      this.generateProcedure(proc);
    }

    for (const func of program.functions) {
      this.generateFunction(func);
    }

    // Runtime library
    this.generateRuntime();

    // Variable storage
    this.emit("");
    this.emit("; Variables");
    for (const [name, v] of this.variables) {
      this.emit(`${this.varLabel(name)}:`);
      if (v.size === 1) {
        this.emit(`  .byte 0`);
      } else {
        this.emit(`  .res ${v.size}`);
      }
    }

    return this.output.join("\n");
  }

  private emit(line: string): void {
    this.output.push(line);
  }

  private newLabel(prefix: string): string {
    return `_${prefix}_${this.labelCounter++}`;
  }

  private varLabel(name: string): string {
    return `_var_${name}`;
  }

  private getTypeSize(t: VarType): number {
    if (isArrayType(t)) {
      const elemSize = this.getDataTypeSize(t.elementType);
      return elemSize * t.size;
    }
    return this.getDataTypeSize(t);
  }

  private getDataTypeSize(t: DataType): number {
    switch (t) {
      case "i8":
      case "u8":
        return 1;
      case "i16":
      case "u16":
      case "ptr":
        return 2;
      default:
        return 1;
    }
  }

  private is16Bit(t: VarType): boolean {
    if (isArrayType(t)) return false;
    return t === "i16" || t === "u16" || t === "ptr";
  }

  private allocateVariable(decl: VarDecl): Variable {
    const size = this.getTypeSize(decl.varType);
    const address = this.nextRamAddress;
    this.nextRamAddress += size;

    const v: Variable = {
      name: decl.name,
      varType: decl.varType,
      address,
      size,
    };
    this.variables.set(decl.name, v);
    return v;
  }

  private generateProcedure(proc: ProcedureNode): void {
    this.currentProc = proc.name;
    this.emit(`; Procedure: ${proc.name}`);
    this.emit(`${proc.name}:`);

    // Allocate local variables
    for (const local of proc.locals) {
      this.allocateVariable(local);
    }

    // Generate body
    for (const stmt of proc.body) {
      this.generateStatement(stmt);
    }

    this.emit("  rts");
    this.emit("");
  }

  private generateFunction(func: FunctionNode): void {
    this.currentProc = func.name;
    this.emit(`; Function: ${func.name}`);
    this.emit(`${func.name}:`);

    // Allocate local variables
    for (const local of func.locals) {
      this.allocateVariable(local);
    }

    // Generate body
    for (const stmt of func.body) {
      this.generateStatement(stmt);
    }

    this.emit("  rts");
    this.emit("");
  }

  private generateStatement(stmt: StatementNode): void {
    switch (stmt.kind) {
      case "Assignment":
        this.generateAssignment(stmt);
        break;
      case "ForLoop":
        this.generateForLoop(stmt);
        break;
      case "WhileLoop":
        this.generateWhileLoop(stmt);
        break;
      case "If":
        this.generateIf(stmt);
        break;
      case "Call":
        this.generateCall(stmt);
        break;
      case "Return":
        this.generateReturn(stmt);
        break;
    }
  }

  private generateAssignment(stmt: { target: any; value: ExpressionNode }): void {
    const target = stmt.target;

    if (target.kind === "Variable") {
      const v = this.variables.get(target.name);
      if (!v) {
        throw new Error(`Unknown variable: ${target.name}`);
      }

      if (this.is16Bit(v.varType)) {
        // 16-bit assignment
        this.generateExpr16(stmt.value);
        this.emit(`  sta ${this.varLabel(target.name)}`);
        this.emit(`  stx ${this.varLabel(target.name)}+1`);
      } else {
        // 8-bit assignment
        this.generateExpr8(stmt.value);
        this.emit(`  sta ${this.varLabel(target.name)}`);
      }
    } else if (target.kind === "ArrayAccess") {
      // Array element assignment
      const v = this.variables.get(target.array);
      if (!v || !isArrayType(v.varType)) {
        throw new Error(`Unknown array: ${target.array}`);
      }

      // Calculate index into Y
      this.generateExpr8(target.index);
      this.emit(`  tay`);

      // Generate value into A
      this.generateExpr8(stmt.value);

      // Store to array
      this.emit(`  sta ${this.varLabel(target.array)},y`);
    }
  }

  private generateForLoop(stmt: {
    variable: string;
    start: ExpressionNode;
    end: ExpressionNode;
    body: StatementNode[];
  }): void {
    const loopLabel = this.newLabel("for");
    const endLabel = this.newLabel("endfor");

    // Ensure loop variable exists
    if (!this.variables.has(stmt.variable)) {
      this.allocateVariable({ name: stmt.variable, varType: "u8" });
    }

    const v = this.variables.get(stmt.variable)!;

    // Initialize loop variable
    this.generateExpr8(stmt.start);
    this.emit(`  sta ${this.varLabel(stmt.variable)}`);

    // Store end value in temp
    this.emit(`${loopLabel}:`);

    // Generate body
    for (const s of stmt.body) {
      this.generateStatement(s);
    }

    // Increment and compare
    this.emit(`  inc ${this.varLabel(stmt.variable)}`);
    this.emit(`  lda ${this.varLabel(stmt.variable)}`);

    // Compare with end value
    if (stmt.end.kind === "NumberLiteral") {
      this.emit(`  cmp #${stmt.end.value + 1}`);
    } else {
      // Need to evaluate end expression and compare
      // For now, store end in temp location
      this.generateExpr8(stmt.end);
      this.emit(`  clc`);
      this.emit(`  adc #1`);
      this.emit(`  cmp ${this.varLabel(stmt.variable)}`);
      this.emit(`  bcs ${loopLabel}`);
      return;
    }

    this.emit(`  bne ${loopLabel}`);
  }

  private generateWhileLoop(stmt: {
    condition: ExpressionNode;
    body: StatementNode[];
  }): void {
    const loopLabel = this.newLabel("while");
    const endLabel = this.newLabel("endwhile");

    this.emit(`${loopLabel}:`);

    // Generate condition
    this.generateCondition(stmt.condition, endLabel);

    // Generate body
    for (const s of stmt.body) {
      this.generateStatement(s);
    }

    this.emit(`  jmp ${loopLabel}`);
    this.emit(`${endLabel}:`);
  }

  private generateIf(stmt: {
    condition: ExpressionNode;
    thenBranch: StatementNode[];
    elseBranch: StatementNode[];
  }): void {
    const elseLabel = this.newLabel("else");
    const endLabel = this.newLabel("endif");

    // Generate condition - branch to else if false
    this.generateCondition(stmt.condition, elseLabel);

    // Then branch
    for (const s of stmt.thenBranch) {
      this.generateStatement(s);
    }

    if (stmt.elseBranch.length > 0) {
      this.emit(`  jmp ${endLabel}`);
    }

    this.emit(`${elseLabel}:`);

    // Else branch
    for (const s of stmt.elseBranch) {
      this.generateStatement(s);
    }

    if (stmt.elseBranch.length > 0) {
      this.emit(`${endLabel}:`);
    }
  }

  private generateCondition(expr: ExpressionNode, falseLabel: string): void {
    if (expr.kind === "BinaryOp") {
      const op = expr.operator;

      // Generate left side into A
      this.generateExpr8(expr.left);
      this.emit(`  pha`); // Save on stack

      // Generate right side into A
      this.generateExpr8(expr.right);
      this.emit(`  sta _tmp`);

      // Restore left into A
      this.emit(`  pla`);
      this.emit(`  cmp _tmp`);

      switch (op) {
        case "=":
          this.emit(`  bne ${falseLabel}`);
          break;
        case "<>":
          this.emit(`  beq ${falseLabel}`);
          break;
        case "<":
          this.emit(`  bcs ${falseLabel}`); // Branch if >=
          break;
        case ">=":
          this.emit(`  bcc ${falseLabel}`); // Branch if <
          break;
        case ">":
          this.emit(`  beq ${falseLabel}`); // Equal means not greater
          this.emit(`  bcc ${falseLabel}`); // Less means not greater
          break;
        case "<=":
          // A <= B means A < B or A == B
          // bcs jumps if A >= B, so we need to check
          const okLabel = this.newLabel("le_ok");
          this.emit(`  beq ${okLabel}`);
          this.emit(`  bcs ${falseLabel}`);
          this.emit(`${okLabel}:`);
          break;
      }
    } else {
      // Simple boolean - zero is false
      this.generateExpr8(expr);
      this.emit(`  beq ${falseLabel}`);
    }
  }

  private generateCall(stmt: { name: string; args: ExpressionNode[] }): void {
    // Handle built-in functions with arguments
    if (stmt.args.length === 1 && stmt.name === "write_u16_ln") {
      // Pass 16-bit argument in A (low) and X (high)
      this.generateExpr16(stmt.args[0]);
    } else if (stmt.args.length === 1) {
      // Default: pass first argument in A
      this.generateExpr8(stmt.args[0]);
    }
    this.emit(`  jsr ${stmt.name}`);
  }

  private generateReturn(stmt: { value?: ExpressionNode }): void {
    if (stmt.value) {
      this.generateExpr8(stmt.value);
    }
    this.emit(`  rts`);
  }

  // Generate 8-bit expression, result in A
  private generateExpr8(expr: ExpressionNode): void {
    switch (expr.kind) {
      case "NumberLiteral":
        this.emit(`  lda #${expr.value & 0xff}`);
        break;

      case "Variable":
        const v = this.variables.get(expr.name);
        if (!v) {
          throw new Error(`Unknown variable: ${expr.name}`);
        }
        this.emit(`  lda ${this.varLabel(expr.name)}`);
        break;

      case "ArrayAccess":
        this.generateExpr8(expr.index);
        this.emit(`  tay`);
        this.emit(`  lda ${this.varLabel(expr.array)},y`);
        break;

      case "BinaryOp":
        this.generateBinaryOp8(expr);
        break;

      case "UnaryOp":
        this.generateExpr8(expr.operand);
        if (expr.operator === "-") {
          this.emit(`  eor #$ff`);
          this.emit(`  clc`);
          this.emit(`  adc #1`);
        } else if (expr.operator === "not") {
          this.emit(`  eor #$ff`);
        }
        break;

      case "CallExpr":
        this.emit(`  jsr ${expr.name}`);
        // Result expected in A
        break;
    }
  }

  private generateBinaryOp8(expr: {
    operator: string;
    left: ExpressionNode;
    right: ExpressionNode;
  }): void {
    // Generate left into A, save to stack
    this.generateExpr8(expr.left);
    this.emit(`  pha`);

    // Generate right into A
    this.generateExpr8(expr.right);
    this.emit(`  sta _tmp`);

    // Restore left into A
    this.emit(`  pla`);

    switch (expr.operator) {
      case "+":
        this.emit(`  clc`);
        this.emit(`  adc _tmp`);
        break;
      case "-":
        this.emit(`  sec`);
        this.emit(`  sbc _tmp`);
        break;
      case "*":
        // Call multiply routine
        this.emit(`  sta _mul_a`);
        this.emit(`  lda _tmp`);
        this.emit(`  sta _mul_b`);
        this.emit(`  jsr _multiply`);
        break;
      case "/":
        // Call divide routine
        this.emit(`  sta _div_a`);
        this.emit(`  lda _tmp`);
        this.emit(`  sta _div_b`);
        this.emit(`  jsr _divide`);
        break;
      case "and":
        this.emit(`  and _tmp`);
        break;
      case "or":
        this.emit(`  ora _tmp`);
        break;
    }
  }

  // Generate 16-bit expression, result in A (low) and X (high)
  private generateExpr16(expr: ExpressionNode): void {
    switch (expr.kind) {
      case "NumberLiteral":
        this.emit(`  lda #<${expr.value}`);
        this.emit(`  ldx #>${expr.value}`);
        break;

      case "Variable":
        const v = this.variables.get(expr.name);
        if (!v) {
          throw new Error(`Unknown variable: ${expr.name}`);
        }
        this.emit(`  lda ${this.varLabel(expr.name)}`);
        if (this.is16Bit(v.varType)) {
          this.emit(`  ldx ${this.varLabel(expr.name)}+1`);
        } else {
          this.emit(`  ldx #0`);
        }
        break;

      case "BinaryOp":
        this.generateBinaryOp16(expr);
        break;

      default:
        // For other expressions, generate 8-bit and zero-extend
        this.generateExpr8(expr);
        this.emit(`  ldx #0`);
    }
  }

  private generateBinaryOp16(expr: {
    operator: string;
    left: ExpressionNode;
    right: ExpressionNode;
  }): void {
    switch (expr.operator) {
      case "+":
        // 16-bit addition
        this.generateExpr16(expr.left);
        this.emit(`  sta _tmp16`);
        this.emit(`  stx _tmp16+1`);

        this.generateExpr16(expr.right);

        this.emit(`  clc`);
        this.emit(`  adc _tmp16`);
        this.emit(`  pha`);
        this.emit(`  txa`);
        this.emit(`  adc _tmp16+1`);
        this.emit(`  tax`);
        this.emit(`  pla`);
        break;

      case "-":
        // 16-bit subtraction
        this.generateExpr16(expr.left);
        this.emit(`  sta _tmp16`);
        this.emit(`  stx _tmp16+1`);

        this.generateExpr16(expr.right);

        // Subtract: tmp16 - A,X
        this.emit(`  sta _tmp`);
        this.emit(`  stx _tmp+1`);
        this.emit(`  lda _tmp16`);
        this.emit(`  sec`);
        this.emit(`  sbc _tmp`);
        this.emit(`  pha`);
        this.emit(`  lda _tmp16+1`);
        this.emit(`  sbc _tmp+1`);
        this.emit(`  tax`);
        this.emit(`  pla`);
        break;

      default:
        // For other ops, use 8-bit for now
        this.generateExpr8(expr as any);
        this.emit(`  ldx #0`);
    }
  }

  private generateRuntime(): void {
    this.emit("");
    this.emit("; Runtime library");
    this.emit("");

    // Temporary storage
    this.emit("_tmp: .byte 0");
    this.emit("_tmp16: .word 0");
    this.emit("");

    // 8-bit multiply (result in A)
    this.emit("_mul_a: .byte 0");
    this.emit("_mul_b: .byte 0");
    this.emit("_multiply:");
    this.emit("  lda #0");
    this.emit("  ldx #8");
    this.emit("_mul_loop:");
    this.emit("  lsr _mul_b");
    this.emit("  bcc _mul_skip");
    this.emit("  clc");
    this.emit("  adc _mul_a");
    this.emit("_mul_skip:");
    this.emit("  asl _mul_a");
    this.emit("  dex");
    this.emit("  bne _mul_loop");
    this.emit("  rts");
    this.emit("");

    // 8-bit divide (result in A, remainder in X)
    this.emit("_div_a: .byte 0");
    this.emit("_div_b: .byte 0");
    this.emit("_divide:");
    this.emit("  ldx #0");
    this.emit("  lda _div_a");
    this.emit("_div_loop:");
    this.emit("  cmp _div_b");
    this.emit("  bcc _div_done");
    this.emit("  sec");
    this.emit("  sbc _div_b");
    this.emit("  inx");
    this.emit("  jmp _div_loop");
    this.emit("_div_done:");
    this.emit("  stx _tmp");
    this.emit("  lda _tmp");
    this.emit("  rts");
    this.emit("");

    // Print u16 (simple decimal output)
    this.emit("; write_u16_ln - print 16-bit number and newline");
    this.emit("_print_val: .word 0");
    this.emit("_print_buf: .res 6");
    this.emit("write_u16_ln:");
    this.emit("  sta _print_val");
    this.emit("  stx _print_val+1");
    this.emit("  ; Convert to decimal string");
    this.emit("  ldy #0");
    this.emit("_p16_loop:");
    this.emit("  lda _print_val");
    this.emit("  ora _print_val+1");
    this.emit("  beq _p16_print");
    this.emit("  ; Divide by 10");
    this.emit("  jsr _div16_10");
    this.emit("  ; Remainder (0-9) is in A");
    this.emit("  clc");
    this.emit("  adc #$30");
    this.emit("  sta _print_buf,y");
    this.emit("  iny");
    this.emit("  jmp _p16_loop");
    this.emit("_p16_print:");
    this.emit("  cpy #0");
    this.emit("  bne _p16_hasdigits");
    this.emit("  lda #$30  ; print '0' if value was 0");
    this.emit("  jsr $ffd2");
    this.emit("  jmp _p16_newline");
    this.emit("_p16_hasdigits:");
    this.emit("_p16_printloop:");
    this.emit("  dey");
    this.emit("  lda _print_buf,y");
    this.emit("  jsr $ffd2  ; CHROUT");
    this.emit("  cpy #0");
    this.emit("  bne _p16_printloop");
    this.emit("_p16_newline:");
    this.emit("  lda #13");
    this.emit("  jsr $ffd2");
    this.emit("  rts");
    this.emit("");

    // Divide 16-bit by 10
    this.emit("_div16_10:");
    this.emit("  lda #0");
    this.emit("  ldx #16");
    this.emit("  clc");
    this.emit("_d10_loop:");
    this.emit("  rol _print_val");
    this.emit("  rol _print_val+1");
    this.emit("  rol a");
    this.emit("  cmp #10");
    this.emit("  bcc _d10_skip");
    this.emit("  sbc #10");
    this.emit("  inc _print_val");
    this.emit("_d10_skip:");
    this.emit("  dex");
    this.emit("  bne _d10_loop");
    this.emit("  ; Remainder in A, quotient in _print_val");
    this.emit("  rts");
  }
}
