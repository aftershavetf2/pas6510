program crt

{ CRT module for C64 screen handling }
{ Screen memory: $0400 (1024) }
{ Color memory:  $D800 (55296) }
{ Screen size:   40x25 characters }

pub var SCREEN_BASE: u16;
pub var COLOR_BASE: u16;
pub var SCREEN_WIDTH: u8;
pub var SCREEN_HEIGHT: u8;

{ Current cursor position }
pub var cursor_x: u8;
pub var cursor_y: u8;

{ Current text color (0-15) }
pub var text_color: u8;

{ Internal: calculated addresses }
pub var screen_addr: u16;
pub var color_addr: u16;

{ Initialize CRT module }
pub proc crt_init()
    SCREEN_BASE := 1024;
    COLOR_BASE := 55296;
    SCREEN_WIDTH := 40;
    SCREEN_HEIGHT := 25;
    cursor_x := 0;
    cursor_y := 0;
    text_color := 14;
end;

{ Calculate screen address from cursor position }
pub proc calc_addr()
    var row_offset: u16;
    var y_temp: u8;

    row_offset := 0;
    y_temp := cursor_y;

    while y_temp > 0 do
        row_offset := row_offset + 40;
        y_temp := y_temp - 1;
    end;

    screen_addr := SCREEN_BASE + row_offset + cursor_x;
end;

{ Calculate color address from cursor position }
pub proc calc_color_addr()
    var row_offset: u16;
    var y_temp: u8;

    row_offset := 0;
    y_temp := cursor_y;

    while y_temp > 0 do
        row_offset := row_offset + 40;
        y_temp := y_temp - 1;
    end;

    color_addr := COLOR_BASE + row_offset + cursor_x;
end;

{ Clear the screen with spaces and current color }
pub proc clear()
    var row: u8;
    var col: u8;
    var addr: u16;
    var caddr: u16;

    addr := SCREEN_BASE;
    caddr := COLOR_BASE;

    row := 0;
    while row < 25 do
        col := 0;
        while col < 40 do
            poke(addr, 32);
            poke(caddr, text_color);
            addr := addr + 1;
            caddr := caddr + 1;
            col := col + 1;
        end;
        row := row + 1;
    end;

    cursor_x := 0;
    cursor_y := 0;
end;

{ Set cursor position }
pub proc gotoxy(x: u8, y: u8)
    cursor_x := x;
    cursor_y := y;
end;

{ Move cursor to beginning of next line }
pub proc newline()
    cursor_x := 0;
    cursor_y := cursor_y + 1;
    if cursor_y >= SCREEN_HEIGHT then
        cursor_y := 0;
    end;
end;

{ Write screen code character at cursor }
pub proc putch(ch: u8)
    calc_addr();
    calc_color_addr();

    poke(screen_addr, ch);
    poke(color_addr, text_color);

    cursor_x := cursor_x + 1;
    if cursor_x >= SCREEN_WIDTH then
        newline();
    end;
end;

{ Write PETSCII char converted to screen code }
pub proc putc(ch: u8)
    var sc: u8;
    sc := ch;

    if sc >= 65 then
        if sc <= 90 then
            { Uppercase A-Z: PETSCII 65-90 -> screen 1-26 }
            putch(sc - 64);
            return;
        end;
    end;

    if sc >= 97 then
        if sc <= 122 then
            { Lowercase a-z -> uppercase screen 1-26 }
            putch(sc - 96);
            return;
        end;
    end;

    { Other chars: digits, space, punctuation stay same }
    putch(sc);
end;

{ Set text color (0-15) }
pub proc setcolor(c: u8)
    text_color := c;
end;

{ Draw horizontal line }
pub proc hline(ch: u8, len: u8)
    var i: u8;
    i := 0;
    while i < len do
        putch(ch);
        i := i + 1;
    end;
end;

{ Fill rectangle with character }
pub proc fillrect(x: u8, y: u8, w: u8, h: u8, ch: u8)
    var row: u8;
    var col: u8;
    var start_x: u8;
    var start_y: u8;

    start_x := x;
    start_y := y;

    row := 0;
    while row < h do
        cursor_x := start_x;
        cursor_y := start_y + row;
        col := 0;
        while col < w do
            calc_addr();
            calc_color_addr();
            poke(screen_addr, ch);
            poke(color_addr, text_color);
            cursor_x := cursor_x + 1;
            col := col + 1;
        end;
        row := row + 1;
    end;
end;

{ Draw box outline }
{ Screen codes: 112=top-left, 110=top-right, 109=bottom-left, 125=bottom-right }
{ 64=horizontal line, 93=vertical line }
pub proc box(x: u8, y: u8, w: u8, h: u8)
    var i: u8;

    { Top line }
    cursor_x := x;
    cursor_y := y;
    putch(112);
    i := 2;
    while i < w do
        putch(64);
        i := i + 1;
    end;
    putch(110);

    { Sides }
    i := 1;
    while i < h - 1 do
        cursor_x := x;
        cursor_y := y + i;
        putch(93);
        cursor_x := x + w - 1;
        putch(93);
        i := i + 1;
    end;

    { Bottom line }
    cursor_x := x;
    cursor_y := y + h - 1;
    putch(109);
    i := 2;
    while i < w do
        putch(64);
        i := i + 1;
    end;
    putch(125);
end;

{ Write decimal number at cursor }
pub proc putnum(num: u16)
    var digits: array[6] of u8;
    var count: u8;
    var temp: u16;
    var digit: u8;

    if num = 0 then
        putch(48);
        return;
    end;

    count := 0;
    temp := num;

    while temp > 0 do
        digit := temp - (temp / 10) * 10;
        digits[count] := digit + 48;
        temp := temp / 10;
        count := count + 1;
    end;

    { Print digits in reverse order }
    while count > 0 do
        count := count - 1;
        putch(digits[count]);
    end;
end;

proc main()
    crt_init();
end;
