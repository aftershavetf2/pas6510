use sys;

program screen_memory_chaos

proc main()
    var i: u8;
    var x: u8;

    sys.irq_disable();
    
    x := 0;

    while 1 do
        for x = 0 to 255 do
            for i = 0 to 255 do
                poke($0400+i, x);
                poke($0500+i, x);
                poke($0600+i, x);
                poke($0700+i, x);
            end;
        end;
    end;
end;