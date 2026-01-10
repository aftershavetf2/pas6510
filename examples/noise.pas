import irq_disable from "../lib/sys.pas";

program noise

proc main()
    var x : u8;

    irq_disable();
    
    x := 0;
    while 1 do
        poke($d418, x);
        inc(x);
    end;
end;