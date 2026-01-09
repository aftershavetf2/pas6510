program helper_module

{ Helper module to test imports }

pub var shared_value: u16;
pub var counter: u16;

{ Set shared_value to 42 }
pub proc set_value()
    shared_value := 42;
end;

{ Double the shared_value }
pub proc double_value()
    shared_value := shared_value + shared_value;
end;

{ Increment counter }
pub proc inc_counter()
    counter := counter + 1;
end;

{ Reset counter to zero }
pub proc reset_counter()
    counter := 0;
end;

{ Calculate sum 1 to 10 and store in shared_value }
pub proc calc_sum_10()
    var i: u8;
    shared_value := 0;
    for i = 1 to 10 do
        shared_value := shared_value + i;
    end;
end;

{ Private procedure - should not be accessible from outside }
proc internal_proc()
    shared_value := 999;
end;

proc main()
end;
