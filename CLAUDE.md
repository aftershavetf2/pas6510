# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

pas6510 is an optimizing Pascal-ish compiler for the 6510 CPU. It runs on a PC and compiles to 6510 assembly source code.

## CLI Usage

```bash
pas6510 input.pas              # Creates input.asm
pas6510 input.pas -o out.asm   # Custom output filename
```

Install globally with `npm link` after building.

## Build Commands

```bash
npm run build    # Compile TypeScript
npm run dev      # Watch mode - rerun on file changes
npm start        # Run CLI (same as pas6510)
```

## Project Structure

- `src/cli.ts` - Command-line interface
- `src/compiler/` - Compiler implementation
  - `tokens.ts` - Token types and keywords
  - `lexer.ts` - Tokenizer
  - `ast.ts` - AST node types
  - `parser.ts` - Parser (tokens → AST)
  - `codegen.ts` - Code generator (AST → 6510 assembly)
- `examples/` - Example programs

## Language Features

The pas6510 language is Pascal-like with these differences:
- Types: `i8`, `i16`, `u8`, `u16`, `ptr`, `array[n] of T`
- `func` instead of `function`, `proc` instead of `procedure`
- `do`/`end` instead of `begin`/`end`
- No recursion (not re-entrant)
- Main proc required
- `{ORG 0x1000}` directive to set code origin

## Compiler Pipeline

1. Lexer tokenizes source code
2. Parser builds AST from tokens
3. CodeGenerator emits 6510 assembly with:
   - BASIC stub for auto-run on C64 (unless ORG specified)
   - Runtime library (multiply, divide, print)
   - Variable storage
