program noise

proc main()
    var x : u8;

    x := 0;
    while 1 do
        poke(54296, x);
        x := x + 1;
    end;
end;