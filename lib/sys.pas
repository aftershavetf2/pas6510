program sys

{ System module for 6510 low-level operations }

{ Enable interrupts (CLI instruction) }
pub procedure irq_enable()
end;

{ Disable interrupts (SEI instruction) }
pub procedure irq_disable()
end;

{ Fast memory fill - fills 'len' bytes starting at 'addr' with 'value' }
{ If len=0, fills 256 bytes }
pub procedure memset(addr: u16, len: u8, value: u8)
end;

procedure main()
end;
