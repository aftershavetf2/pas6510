import crt_init, clear, gotoxy, putch, putc, putnum, setcolor, newline, box, hline from "../lib/crt.pas";
import cursor_x, cursor_y, text_color from "../lib/crt.pas";

program crt_demo

{ Demo of the CRT module }

proc print_hello()
    { Print "HELLO WORLD" }
    putc(72);
    putc(69);
    putc(76);
    putc(76);
    putc(79);
    putc(32);
    putc(87);
    putc(79);
    putc(82);
    putc(76);
    putc(68);
end;

proc print_pas6510()
    { Print "PAS6510 CRT DEMO" }
    putc(80);
    putc(65);
    putc(83);
    putc(54);
    putc(53);
    putc(49);
    putc(48);
    putc(32);
    putc(67);
    putc(82);
    putc(84);
    putc(32);
    putc(68);
    putc(69);
    putc(77);
    putc(79);
end;

proc print_number_label()
    { Print "NUMBER: " }
    putc(78);
    putc(85);
    putc(77);
    putc(66);
    putc(69);
    putc(82);
    putc(58);
    putc(32);
end;

proc print_red()
    { Print "RED " }
    putc(82);
    putc(69);
    putc(68);
    putc(32);
end;

proc print_green()
    { Print "GREEN " }
    putc(71);
    putc(82);
    putc(69);
    putc(69);
    putc(78);
    putc(32);
end;

proc print_blue()
    { Print "BLUE" }
    putc(66);
    putc(76);
    putc(85);
    putc(69);
end;

proc main()
    crt_init();
    clear();

    { Draw a box }
    setcolor(3);
    box(5, 2, 30, 10);

    { Title inside box }
    setcolor(1);
    gotoxy(14, 4);
    print_hello();

    { Show a number }
    setcolor(7);
    gotoxy(8, 6);
    print_number_label();
    putnum(12345);

    { Color demo }
    gotoxy(8, 8);
    setcolor(2);
    print_red();
    setcolor(5);
    print_green();
    setcolor(6);
    print_blue();

    { Footer line }
    setcolor(14);
    gotoxy(0, 20);
    hline(64, 40);

    { Footer text }
    gotoxy(12, 22);
    print_pas6510();
end;
