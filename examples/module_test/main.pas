import set_ten, calc_sum, CONST_TEN, RESULT from "math.pas";

program main

proc main()
    set_ten();
    write_u16_ln(CONST_TEN);

    calc_sum();
    write_u16_ln(RESULT);
end;
