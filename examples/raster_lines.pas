use sys;

program raster_lines

proc main()
    sys.irq_disable();

    while 1 do
        { Read value from 0xd012 - current raster line }
        poke($d020, peek($d012));
    end;
end;