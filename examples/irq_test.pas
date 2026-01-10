import irq_enable, irq_disable from "../lib/cpu.pas";

program irq_test

{ Test IRQ enable/disable }

proc main()
    irq_disable();

    { Do something with interrupts disabled }
    poke(53280, 0);  { Set border to black }

    irq_enable();
end;
