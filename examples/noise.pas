use sys;

program noise

proc main()
    sys.irq_disable();
    
    while 1 do
        dec($d418);
    end;
end;