import irq_disable from "../lib/sys.pas";

program noise

proc main()
    irq_disable();
    
    while 1 do
        dec($d418);
    end;
end;