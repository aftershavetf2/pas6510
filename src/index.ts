// pas6510 - Pascal compiler for 6510 CPU

import { compile } from "./compiler";

const exampleProgram = `
{ORG 0x1000}
program adder

proc main()
    var sum : u16;
    var i: u8;

    sum := 0;
    for i = 0 to 10 do
        sum := sum + i;
    end;

    write_u16_ln(sum);
end;
`;

console.log("pas6510 compiler");
console.log("================");
console.log("");
console.log("Input program:");
console.log(exampleProgram);
console.log("");
console.log("Generated 6510 assembly:");
console.log("========================");

try {
  const assembly = compile(exampleProgram);
  console.log(assembly);
} catch (e) {
  console.error("Compilation error:", e);
}
