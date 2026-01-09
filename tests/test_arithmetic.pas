import test_init, test_summary, assert_eq, expected_val, actual_val from "test_lib.pas";

program test_arithmetic

{ Test basic arithmetic operations }

proc main()
    var a: u16;
    var b: u16;

    test_init();

    { Test 1: Addition 8-bit }
    expected_val := 15;
    actual_val := 10 + 5;
    assert_eq();

    { Test 2: Addition 16-bit }
    expected_val := 1000;
    a := 600;
    b := 400;
    actual_val := a + b;
    assert_eq();

    { Test 3: Subtraction 8-bit }
    expected_val := 7;
    actual_val := 12 - 5;
    assert_eq();

    { Test 4: Subtraction 16-bit }
    expected_val := 500;
    a := 800;
    b := 300;
    actual_val := a - b;
    assert_eq();

    { Test 5: Multiplication 8-bit }
    expected_val := 56;
    actual_val := 7 * 8;
    assert_eq();

    { Test 6: Division 8-bit }
    expected_val := 5;
    actual_val := 25 / 5;
    assert_eq();

    { Test 7: Complex expression }
    expected_val := 17;
    actual_val := 3 + 4 * 2 + 6;
    assert_eq();

    { Test 8: Zero addition }
    expected_val := 42;
    actual_val := 42 + 0;
    assert_eq();

    { Test 9: Zero multiplication }
    expected_val := 0;
    actual_val := 42 * 0;
    assert_eq();

    { Test 10: Multiplication by 1 }
    expected_val := 99;
    actual_val := 99 * 1;
    assert_eq();

    test_summary();
end;
