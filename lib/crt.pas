import memset from "sys.pas";

program crt

{ CRT module for C64 screen handling }
{ Screen memory: $0400 (1024) }
{ Color memory:  $D800 (55296) }
{ Screen size:   40x25 characters }

pub const SCREEN_BASE: u16 = $0400;
pub const COLOR_BASE: u16 = $D800;
pub const SCREEN_WIDTH: u8 = 40;
pub const SCREEN_HEIGHT: u8 = 25;

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
    cursor_x := 0;
    cursor_y := 0;
    text_color := $0E;
end;

{ Calculate screen address from cursor position }
pub proc calc_addr()
    var row_offset: u16;
    var y_temp: u8;

    row_offset := 0;
    y_temp := cursor_y;

    while y_temp > 0 do
        row_offset := row_offset + 40;
        dec(y_temp);
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
        dec(y_temp);
    end;

    color_addr := COLOR_BASE + row_offset + cursor_x;
end;

pub proc clear()
    var i : u8;

    const addr1 : u16 = SCREEN_BASE;
    const addr2 : u16 = SCREEN_BASE + 256;
    const addr3 : u16 = SCREEN_BASE + 512;
    const addr4 : u16 = SCREEN_BASE + 768;

    const caddr1 : u16 = COLOR_BASE;
    const caddr2 : u16 = COLOR_BASE + 256;
    const caddr3 : u16 = COLOR_BASE + 512;
    const caddr4 : u16 = COLOR_BASE + 768;

    memset(addr1, 0, 32);
    memset(caddr1, 0, text_color);
    memset(addr2, 0, 32);
    memset(caddr2, 0, text_color);
    memset(addr3, 0, 32);
    memset(caddr3, 0, text_color);
    memset(addr4, 231, 32);
    memset(caddr4, 231, text_color);

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
    inc(cursor_y);
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

    inc(cursor_x);
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

{ Draw horizontal line - optimized with memset }
pub proc hline(ch: u8, len: u8)
    var saddr: u16;
    var caddr: u16;
    var yoff: u16;
    var ytmp: u8;

    { Calculate y * 40 offset }
    yoff := 0;
    ytmp := cursor_y;
    while ytmp > 0 do
        yoff := yoff + 40;
        dec(ytmp);
    end;

    saddr := SCREEN_BASE + yoff + cursor_x;
    caddr := COLOR_BASE + yoff + cursor_x;

    memset(saddr, len, ch);
    memset(caddr, len, text_color);

    cursor_x := cursor_x + len;
end;

{ Fill rectangle with character - optimized with memset }
pub proc fillrect(x: u8, y: u8, w: u8, h: u8, ch: u8)
    var row: u8;
    var saddr: u16;
    var caddr: u16;
    var yoff: u16;
    var ytmp: u8;

    { Calculate y * 40 offset }
    yoff := 0;
    ytmp := y;
    while ytmp > 0 do
        yoff := yoff + 40;
        dec(ytmp);
    end;

    saddr := SCREEN_BASE + yoff + x;
    caddr := COLOR_BASE + yoff + x;

    row := 0;
    while row < h do
        memset(saddr, w, ch);
        memset(caddr, w, text_color);
        saddr := saddr + 40;
        caddr := caddr + 40;
        inc(row);
    end;
end;

{ Draw box outline - optimized with memset for horizontal lines }
{ Screen codes: 112=top-left, 110=top-right, 109=bottom-left, 125=bottom-right }
{ 64=horizontal line, 93=vertical line }
pub proc box(x: u8, y: u8, w: u8, h: u8)
    var i: u8;
    var saddr: u16;
    var caddr: u16;
    var yoff: u16;
    var ytmp: u8;
    var inner_w: u8;

    { Calculate y * 40 offset }
    yoff := 0;
    ytmp := y;
    while ytmp > 0 do
        yoff := yoff + 40;
        dec(ytmp);
    end;

    saddr := SCREEN_BASE + yoff + x;
    caddr := COLOR_BASE + yoff + x;
    inner_w := w - 2;

    { Top line }
    poke(saddr, 112);
    poke(caddr, text_color);
    memset(saddr + 1, inner_w, 64);
    memset(caddr + 1, inner_w, text_color);
    poke(saddr + w - 1, 110);
    poke(caddr + w - 1, text_color);

    { Sides }
    i := 1;
    while i < h - 1 do
        saddr := saddr + 40;
        caddr := caddr + 40;
        poke(saddr, 93);
        poke(caddr, text_color);
        poke(saddr + w - 1, 93);
        poke(caddr + w - 1, text_color);
        inc(i);
    end;

    { Bottom line }
    saddr := saddr + 40;
    caddr := caddr + 40;
    poke(saddr, 109);
    poke(caddr, text_color);
    memset(saddr + 1, inner_w, 64);
    memset(caddr + 1, inner_w, text_color);
    poke(saddr + w - 1, 125);
    poke(caddr + w - 1, text_color);
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
        inc(count);
    end;

    { Print digits in reverse order }
    while count > 0 do
        dec(count);
        putch(digits[count]);
    end;
end;

pub proc wait_line(line:u8)
    while peek($d011) > 127 do
    end;

    while peek($d012) <> line do
    end;
end;

proc main()
    crt_init();
end;
