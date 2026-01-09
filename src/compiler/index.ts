// pas6510 compiler - main entry point

export { Lexer } from "./lexer";
export { Parser } from "./parser";
export { CodeGenerator } from "./codegen";
export { ModuleResolver } from "./resolver";
export * from "./tokens";
export * from "./ast";
export * from "./resolver";

import { Lexer } from "./lexer";
import { Parser } from "./parser";
import { CodeGenerator } from "./codegen";
import { ModuleResolver } from "./resolver";

// Compile a single source file (no imports)
export function compile(source: string): string {
  const lexer = new Lexer(source);
  const tokens = lexer.tokenize();

  const parser = new Parser(tokens);
  const ast = parser.parse();

  const codegen = new CodeGenerator();
  const assembly = codegen.generate(ast);

  return assembly;
}

// Compile a file with module resolution (handles imports)
export function compileFile(filePath: string): string {
  const resolver = new ModuleResolver();
  const resolved = resolver.resolve(filePath);

  const codegen = new CodeGenerator();
  const assembly = codegen.generateFromResolved(resolved);

  return assembly;
}
