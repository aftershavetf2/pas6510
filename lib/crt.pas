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

{ Input parameters for procedures }
pub var param_x: u8;
pub var param_y: u8;
pub var param_w: u8;
pub var param_h: u8;
pub var param_ch: u8;
pub var param_len: u8;
pub var param_color: u8;
pub var param_num: u16;

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

{ Calculate screen address from cursor_x, cursor_y }
pub var screen_addr: u16;

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

{ Calculate color address from cursor_x, cursor_y }
pub var color_addr: u16;

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

    { Use two 8-bit loops to avoid 16-bit comparison issues }
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

{ Set cursor position - use param_x, param_y before calling }
pub proc gotoxy()
    cursor_x := param_x;
    cursor_y := param_y;
end;

{ Move cursor to beginning of next line }
pub proc newline()
    cursor_x := 0;
    cursor_y := cursor_y + 1;
    if cursor_y >= SCREEN_HEIGHT then
        cursor_y := 0;
    end;
end;

{ Write character at cursor - use param_ch before calling }
pub proc putch()
    calc_addr();
    calc_color_addr();

    poke(screen_addr, param_ch);
    poke(color_addr, text_color);

    cursor_x := cursor_x + 1;
    if cursor_x >= SCREEN_WIDTH then
        newline();
    end;
end;

{ Write PETSCII char converted to screen code - use param_ch before calling }
pub proc putc()
    var sc: u8;

    if param_ch >= 65 then
        if param_ch <= 90 then
            { Uppercase A-Z: PETSCII 65-90 -> screen 1-26 }
            param_ch := param_ch - 64;
            putch();
            return;
        end;
    end;

    if param_ch >= 97 then
        if param_ch <= 122 then
            { Lowercase a-z -> uppercase screen 1-26 }
            param_ch := param_ch - 96;
            putch();
            return;
        end;
    end;

    { Other chars: digits, space, punctuation stay same }
    putch();
end;

{ Set text color - use param_color before calling }
pub proc setcolor()
    text_color := param_color;
end;

{ Draw horizontal line - use param_ch, param_len before calling }
pub proc hline()
    var i: u8;
    i := 0;
    while i < param_len do
        putch();
        i := i + 1;
    end;
end;

{ Fill rectangle - use param_x, param_y, param_w, param_h, param_ch }
pub proc fillrect()
    var row: u8;
    var col: u8;
    var start_x: u8;
    var start_y: u8;

    start_x := param_x;
    start_y := param_y;

    row := 0;
    while row < param_h do
        cursor_x := start_x;
        cursor_y := start_y + row;
        col := 0;
        while col < param_w do
            calc_addr();
            calc_color_addr();
            poke(screen_addr, param_ch);
            poke(color_addr, text_color);
            cursor_x := cursor_x + 1;
            col := col + 1;
        end;
        row := row + 1;
    end;
end;

{ Draw box outline - use param_x, param_y, param_w, param_h }
{ Screen codes: 112=top-left, 110=top-right, 109=bottom-left, 125=bottom-right }
{ 64=horizontal line, 93=vertical line }
pub proc box()
    var i: u8;
    var bx: u8;
    var by: u8;
    var bw: u8;
    var bh: u8;

    bx := param_x;
    by := param_y;
    bw := param_w;
    bh := param_h;

    { Top line }
    cursor_x := bx;
    cursor_y := by;
    param_ch := 112;
    putch();
    i := 2;
    while i < bw do
        param_ch := 64;
        putch();
        i := i + 1;
    end;
    param_ch := 110;
    putch();

    { Sides }
    i := 1;
    while i < bh - 1 do
        cursor_x := bx;
        cursor_y := by + i;
        param_ch := 93;
        putch();
        cursor_x := bx + bw - 1;
        putch();
        i := i + 1;
    end;

    { Bottom line }
    cursor_x := bx;
    cursor_y := by + bh - 1;
    param_ch := 109;
    putch();
    i := 2;
    while i < bw do
        param_ch := 64;
        putch();
        i := i + 1;
    end;
    param_ch := 125;
    putch();
end;

{ Write number - use param_num before calling }
pub proc putnum()
    var digits: array[6] of u8;
    var count: u8;
    var temp: u16;
    var digit: u8;

    if param_num = 0 then
        param_ch := 48;
        putch();
        return;
    end;

    count := 0;
    temp := param_num;

    while temp > 0 do
        digit := temp - (temp / 10) * 10;
        digits[count] := digit + 48;
        temp := temp / 10;
        count := count + 1;
    end;

    { Print digits in reverse order }
    while count > 0 do
        count := count - 1;
        param_ch := digits[count];
        putch();
    end;
end;

proc main()
    crt_init();
end;
