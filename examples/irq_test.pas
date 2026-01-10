import irq_enable, irq_disable from "../lib/sys.pas";

program irq_test

{ Test IRQ enable/disable }

proc main()
    irq_disable();

    { Do something with interrupts disabled }
    poke($d020, 0);  { Set border to black }

    irq_enable();
end;
