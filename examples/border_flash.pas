program border_flash

proc main()
    while 1 do
        poke(53280, 0);
        poke(53280, 1);
    end;
end;
