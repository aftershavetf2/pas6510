use sys;

program irq_test

{ Test IRQ enable/disable }

procedure main()
    sys.irq_disable();

    { Do something with interrupts disabled }
    poke($d020, 0);  { Set border to black }

    sys.irq_enable();
end;
