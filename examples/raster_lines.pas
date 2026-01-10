import irq_disable from "../lib/sys.pas";

program raster_lines

proc main()
    var line : u8;

    irq_disable();

    while 1 do
        { Read value from 0xd012 - current raster line }
        line := peek($d012);
        poke($d020, line);
    end;
end;