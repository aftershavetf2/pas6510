program border_flash

proc main()
    while 1 do
        poke($d020, 0);
        poke($d020, 1);
    end;
end;
