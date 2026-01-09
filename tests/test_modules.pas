import test_init, test_summary, assert_eq, expected_val, actual_val from "test_lib.pas";
import set_value, double_value, shared_value, counter, inc_counter, reset_counter, calc_sum_10 from "helper_module.pas";

program test_modules

{ Test module system with imports }

proc main()
    test_init();

    { Test 1: Call imported proc that sets value }
    set_value();
    expected_val := 42;
    actual_val := shared_value;
    assert_eq();

    { Test 2: Call proc that modifies imported variable }
    double_value();
    expected_val := 84;
    actual_val := shared_value;
    assert_eq();

    { Test 3: Direct assignment to imported variable }
    shared_value := 100;
    expected_val := 100;
    actual_val := shared_value;
    assert_eq();

    { Test 4: Use counter - reset first }
    reset_counter();
    expected_val := 0;
    actual_val := counter;
    assert_eq();

    { Test 5: Increment counter }
    inc_counter();
    expected_val := 1;
    actual_val := counter;
    assert_eq();

    { Test 6: Increment counter multiple times }
    inc_counter();
    inc_counter();
    inc_counter();
    expected_val := 4;
    actual_val := counter;
    assert_eq();

    { Test 7: Call proc with loop }
    calc_sum_10();
    expected_val := 55;
    actual_val := shared_value;
    assert_eq();

    { Test 8: Multiple operations on imported vars }
    shared_value := 10;
    counter := 5;
    shared_value := shared_value + counter;
    expected_val := 15;
    actual_val := shared_value;
    assert_eq();

    { Test 9: Imported variable in expression }
    shared_value := 20;
    expected_val := 60;
    actual_val := shared_value * 3;
    assert_eq();

    { Test 10: Chain of calls }
    set_value();
    double_value();
    double_value();
    expected_val := 168;
    actual_val := shared_value;
    assert_eq();

    test_summary();
end;
