use test_lib;
use helper_module;

program test_modules

{ Test module system with imports }

procedure main()
    test_lib.test_init();

    { Test 1: Call imported proc that sets value }
    helper_module.set_value();
    test_lib.expected_val := 42;
    test_lib.actual_val := helper_module.shared_value;
    test_lib.assert_eq();

    { Test 2: Call proc that modifies imported variable }
    helper_module.double_value();
    test_lib.expected_val := 84;
    test_lib.actual_val := helper_module.shared_value;
    test_lib.assert_eq();

    { Test 3: Direct assignment to imported variable }
    helper_module.shared_value := 100;
    test_lib.expected_val := 100;
    test_lib.actual_val := helper_module.shared_value;
    test_lib.assert_eq();

    { Test 4: Use counter - reset first }
    helper_module.reset_counter();
    test_lib.expected_val := 0;
    test_lib.actual_val := helper_module.counter;
    test_lib.assert_eq();

    { Test 5: Increment counter }
    helper_module.inc_counter();
    test_lib.expected_val := 1;
    test_lib.actual_val := helper_module.counter;
    test_lib.assert_eq();

    { Test 6: Increment counter multiple times }
    helper_module.inc_counter();
    helper_module.inc_counter();
    helper_module.inc_counter();
    test_lib.expected_val := 4;
    test_lib.actual_val := helper_module.counter;
    test_lib.assert_eq();

    { Test 7: Call proc with loop }
    helper_module.calc_sum_10();
    test_lib.expected_val := 55;
    test_lib.actual_val := helper_module.shared_value;
    test_lib.assert_eq();

    { Test 8: Multiple operations on imported vars }
    helper_module.shared_value := 10;
    helper_module.counter := 5;
    helper_module.shared_value := helper_module.shared_value + helper_module.counter;
    test_lib.expected_val := 15;
    test_lib.actual_val := helper_module.shared_value;
    test_lib.assert_eq();

    { Test 9: Imported variable in expression }
    helper_module.shared_value := 20;
    test_lib.expected_val := 60;
    test_lib.actual_val := helper_module.shared_value * 3;
    test_lib.assert_eq();

    { Test 10: Chain of calls }
    helper_module.set_value();
    helper_module.double_value();
    helper_module.double_value();
    test_lib.expected_val := 168;
    test_lib.actual_val := helper_module.shared_value;
    test_lib.assert_eq();

    test_lib.test_summary();
end;
