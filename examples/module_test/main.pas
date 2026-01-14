use math;

program main

proc main()
    math.set_ten();
    write_u16_ln(math.CONST_TEN);

    math.calc_sum();
    write_u16_ln(math.RESULT);
end;
