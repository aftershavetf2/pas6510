program adder

procedure main()
    var sum : u16;
    var i: u8;

    sum := 0;
    for i = 0 to 10 do
        sum := sum + i;
    end;

    write_u16_ln(sum);
end;
