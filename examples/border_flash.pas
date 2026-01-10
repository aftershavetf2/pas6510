import wait_line from "../lib/crt.pas";
import irq_disable from "../lib/sys.pas";

program border_flash

proc main()
    var y : u8;
    var i : u8;

    irq_disable();

    while 1 do
        for y = 100 to 200 do
            wait_line(y);    
            poke($d020, 1);

            for i = 0 to 255 do
            end;

            poke($d020, 0);
        end;
    end;
end;
