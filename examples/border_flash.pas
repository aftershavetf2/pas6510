use crt;
use sys;

program border_flash

procedure main()
    var y : u8;
    var i : u8;

    sys.irq_disable();

    while 1 do
        for y = 100 to 200 do
            crt.wait_line(y);
            poke($d020, 1);

            for i = 0 to 255 do
            end;

            poke($d020, 0);
        end;
    end;
end;
