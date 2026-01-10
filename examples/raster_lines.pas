import irq_disable from "../lib/cpu.pas";

program raster_lines

proc main()
    var line : u8;

    irq_disable();

    while 1 do
        { Read value from 0xd012 - current raster line }
        line := peek(53266);
        poke(53280, line);
    end;
end;