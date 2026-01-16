use test_lib;

program test_arrays

{ Test array operations }

procedure main()
    var arr: array[10] of u8;
    var i: u8;
    var sum: u16;

    test_lib.test_init();

    { Test 1: Array write and read at index 0 }
    arr[0] := 42;
    test_lib.expected_val := 42;
    test_lib.actual_val := arr[0];
    test_lib.assert_eq();

    { Test 2: Array write and read at index 5 }
    arr[5] := 99;
    test_lib.expected_val := 99;
    test_lib.actual_val := arr[5];
    test_lib.assert_eq();

    { Test 3: Array write and read at last index }
    arr[9] := 123;
    test_lib.expected_val := 123;
    test_lib.actual_val := arr[9];
    test_lib.assert_eq();

    { Test 4: Fill array with loop }
    for i = 0 to 9 do
        arr[i] := i * 2;
    end;
    test_lib.expected_val := 6;
    test_lib.actual_val := arr[3];
    test_lib.assert_eq();

    { Test 5: Check another filled value }
    test_lib.expected_val := 14;
    test_lib.actual_val := arr[7];
    test_lib.assert_eq();

    { Test 6: Sum array elements }
    sum := 0;
    for i = 0 to 9 do
        sum := sum + arr[i];
    end;
    test_lib.expected_val := 90;
    test_lib.actual_val := sum;
    test_lib.assert_eq();

    { Test 7: Modify single element }
    arr[4] := 100;
    test_lib.expected_val := 100;
    test_lib.actual_val := arr[4];
    test_lib.assert_eq();

    { Test 8: Read element with variable index }
    i := 6;
    test_lib.expected_val := 12;
    test_lib.actual_val := arr[i];
    test_lib.assert_eq();

    { Test 9: Array element in expression }
    arr[0] := 10;
    arr[1] := 20;
    test_lib.expected_val := 30;
    test_lib.actual_val := arr[0] + arr[1];
    test_lib.assert_eq();

    { Test 10: Nested array access }
    arr[0] := 3;
    arr[3] := 50;
    test_lib.expected_val := 50;
    i := arr[0];
    test_lib.actual_val := arr[i];
    test_lib.assert_eq();

    test_lib.test_summary();
end;
