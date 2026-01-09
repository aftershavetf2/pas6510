import test_init, test_summary, assert_eq, expected_val, actual_val from "test_lib.pas";

program test_loops

{ Test loops and conditionals }

proc main()
    var i: u8;
    var sum: u16;
    var count: u16;

    test_init();

    { Test 1: For loop sum 1 to 10 }
    sum := 0;
    for i = 1 to 10 do
        sum := sum + i;
    end;
    expected_val := 55;
    actual_val := sum;
    assert_eq();

    { Test 2: For loop count iterations }
    count := 0;
    for i = 0 to 4 do
        count := count + 1;
    end;
    expected_val := 5;
    actual_val := count;
    assert_eq();

    { Test 3: While loop }
    sum := 0;
    i := 1;
    while i <= 5 do
        sum := sum + i;
        i := i + 1;
    end;
    expected_val := 15;
    actual_val := sum;
    assert_eq();

    { Test 4: If-then true branch }
    sum := 0;
    if 5 > 3 then
        sum := 100;
    end;
    expected_val := 100;
    actual_val := sum;
    assert_eq();

    { Test 5: If-then-else true branch }
    if 10 = 10 then
        sum := 200;
    else
        sum := 300;
    end;
    expected_val := 200;
    actual_val := sum;
    assert_eq();

    { Test 6: If-then-else false branch }
    if 10 = 20 then
        sum := 400;
    else
        sum := 500;
    end;
    expected_val := 500;
    actual_val := sum;
    assert_eq();

    { Test 7: Comparison less than }
    sum := 0;
    if 3 < 5 then
        sum := 1;
    end;
    expected_val := 1;
    actual_val := sum;
    assert_eq();

    { Test 8: Comparison greater than }
    sum := 0;
    if 8 > 4 then
        sum := 1;
    end;
    expected_val := 1;
    actual_val := sum;
    assert_eq();

    { Test 9: Comparison not equal }
    sum := 0;
    if 5 <> 3 then
        sum := 1;
    end;
    expected_val := 1;
    actual_val := sum;
    assert_eq();

    { Test 10: Nested loop }
    sum := 0;
    for i = 1 to 3 do
        count := 0;
        while count < 2 do
            sum := sum + 1;
            count := count + 1;
        end;
    end;
    expected_val := 6;
    actual_val := sum;
    assert_eq();

    test_summary();
end;
