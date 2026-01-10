program screen_memory_chaos

proc main()
    var i: u8;
    var x: u8;

    x := 0;

    while 1 do
        for x = 0 to 255 do
            for i = 0 to 255 do
                poke(1024+i, x);
            end;
        end;
    end;
end;