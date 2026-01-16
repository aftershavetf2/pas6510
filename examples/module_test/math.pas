program math_module

pub var CONST_TEN: u8;
pub var RESULT: u16;

pub procedure set_ten()
    CONST_TEN := 10;
end;

pub procedure calc_sum()
    var i: u8;
    RESULT := 0;
    for i = 1 to 5 do
        RESULT := RESULT + i;
    end;
end;

procedure main()
    CONST_TEN := 10;
end;
