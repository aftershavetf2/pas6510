use sys;

program raster_lines

procedure main()
    sys.irq_disable();

        { Read value from 0xd012 - current raster line }

    while 1 do
        poke($d020, peek($d012));
    end;
end;
