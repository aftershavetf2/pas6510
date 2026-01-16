program helper_module

{ Helper module to test imports }

pub var shared_value: u16;
pub var counter: u16;

{ Set shared_value to 42 }
pub procedure set_value()
    shared_value := 42;
end;

{ Double the shared_value }
pub procedure double_value()
    shared_value := shared_value + shared_value;
end;

{ Increment counter }
pub procedure inc_counter()
    counter := counter + 1;
end;

{ Reset counter to zero }
pub procedure reset_counter()
    counter := 0;
end;

{ Calculate sum 1 to 10 and store in shared_value }
pub procedure calc_sum_10()
    var i: u8;
    shared_value := 0;
    for i = 1 to 10 do
        shared_value := shared_value + i;
    end;
end;

{ Private procedureedure - should not be accessible from outside }
procedure internal_procedure()
    shared_value := 999;
end;

procedure main()
end;
