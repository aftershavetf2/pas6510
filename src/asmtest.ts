import { Assembler } from "@neshacker/6502-tools";

export function testAssembler() {
  const source = `
  my_routine = $ACDC
  .org $BD17
  another_routine:
    lda #22
    jsr my_routine
    rts
`;
  // Assemble and inspect the source
  const hexString = Assembler.toHexString(source);
  console.log("Hex output:", hexString);
  Assembler.inspect(source);
}
