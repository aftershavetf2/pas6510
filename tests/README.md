# pas6510 Test Suite

These tests are designed to run on a real C64 or emulator. Each test produces a `.prg` file that can be loaded and run.

## Test Files

| Test | Description |
|------|-------------|
| `test_arithmetic.prg` | Basic arithmetic: addition, subtraction, multiplication, division |
| `test_loops.prg` | Loops and conditionals: for, while, if-then-else, comparisons |
| `test_arrays.prg` | Array operations: read, write, indexed access |
| `test_modules.prg` | Module system: imports, pub variables, pub procedures |

## Running Tests

### On VICE (C64 emulator)

```bash
x64 tests/test_arithmetic.prg
```

### On real C64

Transfer the `.prg` file to disk/SD card and load with:
```
LOAD "TEST_ARITHMETIC",8,1
RUN
```

## Expected Output

Each test displays results like:

```
TEST 1
PASS
TEST 2
PASS
TEST 3
FAIL
  EXPECTED: 42
  ACTUAL:   41
...
--------
PASSED: 9
FAILED: 1
```

## Test Library

All tests use `test_lib.pas` which provides:

- `test_init()` - Initialize test counters
- `assert_eq()` - Assert that `expected_val` equals `actual_val`
- `test_summary()` - Print final pass/fail counts

### Usage

```pascal
import test_init, test_summary, assert_eq, expected_val, actual_val from "test_lib.pas";

program my_test

proc main()
    test_init();

    { Test case }
    expected_val := 42;
    actual_val := 40 + 2;
    assert_eq();

    test_summary();
end;
```

## Compiling Tests

Rebuild all tests:

```bash
npm run build
node dist/cli.js tests/test_arithmetic.pas
node dist/cli.js tests/test_loops.pas
node dist/cli.js tests/test_arrays.pas
node dist/cli.js tests/test_modules.pas
```

Or assembly only (for inspection):

```bash
node dist/cli.js tests/test_arithmetic.pas --asm-only
```
