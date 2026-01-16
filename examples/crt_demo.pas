use crt;

program crt_demo

{ Demo of the CRT module }

procedure print_hello()
    { Print "HELLO WORLD" }
    crt.putc(72);
    crt.putc(69);
    crt.putc(76);
    crt.putc(76);
    crt.putc(79);
    crt.putc(32);
    crt.putc(87);
    crt.putc(79);
    crt.putc(82);
    crt.putc(76);
    crt.putc(68);
end;

procedure print_pas6510()
    { Print "PAS6510 CRT DEMO" }
    crt.putc(80);
    crt.putc(65);
    crt.putc(83);
    crt.putc(54);
    crt.putc(53);
    crt.putc(49);
    crt.putc(48);
    crt.putc(32);
    crt.putc(67);
    crt.putc(82);
    crt.putc(84);
    crt.putc(32);
    crt.putc(68);
    crt.putc(69);
    crt.putc(77);
    crt.putc(79);
end;

procedure print_number_label()
    { Print "NUMBER: " }
    crt.putc(78);
    crt.putc(85);
    crt.putc(77);
    crt.putc(66);
    crt.putc(69);
    crt.putc(82);
    crt.putc(58);
    crt.putc(32);
end;

procedure print_red()
    { Print "RED " }
    crt.putc(82);
    crt.putc(69);
    crt.putc(68);
    crt.putc(32);
end;

procedure print_green()
    { Print "GREEN " }
    crt.putc(71);
    crt.putc(82);
    crt.putc(69);
    crt.putc(69);
    crt.putc(78);
    crt.putc(32);
end;

procedure print_blue()
    { Print "BLUE" }
    crt.putc(66);
    crt.putc(76);
    crt.putc(85);
    crt.putc(69);
end;

procedure main()
    crt.crt_init();
    crt.clear();

    { Draw a box }
    crt.setcolor(3);
    crt.box(5, 2, 30, 10);

    { Title inside box }
    crt.setcolor(1);
    crt.gotoxy(14, 4);
    print_hello();

    { Show a number }
    crt.setcolor(7);
    crt.gotoxy(8, 6);
    print_number_label();
    crt.putnum(12345);

    { Color demo }
    crt.gotoxy(8, 8);
    crt.setcolor(2);
    print_red();
    crt.setcolor(5);
    print_green();
    crt.setcolor(6);
    print_blue();

    { Footer line }
    crt.setcolor(14);
    crt.gotoxy(0, 20);
    crt.hline(64, 40);

    { Footer text }
    crt.gotoxy(12, 22);
    print_pas6510();
end;
