program function_types_test

{ Comprehensive tests for functiontion parameter and return types }

{ ===== 8-bit functiontions ===== }

function identity_u8(x: u8): u8
    return x;
end;

function add_u8(a: u8, b: u8): u8
    return a + b;
end;

function double_u8(x: u8): u8
    var temp: u8;
    temp := x + x;
    return temp;
end;

function const_u8(): u8
    return 42;
end;

{ ===== 16-bit functiontions ===== }

function identity_u16(x: u16): u16
    return x;
end;

function add_u16(a: u16, b: u16): u16
    return a + b;
end;

function const_u16(): u16
    return 1000;
end;

function big_const(): u16
    return 40000;
end;

{ ===== Mixed type functiontions ===== }

function u8_to_u16(x: u8): u16
    return x;
end;

function sum_to_u16(a: u8, b: u8): u16
    var result: u16;
    result := a;
    result := result + b;
    return result;
end;

{ ===== Procedures (no return) ===== }

pub var global_val: u8;
pub var global_val16: u16;

procedure set_global(x: u8)
    global_val := x;
end;

procedure set_global16(x: u16)
    global_val16 := x;
end;

procedure increment_global()
    global_val := global_val + 1;
end;

{ ===== Test runner ===== }

procedure print_ok()
    print_char(79);  { O }
    print_char(75);  { K }
    print_char(32);  { space }
end;

procedure print_fail()
    print_char(70);  { F }
    print_char(65);  { A }
    print_char(73);  { I }
    print_char(76);  { L }
    print_char(32);  { space }
end;

procedure newline()
    print_char(13);
end;

procedure test_u8_identity()
    var result: u8;
    result := identity_u8(55);
    if result = 55 then
        print_ok();
    else
        print_fail();
    end;
end;

procedure test_u8_add()
    var result: u8;
    result := add_u8(10, 20);
    if result = 30 then
        print_ok();
    else
        print_fail();
    end;
end;

procedure test_u8_double()
    var result: u8;
    result := double_u8(25);
    if result = 50 then
        print_ok();
    else
        print_fail();
    end;
end;

procedure test_u8_const()
    var result: u8;
    result := const_u8();
    if result = 42 then
        print_ok();
    else
        print_fail();
    end;
end;

procedure test_u16_const()
    var result: u16;
    result := const_u16();
    { Expected: 1000 - show value }
    write_u16_ln(result);
end;

procedure test_u16_big()
    var result: u16;
    result := big_const();
    { Expected: 40000 - show value }
    write_u16_ln(result);
end;

procedure test_u8_to_u16()
    var result: u16;
    result := u8_to_u16(200);
    { Expected: 200 - show value }
    write_u16_ln(result);
end;

procedure test_procedureedure()
    set_global(99);
    if global_val = 99 then
        print_ok();
    else
        print_fail();
    end;
end;

procedure test_procedure_increment()
    global_val := 10;
    increment_global();
    increment_global();
    if global_val = 12 then
        print_ok();
    else
        print_fail();
    end;
end;

procedure main()
    { Print test header }
    print_char(84);  { T }
    print_char(69);  { E }
    print_char(83);  { S }
    print_char(84);  { T }
    print_char(83);  { S }
    print_char(58);  { : }
    newline();

    { 8-bit tests - show OK/FAIL }
    test_u8_identity();
    test_u8_add();
    test_u8_double();
    test_u8_const();
    newline();

    { 16-bit tests - show values }
    { Expected: 1000, 40000, 200 }
    test_u16_const();
    test_u16_big();
    test_u8_to_u16();

    { Procedure tests - show OK/FAIL }
    test_procedureedure();
    test_procedure_increment();

    newline();
    print_char(68);  { D }
    print_char(79);  { O }
    print_char(78);  { N }
    print_char(69);  { E }
    newline();
end;
