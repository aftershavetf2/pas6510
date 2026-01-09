program test_lib

{ Test library for pas6510 }
{ Provides assertion functions that print results }

pub var test_count: u16;
pub var pass_count: u16;
pub var fail_count: u16;
pub var current_test: u16;

{ Expected and actual values for assertions }
pub var expected_val: u16;
pub var actual_val: u16;

{ Initialize test counters }
pub proc test_init()
    test_count := 0;
    pass_count := 0;
    fail_count := 0;
    current_test := 0;
end;

{ Print "TEST " }
pub proc print_test()
    print_char(84);
    print_char(69);
    print_char(83);
    print_char(84);
    print_char(32);
end;

{ Print "PASS" with newline }
pub proc print_pass()
    print_char(80);
    print_char(65);
    print_char(83);
    print_char(83);
    print_char(13);
end;

{ Print "FAIL" with newline }
pub proc print_fail()
    print_char(70);
    print_char(65);
    print_char(73);
    print_char(76);
    print_char(13);
end;

{ Print "  EXPECTED: " }
pub proc print_expected()
    print_char(32);
    print_char(32);
    print_char(69);
    print_char(88);
    print_char(80);
    print_char(69);
    print_char(67);
    print_char(84);
    print_char(69);
    print_char(68);
    print_char(58);
    print_char(32);
end;

{ Print "  ACTUAL:   " }
pub proc print_actual()
    print_char(32);
    print_char(32);
    print_char(65);
    print_char(67);
    print_char(84);
    print_char(85);
    print_char(65);
    print_char(76);
    print_char(58);
    print_char(32);
    print_char(32);
    print_char(32);
end;

{ Assert u16: set expected_val and actual_val before calling }
pub proc assert_eq()
    test_count := test_count + 1;
    current_test := test_count;

    print_test();
    write_u16_ln(current_test);

    if expected_val = actual_val then
        pass_count := pass_count + 1;
        print_pass();
    else
        fail_count := fail_count + 1;
        print_fail();
        print_expected();
        write_u16_ln(expected_val);
        print_actual();
        write_u16_ln(actual_val);
    end;
end;

{ Print summary divider }
pub proc print_results()
    print_char(13);
    print_char(45);
    print_char(45);
    print_char(45);
    print_char(45);
    print_char(45);
    print_char(45);
    print_char(45);
    print_char(45);
    print_char(13);
end;

{ Print "PASSED: " }
pub proc print_passed_label()
    print_char(80);
    print_char(65);
    print_char(83);
    print_char(83);
    print_char(69);
    print_char(68);
    print_char(58);
    print_char(32);
end;

{ Print "FAILED: " }
pub proc print_failed_label()
    print_char(70);
    print_char(65);
    print_char(73);
    print_char(76);
    print_char(69);
    print_char(68);
    print_char(58);
    print_char(32);
end;

{ Print final test summary }
pub proc test_summary()
    print_results();
    print_passed_label();
    write_u16_ln(pass_count);
    print_failed_label();
    write_u16_ln(fail_count);
end;

proc main()
end;
