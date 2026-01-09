import crt_init, clear, gotoxy, putch, putc, putnum, setcolor, newline, box, hline from "../lib/crt.pas";
import param_x, param_y, param_w, param_h, param_ch, param_len, param_color, param_num from "../lib/crt.pas";
import cursor_x, cursor_y, text_color from "../lib/crt.pas";

program crt_demo

{ Demo of the CRT module }

proc print_hello()
    { Print "HELLO WORLD" }
    param_ch := 72;
    putc();
    param_ch := 69;
    putc();
    param_ch := 76;
    putc();
    param_ch := 76;
    putc();
    param_ch := 79;
    putc();
    param_ch := 32;
    putc();
    param_ch := 87;
    putc();
    param_ch := 79;
    putc();
    param_ch := 82;
    putc();
    param_ch := 76;
    putc();
    param_ch := 68;
    putc();
end;

proc print_pas6510()
    { Print "PAS6510 CRT DEMO" }
    param_ch := 80;
    putc();
    param_ch := 65;
    putc();
    param_ch := 83;
    putc();
    param_ch := 54;
    putc();
    param_ch := 53;
    putc();
    param_ch := 49;
    putc();
    param_ch := 48;
    putc();
    param_ch := 32;
    putc();
    param_ch := 67;
    putc();
    param_ch := 82;
    putc();
    param_ch := 84;
    putc();
    param_ch := 32;
    putc();
    param_ch := 68;
    putc();
    param_ch := 69;
    putc();
    param_ch := 77;
    putc();
    param_ch := 79;
    putc();
end;

proc print_number_label()
    { Print "NUMBER: " }
    param_ch := 78;
    putc();
    param_ch := 85;
    putc();
    param_ch := 77;
    putc();
    param_ch := 66;
    putc();
    param_ch := 69;
    putc();
    param_ch := 82;
    putc();
    param_ch := 58;
    putc();
    param_ch := 32;
    putc();
end;

proc print_red()
    { Print "RED " }
    param_ch := 82;
    putc();
    param_ch := 69;
    putc();
    param_ch := 68;
    putc();
    param_ch := 32;
    putc();
end;

proc print_green()
    { Print "GREEN " }
    param_ch := 71;
    putc();
    param_ch := 82;
    putc();
    param_ch := 69;
    putc();
    param_ch := 69;
    putc();
    param_ch := 78;
    putc();
    param_ch := 32;
    putc();
end;

proc print_blue()
    { Print "BLUE" }
    param_ch := 66;
    putc();
    param_ch := 76;
    putc();
    param_ch := 85;
    putc();
    param_ch := 69;
    putc();
end;

proc main()
    crt_init();
    clear();

    { Draw a box }
    param_color := 3;
    setcolor();
    param_x := 5;
    param_y := 2;
    param_w := 30;
    param_h := 10;
    box();

    { Title inside box }
    param_color := 1;
    setcolor();
    param_x := 14;
    param_y := 4;
    gotoxy();
    print_hello();

    { Show a number }
    param_color := 7;
    setcolor();
    param_x := 8;
    param_y := 6;
    gotoxy();
    print_number_label();
    param_num := 12345;
    putnum();

    { Color demo }
    param_x := 8;
    param_y := 8;
    gotoxy();
    param_color := 2;
    setcolor();
    print_red();
    param_color := 5;
    setcolor();
    print_green();
    param_color := 6;
    setcolor();
    print_blue();

    { Footer line }
    param_color := 14;
    setcolor();
    param_x := 0;
    param_y := 20;
    gotoxy();
    param_ch := 64;
    param_len := 40;
    hline();

    { Footer text }
    param_x := 12;
    param_y := 22;
    gotoxy();
    print_pas6510();
end;
