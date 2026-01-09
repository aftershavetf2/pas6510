# pas6510

This is a optimizing Pascal-ish compiler for the 6510 CPU.
It is meant to run on a PC and compiles to 6510 assembly source code which then can be assembled using

# Deviantions from Pascal

It's has several deviations from traditional Pascal by using shorter names and slightly different semantics.

Keywords are all lower-case.

## Types it support:

- i8 as a signed 8-bit integer.
- i16 as a signed 16-bit integer.
- u8 as an unsigned 8-bit integer.
- u16 as an unsigned 16-bit integer.
- ptr to 16-bit pointer.
- array of is supported.
  - Max array size is 256 elements.
  - Start index is always 0.
  - Array of ptr is behind the scenes actually two arrays, one with the high-byte and one with the low-byte
- strings are supported as array of u8.

## Naming and other differences:

- Function is called func
- Procedure is called proc
- Begin is called do, End is still end.
- "end" is always terminated with a ";".
- Recursion is not allowed.
- There must be a main proc with no args.

## Limitations

Since the 6510 CPU is limited in many ways the compiler and language has some limitations.

- Code is not re-entrant. Recursion not allowed.
- Make parameters to proc:s and func:s global variables, or preferably even self-modifying code by directly settings the immediate/address values of load and store instructions inside the proc/func.

# Example program

```
    program adder

    proc main()
        var sum : u16;
        var i: u8;

        sum := 0;
        for i = 0 to 10 do
            sum := sum + i;
        end;

        write_u16_ln(sum);
    end;
```

Running this program will print

```
55
```
