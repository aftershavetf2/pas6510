# pas6510

A Pascal-like compiler targeting the MOS 6510 CPU (Commodore 64).

## Installation

Requires Node.js and [cc65](https://cc65.github.io/) toolchain.

```bash
npm install
npm run build
npm link
```

## Usage

```bash
pas6510 program.pas              # Creates program.asm and program.prg
pas6510 program.pas --asm-only   # Assembly output only
```

## Example

```pascal
program adder

proc main()
    var sum : u16;
    var i : u8;

    sum := 0;
    for i = 0 to 10 do
        sum := sum + i;
    end;

    write_u16_ln(sum);
end;
```

Output: `55`

## Language

| Pascal      | pas6510                  |
| ----------- | ------------------------ |
| `procedure` | `proc`                   |
| `function`  | `func`                   |
| `begin`     | `do`                     |
| `integer`   | `i8`, `i16`, `u8`, `u16` |

**Types:** `i8`, `i16`, `u8`, `u16`, `ptr`, `array[n] of T`

**Directives:** `{ORG 0x1000}` sets load address (default: $0801 with BASIC stub)

**Limitations:** No recursion. Code is not re-entrant.

## License

ISC
