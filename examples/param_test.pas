program param_test

{ Simple parameter passing tests }

{ Single u8 parameter }
function inc_u8(x: u8): u8
    return x + 1;
end;

{ Two u8 parameters }
function add_u8(a: u8, b: u8): u8
    return a + b;
end;

{ Single u16 parameter }
function inc_u16(x: u16): u16
    return x + 1;
end;

{ Two u16 parameters }
function add_u16(a: u16, b: u16): u16
    return a + b;
end;

{ Mixed: u8 params, u16 return }
function mul_u8_to_u16(a: u8, b: u8): u16
    var result: u16;
    result := a;
    result := result * b;
    return result;
end;

{ Procedure with u8 param }
pub var last_value: u8;

procedure store_u8(x: u8)
    last_value := x;
end;

{ Procedure with u16 param }
pub var last_value16: u16;

procedure store_u16(x: u16)
    last_value16 := x;
end;

procedure main()
    var r8: u8;
    var r16: u16;

    { Test inc_u8 }
    r8 := inc_u8(41);
    write_u16_ln(r8);  { Expected: 42 }

    { Test add_u8 }
    r8 := add_u8(10, 32);
    write_u16_ln(r8);  { Expected: 42 }

    { Test inc_u16 }
    r16 := inc_u16(999);
    write_u16_ln(r16);  { Expected: 1000 }

    { Test add_u16 }
    r16 := add_u16(30000, 10000);
    write_u16_ln(r16);  { Expected: 40000 }

    { Test mul_u8_to_u16 }
    r16 := mul_u8_to_u16(200, 200);
    write_u16_ln(r16);  { Expected: 40000 }

    { Test store_u8 procedureedure }
    store_u8(77);
    write_u16_ln(last_value);  { Expected: 77 }

    { Test store_u16 procedureedure }
    store_u16(12345);
    write_u16_ln(last_value16);  { Expected: 12345 }
end;
