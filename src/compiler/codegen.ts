// Code generator for 6510 assembly

import {
  ProgramNode,
  ProcedureNode,
  FunctionNode,
  StatementNode,
  ExpressionNode,
  VarDecl,
  GlobalVarDecl,
  ConstDecl,
  GlobalConstDecl,
  DataType,
  VarType,
  isArrayType,
  ArrayType,
} from "./ast";
import { ResolvedProgram, ResolvedModule } from "./resolver";

interface Variable {
  name: string;
  varType: VarType;
  address: number;
  size: number;
}

interface Constant {
  name: string;
  varType: VarType;
  value: number;
}

interface FunctionSignature {
  params: VarDecl[];
  returnType: DataType | null;  // null for procedures
}

export class CodeGenerator {
  private output: string[] = [];
  private variables: Map<string, Variable> = new Map();
  private constants: Map<string, Constant> = new Map();
  private functionSignatures: Map<string, FunctionSignature> = new Map();
  private nextZpAddress: number = 0x02; // Start after zero page system locations
  private nextRamAddress: number = 0x0800; // Start of free RAM on C64
  private labelCounter: number = 0;
  private currentProc: string = "";
  private currentReturnType: DataType | null = null;

  generate(program: ProgramNode): string {
    this.output = [];
    this.variables.clear();
    this.constants.clear();
    this.functionSignatures.clear();
    this.nextZpAddress = 0x02;
    this.nextRamAddress = 0x0800;
    this.labelCounter = 0;

    // Build function signature table
    for (const proc of program.procedures) {
      this.functionSignatures.set(proc.name, {
        params: proc.params,
        returnType: null,
      });
    }
    for (const func of program.functions) {
      this.functionSignatures.set(func.name, {
        params: func.params,
        returnType: func.returnType,
      });
    }

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
      this.emit("  jsr $ffcc    ; CLRCHN - reset I/O channels");
      this.emit("  jsr main");
      this.emit("  rts");
      this.emit("");
    } else {
      // Default: C64 BASIC start with auto-run stub
      this.emit("  .org $0801");
      this.emit("");
      this.emit("; BASIC stub: 10 SYS 2061");
      this.emit("  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00");
      this.emit("");
      this.emit("; Program start");
      this.emit("start:");
      this.emit("  jsr main");
      this.emit("  rts");
      this.emit("");
    }

    // Allocate global variables
    for (const global of program.globals) {
      this.allocateGlobalVariable(global);
    }

    // Register global constants (no memory allocation needed)
    for (const c of program.globalConsts) {
      this.registerConstant(c);
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
      this.emitBytes(v.size);
    }

    return this.output.join("\n");
  }

  generateFromResolved(resolved: ResolvedProgram): string {
    this.output = [];
    this.variables.clear();
    this.constants.clear();
    this.functionSignatures.clear();
    this.nextZpAddress = 0x02;
    this.nextRamAddress = 0x0800;
    this.labelCounter = 0;

    const mainProgram = resolved.mainModule.program;

    // Build function signature table from all modules
    for (const dep of resolved.dependencies) {
      for (const proc of dep.program.procedures) {
        if (proc.isPublic || dep.filePath === resolved.mainModule.filePath) {
          this.functionSignatures.set(proc.name, {
            params: proc.params,
            returnType: null,
          });
        }
      }
      for (const func of dep.program.functions) {
        if (func.isPublic || dep.filePath === resolved.mainModule.filePath) {
          this.functionSignatures.set(func.name, {
            params: func.params,
            returnType: func.returnType,
          });
        }
      }
    }
    for (const proc of mainProgram.procedures) {
      this.functionSignatures.set(proc.name, {
        params: proc.params,
        returnType: null,
      });
    }
    for (const func of mainProgram.functions) {
      this.functionSignatures.set(func.name, {
        params: func.params,
        returnType: func.returnType,
      });
    }

    // Header
    this.emit(`; pas6510 compiled program: ${mainProgram.name}`);
    this.emit(`;`);
    this.emit("");

    if (mainProgram.org !== undefined) {
      // Custom origin - no BASIC stub
      const orgHex = mainProgram.org.toString(16).toUpperCase().padStart(4, "0");
      this.emit(`  .org $${orgHex}`);
      this.emit("");
      this.emit("; Program start");
      this.emit("start:");
      this.emit("  jsr $ffcc    ; CLRCHN - reset I/O channels");
      this.emit("  jsr main");
      this.emit("  rts");
      this.emit("");
    } else {
      // Default: C64 BASIC start with auto-run stub
      this.emit("  .org $0801");
      this.emit("");
      this.emit("; BASIC stub: 10 SYS 2061");
      this.emit("  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00");
      this.emit("");
      this.emit("; Program start");
      this.emit("start:");
      this.emit("  jsr main");
      this.emit("  rts");
      this.emit("");
    }

    // First, generate code for all dependencies (imported modules)
    // Only include public procedures, functions, and variables
    for (const dep of resolved.dependencies) {
      if (dep.filePath === resolved.mainModule.filePath) continue;

      this.emit(`; Module: ${dep.program.name}`);

      // Allocate public global variables
      for (const global of dep.program.globals) {
        if (global.isPublic) {
          this.allocateGlobalVariable(global);
        }
      }

      // Register public constants
      for (const c of dep.program.globalConsts) {
        if (c.isPublic) {
          this.registerConstant(c);
        }
      }

      // Generate public procedures
      for (const proc of dep.program.procedures) {
        if (proc.isPublic) {
          this.generateProcedure(proc);
        }
      }

      // Generate public functions
      for (const func of dep.program.functions) {
        if (func.isPublic) {
          this.generateFunction(func);
        }
      }
    }

    // Now generate the main module
    this.emit(`; Main module: ${mainProgram.name}`);

    // Allocate global variables
    for (const global of mainProgram.globals) {
      this.allocateGlobalVariable(global);
    }

    // Register global constants
    for (const c of mainProgram.globalConsts) {
      this.registerConstant(c);
    }

    // Generate all procedures (public and private)
    for (const proc of mainProgram.procedures) {
      this.generateProcedure(proc);
    }

    // Generate all functions (public and private)
    for (const func of mainProgram.functions) {
      this.generateFunction(func);
    }

    // Runtime library
    this.generateRuntime();

    // Variable storage
    this.emit("");
    this.emit("; Variables");
    for (const [name, v] of this.variables) {
      this.emit(`${this.varLabel(name)}:`);
      this.emitBytes(v.size);
    }

    return this.output.join("\n");
  }

  private emit(line: string): void {
    this.output.push(line);
  }

  private emitBytes(count: number): void {
    const zeros = new Array(count).fill("0").join(", ");
    this.emit(`  .byte ${zeros}`);
  }

  private newLabel(prefix: string): string {
    return `_${prefix}_${this.labelCounter++}`;
  }

  private varLabel(name: string): string {
    return `_var_${name}`;
  }

  // Returns the constant value if expr is a compile-time constant, null otherwise
  private getConstantValue(expr: ExpressionNode): number | null {
    if (expr.kind === "NumberLiteral") {
      return expr.value;
    }
    if (expr.kind === "Variable") {
      const c = this.constants.get(expr.name);
      if (c) {
        return c.value;
      }
    }
    return null;
  }

  // Format address for 6510 assembly (use hex for readability)
  private formatAddr(addr: number): string {
    return "$" + addr.toString(16).padStart(4, "0");
  }

  // Check if expression is base + index where base is constant and index is u8 variable
  private getIndexedAddress(expr: ExpressionNode): { base: number; indexVar: string } | null {
    if (expr.kind !== "BinaryOp" || expr.operator !== "+") {
      return null;
    }

    // Check if left is constant and right is u8 variable
    const baseConst = this.getConstantValue(expr.left);
    if (baseConst !== null && expr.right.kind === "Variable") {
      const v = this.variables.get(expr.right.name);
      if (v && (v.varType === "u8" || v.varType === "i8")) {
        return { base: baseConst, indexVar: expr.right.name };
      }
    }

    // Check reverse: right is constant, left is u8 variable
    const baseConst2 = this.getConstantValue(expr.right);
    if (baseConst2 !== null && expr.left.kind === "Variable") {
      const v = this.variables.get(expr.left.name);
      if (v && (v.varType === "u8" || v.varType === "i8")) {
        return { base: baseConst2, indexVar: expr.left.name };
      }
    }

    return null;
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

  private allocateGlobalVariable(decl: GlobalVarDecl): Variable {
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

  private registerConstant(decl: GlobalConstDecl | ConstDecl): void {
    const c: Constant = {
      name: decl.name,
      varType: decl.varType,
      value: decl.value,
    };
    this.constants.set(decl.name, c);
  }

  private generateProcedure(proc: ProcedureNode): void {
    this.currentProc = proc.name;
    this.currentReturnType = null;
    this.emit(`; Procedure: ${proc.name}`);
    this.emit(`${proc.name}:`);

    // Allocate parameters as variables (caller stores values before jsr)
    for (const param of proc.params) {
      this.allocateVariable(param);
    }

    // Allocate local variables
    for (const local of proc.locals) {
      this.allocateVariable(local);
    }

    // Register local constants
    for (const c of proc.localConsts) {
      this.registerConstant(c);
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
    this.currentReturnType = func.returnType;
    this.emit(`; Function: ${func.name}`);
    this.emit(`${func.name}:`);

    // Allocate parameters as variables (caller stores values before jsr)
    for (const param of func.params) {
      this.allocateVariable(param);
    }

    // Allocate local variables
    for (const local of func.locals) {
      this.allocateVariable(local);
    }

    // Register local constants
    for (const c of func.localConsts) {
      this.registerConstant(c);
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
      // Check if trying to assign to a constant
      if (this.constants.has(target.name)) {
        throw new Error(`Cannot assign to constant: ${target.name}`);
      }
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

    // Loop start
    this.emit(`${loopLabel}:`);

    // Generate body
    for (const s of stmt.body) {
      this.generateStatement(s);
    }

    // Increment and compare
    this.emit(`  inc ${this.varLabel(stmt.variable)}`);
    this.emit(`  lda ${this.varLabel(stmt.variable)}`);

    // Compare with end value (use jmp for long loops)
    if (stmt.end.kind === "NumberLiteral") {
      if (stmt.end.value === 255) {
        // Special case: 0-255 loop - check if wrapped to 0
        this.emit(`  bne ${loopLabel}`);
        this.emit(`${endLabel}:`);
      } else {
        this.emit(`  cmp #${stmt.end.value + 1}`);
        this.emit(`  beq ${endLabel}`);
        this.emit(`  jmp ${loopLabel}`);
        this.emit(`${endLabel}:`);
      }
    } else {
      // Need to evaluate end expression and compare
      this.generateExpr8(stmt.end);
      this.emit(`  clc`);
      this.emit(`  adc #1`);
      this.emit(`  cmp ${this.varLabel(stmt.variable)}`);
      this.emit(`  bcc ${endLabel}`);
      this.emit(`  jmp ${loopLabel}`);
      this.emit(`${endLabel}:`);
    }
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

  // Helper to emit a "long branch" that works for any distance
  // Uses inverted short branch over a jmp
  private emitLongBranch(branchIfTrue: string, falseLabel: string): void {
    const skipLabel = this.newLabel("skip");
    this.emit(`  ${branchIfTrue} ${skipLabel}`);
    this.emit(`  jmp ${falseLabel}`);
    this.emit(`${skipLabel}:`);
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

      // Use long branches to avoid range errors
      switch (op) {
        case "=":
          // Jump to false if not equal; skip if equal
          this.emitLongBranch("beq", falseLabel);
          break;
        case "<>":
          // Jump to false if equal; skip if not equal
          this.emitLongBranch("bne", falseLabel);
          break;
        case "<":
          // Jump to false if >= (carry set); skip if < (carry clear)
          this.emitLongBranch("bcc", falseLabel);
          break;
        case ">=":
          // Jump to false if < (carry clear); skip if >= (carry set)
          this.emitLongBranch("bcs", falseLabel);
          break;
        case ">":
          // A > B is TRUE only if: (not equal) AND (A >= B, carry set)
          // Go to falseLabel if: equal OR (A < B, carry clear)
          const gtFalse = this.newLabel("gt_false");
          const gtCont = this.newLabel("gt_cont");
          this.emit(`  beq ${gtFalse}`);   // If equal, A > B is false
          this.emit(`  bcs ${gtCont}`);    // If A >= B (and not equal), A > B is true
          this.emit(`${gtFalse}:`);        // equal or A < B: condition is false
          this.emit(`  jmp ${falseLabel}`);
          this.emit(`${gtCont}:`);
          break;
        case "<=":
          // A <= B is TRUE if: equal OR (A < B, carry clear)
          // Go to falseLabel if: (not equal) AND (A >= B, carry set), i.e., A > B
          const leFalse = this.newLabel("le_false");
          const leCont = this.newLabel("le_cont");
          this.emit(`  beq ${leCont}`);    // If equal, A <= B is true, continue
          this.emit(`  bcc ${leCont}`);    // If A < B, A <= B is true, continue
          this.emit(`  jmp ${falseLabel}`);// A > B, condition is false
          this.emit(`${leCont}:`);
          break;
      }
    } else {
      // Simple boolean - zero is false
      this.generateExpr8(expr);
      this.emitLongBranch("bne", falseLabel);
    }
  }

  private generateCall(stmt: { name: string; args: ExpressionNode[] }): void {
    // Handle built-in CPU instructions
    if (stmt.name === "irq_enable") {
      this.emit(`  cli`);
      return;
    } else if (stmt.name === "irq_disable") {
      this.emit(`  sei`);
      return;
    }

    // Handle built-in functions with arguments
    if (stmt.name === "write_u16_ln") {
      // Pass 16-bit argument in A (low) and X (high)
      this.generateExpr16(stmt.args[0]);
      this.emit(`  jsr ${stmt.name}`);
      return;
    } else if (stmt.name === "print_char") {
      // Print single character - pass in A
      this.generateExpr8(stmt.args[0]);
      this.emit(`  jsr $ffd2  ; CHROUT`);
      return;
    } else if (stmt.name === "poke") {
      // poke(addr, value) - write value to memory address
      const addrConst = this.getConstantValue(stmt.args[0]);
      if (addrConst !== null) {
        // Constant address - use direct addressing
        this.generateExpr8(stmt.args[1]);
        this.emit(`  sta ${this.formatAddr(addrConst)}`);
      } else {
        // Check for indexed addressing (base + index)
        const indexed = this.getIndexedAddress(stmt.args[0]);
        if (indexed) {
          // Use absolute,Y addressing
          this.emit(`  ldy ${this.varLabel(indexed.indexVar)}`);
          this.generateExpr8(stmt.args[1]);
          this.emit(`  sta ${this.formatAddr(indexed.base)},y`);
        } else {
          // Variable address - use indirect addressing
          this.generateExpr16(stmt.args[0]);
          this.emit(`  sta _poke_addr`);
          this.emit(`  stx _poke_addr+1`);
          this.generateExpr8(stmt.args[1]);
          this.emit(`  ldy #0`);
          this.emit(`  sta (_poke_addr),y`);
        }
      }
      return;
    } else if (stmt.name === "inc") {
      // inc(addr) - increment memory location
      const addrConst = this.getConstantValue(stmt.args[0]);
      if (addrConst !== null) {
        this.emit(`  inc ${this.formatAddr(addrConst)}`);
      } else if (stmt.args[0].kind === "Variable") {
        // Variable reference - check type
        const v = this.variables.get(stmt.args[0].name);
        if (v) {
          if (this.is16Bit(v.varType)) {
            // 16-bit increment
            const skip = this.newLabel("inc16");
            this.emit(`  inc ${this.varLabel(stmt.args[0].name)}`);
            this.emit(`  bne ${skip}`);
            this.emit(`  inc ${this.varLabel(stmt.args[0].name)}+1`);
            this.emit(`${skip}:`);
          } else {
            // 8-bit increment
            this.emit(`  inc ${this.varLabel(stmt.args[0].name)}`);
          }
        } else {
          throw new Error(`Unknown variable: ${stmt.args[0].name}`);
        }
      } else {
        // Check for indexed addressing (base + index) - uses X register
        const indexed = this.getIndexedAddress(stmt.args[0]);
        if (indexed) {
          this.emit(`  ldx ${this.varLabel(indexed.indexVar)}`);
          this.emit(`  inc ${this.formatAddr(indexed.base)},x`);
        } else {
          throw new Error("inc() requires a constant address or variable");
        }
      }
      return;
    } else if (stmt.name === "dec") {
      // dec(addr) - decrement memory location
      const addrConst = this.getConstantValue(stmt.args[0]);
      if (addrConst !== null) {
        this.emit(`  dec ${this.formatAddr(addrConst)}`);
      } else if (stmt.args[0].kind === "Variable") {
        // Variable reference - check type
        const v = this.variables.get(stmt.args[0].name);
        if (v) {
          if (this.is16Bit(v.varType)) {
            // 16-bit decrement - check if low byte is 0 before decrementing
            const skip = this.newLabel("dec16");
            this.emit(`  lda ${this.varLabel(stmt.args[0].name)}`);
            this.emit(`  bne ${skip}`);
            this.emit(`  dec ${this.varLabel(stmt.args[0].name)}+1`);
            this.emit(`${skip}:`);
            this.emit(`  dec ${this.varLabel(stmt.args[0].name)}`);
          } else {
            // 8-bit decrement
            this.emit(`  dec ${this.varLabel(stmt.args[0].name)}`);
          }
        } else {
          throw new Error(`Unknown variable: ${stmt.args[0].name}`);
        }
      } else {
        // Check for indexed addressing (base + index) - uses X register
        const indexed = this.getIndexedAddress(stmt.args[0]);
        if (indexed) {
          this.emit(`  ldx ${this.varLabel(indexed.indexVar)}`);
          this.emit(`  dec ${this.formatAddr(indexed.base)},x`);
        } else {
          throw new Error("dec() requires a constant address or variable");
        }
      }
      return;
    }

    // Look up function signature for user-defined functions
    const sig = this.functionSignatures.get(stmt.name);
    if (sig && sig.params.length > 0) {
      // Store arguments to parameter variables
      for (let i = 0; i < stmt.args.length && i < sig.params.length; i++) {
        const param = sig.params[i];
        const paramType = param.varType;
        const is16Bit = paramType === "i16" || paramType === "u16" || paramType === "ptr";

        if (is16Bit) {
          this.generateExpr16(stmt.args[i]);
          this.emit(`  sta ${this.varLabel(param.name)}`);
          this.emit(`  stx ${this.varLabel(param.name)}+1`);
        } else {
          this.generateExpr8(stmt.args[i]);
          this.emit(`  sta ${this.varLabel(param.name)}`);
        }
      }
    }
    this.emit(`  jsr ${stmt.name}`);
  }

  private generateReturn(stmt: { value?: ExpressionNode }): void {
    if (stmt.value) {
      // Use 16-bit return for i16, u16, ptr types
      const is16Bit = this.currentReturnType === "i16" ||
                      this.currentReturnType === "u16" ||
                      this.currentReturnType === "ptr";
      if (is16Bit) {
        this.generateExpr16(stmt.value);
      } else {
        this.generateExpr8(stmt.value);
      }
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
        // Check if it's a constant first
        const c8 = this.constants.get(expr.name);
        if (c8) {
          this.emit(`  lda #${c8.value & 0xff}`);
          break;
        }
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
        // Handle built-in peek function
        if (expr.name === "peek" && expr.args.length === 1) {
          // peek(addr) - read byte from memory address
          const addrConst = this.getConstantValue(expr.args[0]);
          if (addrConst !== null) {
            // Constant address - use direct addressing
            this.emit(`  lda ${this.formatAddr(addrConst)}`);
          } else {
            // Check for indexed addressing (base + index)
            const indexed = this.getIndexedAddress(expr.args[0]);
            if (indexed) {
              // Use absolute,Y addressing
              this.emit(`  ldy ${this.varLabel(indexed.indexVar)}`);
              this.emit(`  lda ${this.formatAddr(indexed.base)},y`);
            } else {
              // Variable address - use indirect addressing
              this.generateExpr16(expr.args[0]);
              this.emit(`  sta _poke_addr`);
              this.emit(`  stx _poke_addr+1`);
              this.emit(`  ldy #0`);
              this.emit(`  lda (_poke_addr),y`);
            }
          }
        } else {
          // Regular function call - store arguments to parameter variables
          const sig = this.functionSignatures.get(expr.name);
          if (sig && sig.params.length > 0) {
            for (let i = 0; i < expr.args.length && i < sig.params.length; i++) {
              const param = sig.params[i];
              const paramIs16Bit = param.varType === "i16" ||
                                   param.varType === "u16" ||
                                   param.varType === "ptr";
              if (paramIs16Bit) {
                this.generateExpr16(expr.args[i]);
                this.emit(`  sta ${this.varLabel(param.name)}`);
                this.emit(`  stx ${this.varLabel(param.name)}+1`);
              } else {
                this.generateExpr8(expr.args[i]);
                this.emit(`  sta ${this.varLabel(param.name)}`);
              }
            }
          }
          this.emit(`  jsr ${expr.name}`);
        }
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
        const lo = expr.value & 0xff;
        const hi = (expr.value >> 8) & 0xff;
        this.emit(`  lda #${lo}`);
        this.emit(`  ldx #${hi}`);
        break;

      case "Variable":
        // Check if it's a constant first
        const c16 = this.constants.get(expr.name);
        if (c16) {
          const cLo = c16.value & 0xff;
          const cHi = (c16.value >> 8) & 0xff;
          this.emit(`  lda #${cLo}`);
          this.emit(`  ldx #${cHi}`);
          break;
        }
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

      case "CallExpr":
        // Function call - look up signature
        const callSig = this.functionSignatures.get(expr.name);
        const funcReturnType = callSig?.returnType;
        const returns16Bit = funcReturnType === "i16" ||
                             funcReturnType === "u16" ||
                             funcReturnType === "ptr";

        // Store arguments to parameter variables
        if (callSig && callSig.params.length > 0) {
          for (let i = 0; i < expr.args.length && i < callSig.params.length; i++) {
            const param = callSig.params[i];
            const paramIs16Bit = param.varType === "i16" ||
                                 param.varType === "u16" ||
                                 param.varType === "ptr";
            if (paramIs16Bit) {
              this.generateExpr16(expr.args[i]);
              this.emit(`  sta ${this.varLabel(param.name)}`);
              this.emit(`  stx ${this.varLabel(param.name)}+1`);
            } else {
              this.generateExpr8(expr.args[i]);
              this.emit(`  sta ${this.varLabel(param.name)}`);
            }
          }
        }

        this.emit(`  jsr ${expr.name}`);
        // If function returns 8-bit, zero-extend to 16-bit
        if (!returns16Bit) {
          this.emit(`  ldx #0`);
        }
        // Result in A (low) and X (high)
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
    this.emit("_tmp: .byte 0, 0");
    this.emit("_tmp16: .byte 0, 0");
    this.emit("");

    // Zero page pointer for poke/peek (must be in ZP for indirect addressing)
    this.emit("_poke_addr = $fb  ; ZP location for indirect addressing");
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
    this.emit("_print_val: .byte 0, 0");
    this.emit("_print_buf: .byte 0, 0, 0, 0, 0, 0");
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
    this.emit("_d10_loop:");
    this.emit("  asl _print_val");
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
