// Peephole optimizer for 6510 assembly

interface Instruction {
  raw: string;
  mnemonic: string;
  operand: string;
  isLabel: boolean;
  isComment: boolean;
  isDirective: boolean;
}

// Parse a line of assembly into an instruction object
function parseLine(line: string): Instruction {
  const trimmed = line.trim();

  // Empty line
  if (trimmed === "") {
    return { raw: line, mnemonic: "", operand: "", isLabel: false, isComment: false, isDirective: false };
  }

  // Comment line
  if (trimmed.startsWith(";")) {
    return { raw: line, mnemonic: "", operand: "", isLabel: false, isComment: true, isDirective: false };
  }

  // Label (ends with :)
  if (trimmed.endsWith(":") && !trimmed.includes(" ")) {
    return { raw: line, mnemonic: "", operand: "", isLabel: true, isComment: false, isDirective: false };
  }

  // Directive (starts with .)
  if (trimmed.startsWith(".") || trimmed.match(/^\s*\./)) {
    return { raw: line, mnemonic: "", operand: "", isLabel: false, isComment: false, isDirective: true };
  }

  // Check for label: directive pattern (e.g., "_tmp: .byte 0")
  if (trimmed.includes(":") && trimmed.includes(".")) {
    return { raw: line, mnemonic: "", operand: "", isLabel: false, isComment: false, isDirective: true };
  }

  // Check for ZP assignment (e.g., "_poke_addr = $fb")
  if (trimmed.includes("=") && !trimmed.startsWith(";")) {
    return { raw: line, mnemonic: "", operand: "", isLabel: false, isComment: false, isDirective: true };
  }

  // Instruction
  const parts = trimmed.split(/\s+/);
  const mnemonic = parts[0].toLowerCase();
  const operand = parts.slice(1).join(" ").split(";")[0].trim(); // Remove inline comments

  return { raw: line, mnemonic, operand, isLabel: false, isComment: false, isDirective: false };
}

// Check if instruction is a branch or jump
function isBranchOrJump(mnemonic: string): boolean {
  return ["jmp", "jsr", "beq", "bne", "bcc", "bcs", "bpl", "bmi", "bvc", "bvs", "rts", "rti", "brk"].includes(mnemonic);
}

// Check if instruction modifies A register
function modifiesA(mnemonic: string): boolean {
  return ["lda", "pla", "txa", "tya", "adc", "sbc", "and", "ora", "eor", "asl", "lsr", "rol", "ror"].includes(mnemonic);
}

// Check if instruction modifies X register
function modifiesX(mnemonic: string): boolean {
  return ["ldx", "tax", "tsx", "inx", "dex"].includes(mnemonic);
}

// Check if instruction modifies Y register
function modifiesY(mnemonic: string): boolean {
  return ["ldy", "tay", "iny", "dey"].includes(mnemonic);
}

// Check if instruction reads A register
function readsA(mnemonic: string, operand: string): boolean {
  if (["sta", "pha", "tax", "tay", "adc", "sbc", "and", "ora", "eor", "cmp"].includes(mnemonic)) {
    return true;
  }
  // ASL, LSR, ROL, ROR with no operand (implied A)
  if (["asl", "lsr", "rol", "ror"].includes(mnemonic) && operand === "") {
    return true;
  }
  return false;
}

// Track register contents for redundant load elimination
interface RegisterState {
  a: string | null;  // What's currently in A (operand string, or null if unknown)
  x: string | null;  // What's currently in X
  y: string | null;  // What's currently in Y
}

// Check if an operand might be modified by a STA/STX/STY
// e.g., if we STA to _var_main_x, then a subsequent LDA _var_main_x might get a different value
function operandMightBeModified(storeOperand: string, loadOperand: string): boolean {
  // If storing to the same address we loaded from, it's modified
  if (storeOperand === loadOperand) return true;
  // Indexed stores might modify anything in that range
  if (storeOperand.includes(",")) return false; // Be conservative - indexed stores don't invalidate non-indexed loads
  return false;
}

// Eliminate redundant loads by tracking register contents
function eliminateRedundantLoads(instructions: Instruction[]): { result: Instruction[], changed: boolean } {
  const result: Instruction[] = [];
  let changed = false;

  // Track what we know is in each register
  let regState: RegisterState = { a: null, x: null, y: null };

  for (const instr of instructions) {
    // Labels invalidate all register knowledge (could be jumped to from anywhere)
    if (instr.isLabel) {
      regState = { a: null, x: null, y: null };
      result.push(instr);
      continue;
    }

    // Non-instructions pass through
    if (instr.isComment || instr.isDirective || instr.mnemonic === "") {
      result.push(instr);
      continue;
    }

    const mn = instr.mnemonic;
    const op = instr.operand;

    // Check for redundant loads
    if (mn === "lda" && regState.a === op) {
      // Already have this value in A, skip the load
      changed = true;
      continue;
    }
    if (mn === "ldx" && regState.x === op) {
      // Already have this value in X, skip the load
      changed = true;
      continue;
    }
    if (mn === "ldy" && regState.y === op) {
      // Already have this value in Y, skip the load
      changed = true;
      continue;
    }

    // Update register state based on instruction
    switch (mn) {
      case "lda":
        regState.a = op;
        break;
      case "ldx":
        regState.x = op;
        break;
      case "ldy":
        regState.y = op;
        break;
      case "sta":
        // STA doesn't change A, but might invalidate other loads from that address
        if (regState.x && operandMightBeModified(op, regState.x)) regState.x = null;
        if (regState.y && operandMightBeModified(op, regState.y)) regState.y = null;
        // Also invalidate A if it was loaded from the same place (value might be different now... but actually STA doesn't change what's in A)
        break;
      case "stx":
        // STX doesn't change X
        if (regState.a && operandMightBeModified(op, regState.a)) regState.a = null;
        if (regState.y && operandMightBeModified(op, regState.y)) regState.y = null;
        break;
      case "sty":
        // STY doesn't change Y
        if (regState.a && operandMightBeModified(op, regState.a)) regState.a = null;
        if (regState.x && operandMightBeModified(op, regState.x)) regState.x = null;
        break;
      case "tax":
        regState.x = regState.a; // X now has same as A
        break;
      case "tay":
        regState.y = regState.a; // Y now has same as A
        break;
      case "txa":
        regState.a = regState.x; // A now has same as X
        break;
      case "tya":
        regState.a = regState.y; // A now has same as Y
        break;
      case "pla":
        regState.a = null; // Unknown value from stack
        break;
      case "pha":
        // Doesn't change A
        break;
      case "inx":
      case "dex":
        regState.x = null; // X changed
        break;
      case "iny":
      case "dey":
        regState.y = null; // Y changed
        break;
      case "inc":
      case "dec":
        // Memory modified - invalidate if any register was loaded from there
        if (regState.a === op) regState.a = null;
        if (regState.x === op) regState.x = null;
        if (regState.y === op) regState.y = null;
        break;
      case "adc":
      case "sbc":
      case "and":
      case "ora":
      case "eor":
      case "asl":
      case "lsr":
      case "rol":
      case "ror":
        // These modify A (when operating on A)
        if (op === "" || op === "a") {
          regState.a = null;
        } else {
          // Operating on memory, A is modified
          regState.a = null;
        }
        break;
      case "jsr":
        // Function call - assume all registers might be modified
        regState = { a: null, x: null, y: null };
        break;
      case "jmp":
      case "beq":
      case "bne":
      case "bcc":
      case "bcs":
      case "bpl":
      case "bmi":
      case "bvc":
      case "bvs":
        // Branches/jumps - invalidate state since control flow might come from elsewhere
        // Actually for forward branches we might keep state, but be conservative
        regState = { a: null, x: null, y: null };
        break;
      case "rts":
      case "rti":
        regState = { a: null, x: null, y: null };
        break;
      // CMP, CPX, CPY don't modify registers
      case "cmp":
      case "cpx":
      case "cpy":
      case "bit":
      case "clc":
      case "sec":
      case "cli":
      case "sei":
      case "clv":
      case "nop":
        // These don't modify A, X, or Y
        break;
      default:
        // Unknown instruction - be safe and clear state
        regState = { a: null, x: null, y: null };
    }

    result.push(instr);
  }

  return { result, changed };
}

export function peepholeOptimize(lines: string[]): string[] {
  // Parse all lines
  let instructions = lines.map(parseLine);
  let changed = true;
  let passes = 0;
  const maxPasses = 10;

  while (changed && passes < maxPasses) {
    changed = false;
    passes++;

    // First: eliminate redundant loads using register tracking
    const loadElim = eliminateRedundantLoads(instructions);
    if (loadElim.changed) {
      changed = true;
      instructions = loadElim.result;
    }
    const optimized: Instruction[] = [];

    for (let i = 0; i < instructions.length; i++) {
      const curr = instructions[i];
      const next = i + 1 < instructions.length ? instructions[i + 1] : null;
      const next2 = i + 2 < instructions.length ? instructions[i + 2] : null;

      // Skip non-instructions
      if (curr.isLabel || curr.isComment || curr.isDirective || curr.mnemonic === "") {
        optimized.push(curr);
        continue;
      }

      // Pattern 1: Remove redundant STA followed by LDA to same address
      // sta X / lda X → sta X (keep value in A)
      if (curr.mnemonic === "sta" && next && next.mnemonic === "lda" &&
          curr.operand === next.operand && !next.isLabel) {
        optimized.push(curr);
        i++; // Skip the LDA
        changed = true;
        continue;
      }

      // Pattern 2: Remove double RTS
      if (curr.mnemonic === "rts" && next && next.mnemonic === "rts" && !next.isLabel) {
        optimized.push(curr);
        i++; // Skip duplicate RTS
        changed = true;
        continue;
      }

      // Pattern 3: Remove redundant LDX #0 followed by LDX #0
      if (curr.mnemonic === "ldx" && curr.operand === "#0" &&
          next && next.mnemonic === "ldx" && next.operand === "#0" && !next.isLabel) {
        optimized.push(curr);
        i++; // Skip duplicate LDX
        changed = true;
        continue;
      }

      // Pattern 4: Remove redundant LDA #n followed by LDA #m
      if (curr.mnemonic === "lda" && curr.operand.startsWith("#") &&
          next && next.mnemonic === "lda" && !next.isLabel) {
        // Skip the first LDA, keep the second
        i++; // Don't push curr, will push next on next iteration
        i--; // But let the loop handle next naturally
        changed = true;
        continue;
      }

      // Pattern 5: Remove TAX followed by TXA (or vice versa) if no intervening X modification
      if (curr.mnemonic === "tax" && next && next.mnemonic === "txa" && !next.isLabel) {
        // TAX; TXA is redundant - A already has the value
        optimized.push(curr);
        i++; // Skip TXA
        changed = true;
        continue;
      }

      // Pattern 6: Remove TAY followed by TYA (or vice versa)
      if (curr.mnemonic === "tay" && next && next.mnemonic === "tya" && !next.isLabel) {
        optimized.push(curr);
        i++; // Skip TYA
        changed = true;
        continue;
      }

      // Pattern 7: STA _tmp / LDA _tmp optimization
      // This is tricky because _tmp is used as scratch space
      // Only optimize if nothing in between reads _tmp
      if (curr.mnemonic === "sta" && curr.operand === "_tmp" &&
          next && next.mnemonic === "lda" && next.operand === "_tmp" && !next.isLabel) {
        // Check if any instruction between STA and LDA uses _tmp differently
        // In this case they're adjacent, so safe to optimize
        optimized.push(curr);
        i++; // Skip the LDA _tmp
        changed = true;
        continue;
      }

      // Pattern 8: PHA immediately followed by PLA with nothing modifying stack
      if (curr.mnemonic === "pha" && next && next.mnemonic === "pla" && !next.isLabel) {
        // PHA; PLA does nothing except waste cycles
        i++; // Skip both
        changed = true;
        continue;
      }

      // Pattern 9: LDA X / PHA / LDA Y / STA _tmp / PLA → LDA Y / STA _tmp / LDA X
      // This is a common pattern in binary operations where we could avoid stack
      // (Complex - skip for now)

      // Pattern 10: Remove LDX #0 if X is already 0 from previous LDX #0
      // This requires tracking state, so we'll do a simpler version:
      // Two consecutive LDX instructions - keep only the second
      if (curr.mnemonic === "ldx" && next && next.mnemonic === "ldx" && !next.isLabel) {
        // Skip first LDX, keep second
        changed = true;
        continue;
      }

      // Pattern 11: Remove LDY #0 followed by LDY #0
      if (curr.mnemonic === "ldy" && curr.operand === "#0" &&
          next && next.mnemonic === "ldy" && next.operand === "#0" && !next.isLabel) {
        optimized.push(curr);
        i++;
        changed = true;
        continue;
      }

      // Pattern 12: CLC followed by SEC (or vice versa) - keep only the second
      if ((curr.mnemonic === "clc" && next && next.mnemonic === "sec" && !next.isLabel) ||
          (curr.mnemonic === "sec" && next && next.mnemonic === "clc" && !next.isLabel)) {
        // Skip the first, keep second
        changed = true;
        continue;
      }

      // Pattern 13: Remove INX/DEX pairs
      if (curr.mnemonic === "inx" && next && next.mnemonic === "dex" && !next.isLabel) {
        i++; // Skip both
        changed = true;
        continue;
      }
      if (curr.mnemonic === "dex" && next && next.mnemonic === "inx" && !next.isLabel) {
        i++;
        changed = true;
        continue;
      }

      // Pattern 14: Remove INY/DEY pairs
      if (curr.mnemonic === "iny" && next && next.mnemonic === "dey" && !next.isLabel) {
        i++;
        changed = true;
        continue;
      }
      if (curr.mnemonic === "dey" && next && next.mnemonic === "iny" && !next.isLabel) {
        i++;
        changed = true;
        continue;
      }

      // Pattern 15: JMP to next instruction (dead jump)
      if (curr.mnemonic === "jmp" && next && next.isLabel) {
        const targetLabel = curr.operand;
        const nextLabelRaw = next.raw.trim();
        if (nextLabelRaw === targetLabel + ":") {
          // JMP to immediately following label - remove the JMP
          changed = true;
          continue;
        }
      }

      // No optimization applied, keep instruction
      optimized.push(curr);
    }

    instructions = optimized;
  }

  // Return optimized lines
  return instructions.map(i => i.raw);
}

// Statistics helper
export function countInstructions(lines: string[]): number {
  let count = 0;
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed === "" || trimmed.startsWith(";") || trimmed.endsWith(":") ||
        trimmed.startsWith(".") || trimmed.includes("=")) {
      continue;
    }
    count++;
  }
  return count;
}
