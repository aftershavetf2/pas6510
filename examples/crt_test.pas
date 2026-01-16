use crt;

program crt_test

{ Minimal test - write directly to screen memory }

procedure main()
    crt.crt_init();
    crt.clear();

    var addr: u16;

    { Write 'A' (screen code 1) directly to top-left corner }
    addr := 1024;
    poke(addr, 1);

    { Write 'B' to position 1 }
    addr := 1025;
    poke(addr, 2);

    { Write 'C' to position 2 }
    addr := 1026;
    poke(addr, 3);

    { Write to second row (position 40) }
    addr := 1064;
    poke(addr, 4);

    { Set color for first char to white }
    addr := 55296;
    poke(addr, 1);
end;
