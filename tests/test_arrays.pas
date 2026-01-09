import test_init, test_summary, assert_eq, expected_val, actual_val from "test_lib.pas";

program test_arrays

{ Test array operations }

proc main()
    var arr: array[10] of u8;
    var i: u8;
    var sum: u16;

    test_init();

    { Test 1: Array write and read at index 0 }
    arr[0] := 42;
    expected_val := 42;
    actual_val := arr[0];
    assert_eq();

    { Test 2: Array write and read at index 5 }
    arr[5] := 99;
    expected_val := 99;
    actual_val := arr[5];
    assert_eq();

    { Test 3: Array write and read at last index }
    arr[9] := 123;
    expected_val := 123;
    actual_val := arr[9];
    assert_eq();

    { Test 4: Fill array with loop }
    for i = 0 to 9 do
        arr[i] := i * 2;
    end;
    expected_val := 6;
    actual_val := arr[3];
    assert_eq();

    { Test 5: Check another filled value }
    expected_val := 14;
    actual_val := arr[7];
    assert_eq();

    { Test 6: Sum array elements }
    sum := 0;
    for i = 0 to 9 do
        sum := sum + arr[i];
    end;
    expected_val := 90;
    actual_val := sum;
    assert_eq();

    { Test 7: Modify single element }
    arr[4] := 100;
    expected_val := 100;
    actual_val := arr[4];
    assert_eq();

    { Test 8: Read element with variable index }
    i := 6;
    expected_val := 12;
    actual_val := arr[i];
    assert_eq();

    { Test 9: Array element in expression }
    arr[0] := 10;
    arr[1] := 20;
    expected_val := 30;
    actual_val := arr[0] + arr[1];
    assert_eq();

    { Test 10: Nested array access }
    arr[0] := 3;
    arr[3] := 50;
    expected_val := 50;
    i := arr[0];
    actual_val := arr[i];
    assert_eq();

    test_summary();
end;
