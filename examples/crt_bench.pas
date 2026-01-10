import wait_line from "../lib/crt.pas";
import irq_disable from "../lib/sys.pas";

program crt_bench

proc main()
    var line : u8;

    irq_disable();
    poke($d011, 0);

    line := 0;
    while 1 do
        poke($d020, 0);
        wait_line(line);
        poke($d020, 1);
        inc(line);
        wait_line(line);
    end;
end;