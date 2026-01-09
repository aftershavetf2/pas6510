# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

pas6510 is an optimizing Pascal-ish compiler for the 6510 CPU. It runs on a PC and compiles to 6510 assembly, then uses cc65 suite (ca65/ld65) to produce C64 PRG files.

## CLI Usage

```bash
pas6510 input.pas              # Creates input.asm and input.prg
pas6510 input.pas --asm-only   # Only creates input.asm
pas6510 input.pas -o out.prg   # Custom output filename
```

Requires cc65 suite installed (ca65, ld65).
Install globally with `npm link` after building.

## Build Commands

```bash
npm run build    # Compile TypeScript
npm run dev      # Watch mode - rerun on file changes
npm start        # Run CLI
```

## Project Structure

- `src/cli.ts` - Command-line interface (integrates ca65/ld65)
- `src/compiler/` - Compiler implementation
  - `tokens.ts` - Token types and keywords
  - `lexer.ts` - Tokenizer
  - `ast.ts` - AST node types
  - `parser.ts` - Parser (tokens → AST)
  - `codegen.ts` - Code generator (AST → 6510 assembly)
  - `resolver.ts` - Module resolver (handles imports)
- `examples/` - Example programs

## Language Features

The pas6510 language is Pascal-like with these differences:
- Types: `i8`, `i16`, `u8`, `u16`, `ptr`, `array[n] of T`
- `func` instead of `function`, `proc` instead of `procedure`
- `do`/`end` instead of `begin`/`end`
- No recursion (not re-entrant)
- Main proc required
- `{ORG 0x1000}` directive to set code origin

## Module System

Modules allow code reuse across files using `pub` and `import`.

### Exporting with `pub`

Use `pub` keyword before `proc`, `func`, or `var` to export:

```pascal
program math_module

pub var RESULT: u16;

pub proc calc_sum()
    var i: u8;
    RESULT := 0;
    for i = 1 to 5 do
        RESULT := RESULT + i;
    end;
end;

proc main()
end;
```

### Importing

Import statements must appear before `program`:

```pascal
import calc_sum, RESULT from "math.pas";

program main

proc main()
    calc_sum();
    write_u16_ln(RESULT);
end;
```

### Module Rules

- Import paths are relative to the importing file
- Transitive imports are supported (modules can import other modules)
- Circular imports produce a compile error
- Importing non-public symbols produces an error with helpful message
- Only `pub` symbols are included in the compiled output from imported modules

## Compiler Pipeline

1. Lexer tokenizes source code
2. Parser builds AST from tokens
3. CodeGenerator emits 6510 assembly
4. ca65 assembles to object file
5. ld65 links to binary, CLI adds PRG header
