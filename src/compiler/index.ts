// pas6510 compiler - main entry point

export { Lexer } from "./lexer";
export { Parser } from "./parser";
export { CodeGenerator } from "./codegen";
export * from "./tokens";
export * from "./ast";

import { Lexer } from "./lexer";
import { Parser } from "./parser";
import { CodeGenerator } from "./codegen";

export function compile(source: string): string {
  const lexer = new Lexer(source);
  const tokens = lexer.tokenize();

  const parser = new Parser(tokens);
  const ast = parser.parse();

  const codegen = new CodeGenerator();
  const assembly = codegen.generate(ast);

  return assembly;
}
