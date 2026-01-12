import irq_disable from "../lib/sys.pas";

program raster_lines

proc main()
    irq_disable();

    while 1 do
        { Read value from 0xd012 - current raster line }
        poke($d020, peek($d012));
    end;
end;