use test_lib;

program test_arithmetic

{ Test basic arithmetic operations }

procedure main()
    var a: u16;
    var b: u16;

    test_lib.test_init();

    { Test 1: Addition 8-bit }
    test_lib.expected_val := 15;
    test_lib.actual_val := 10 + 5;
    test_lib.assert_eq();

    { Test 2: Addition 16-bit }
    test_lib.expected_val := 1000;
    a := 600;
    b := 400;
    test_lib.actual_val := a + b;
    test_lib.assert_eq();

    { Test 3: Subtraction 8-bit }
    test_lib.expected_val := 7;
    test_lib.actual_val := 12 - 5;
    test_lib.assert_eq();

    { Test 4: Subtraction 16-bit }
    test_lib.expected_val := 500;
    a := 800;
    b := 300;
    test_lib.actual_val := a - b;
    test_lib.assert_eq();

    { Test 5: Multiplication 8-bit }
    test_lib.expected_val := 56;
    test_lib.actual_val := 7 * 8;
    test_lib.assert_eq();

    { Test 6: Division 8-bit }
    test_lib.expected_val := 5;
    test_lib.actual_val := 25 / 5;
    test_lib.assert_eq();

    { Test 7: Complex expression }
    test_lib.expected_val := 17;
    test_lib.actual_val := 3 + 4 * 2 + 6;
    test_lib.assert_eq();

    { Test 8: Zero addition }
    test_lib.expected_val := 42;
    test_lib.actual_val := 42 + 0;
    test_lib.assert_eq();

    { Test 9: Zero multiplication }
    test_lib.expected_val := 0;
    test_lib.actual_val := 42 * 0;
    test_lib.assert_eq();

    { Test 10: Multiplication by 1 }
    test_lib.expected_val := 99;
    test_lib.actual_val := 99 * 1;
    test_lib.assert_eq();

    test_lib.test_summary();
end;
