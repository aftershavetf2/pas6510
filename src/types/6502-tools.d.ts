declare module "@neshacker/6502-tools" {
  export class Assembler {
    static toHexString(source: string): string;
    static inspect(source: string): void;
    static fileToHexString(path: string): string;
    static inspectFile(path: string): void;
  }
}
