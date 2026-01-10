import irq_disable from "../lib/cpu.pas";

program noise

proc main()
    var x : u8;

    irq_disable();
    
    x := 0;
    while 1 do
        poke($d418, x);
        x := x + 1;
    end;
end;