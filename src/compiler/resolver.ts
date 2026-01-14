// Module resolver for the pas6510 compiler
// Handles module uses and circular dependency detection

import * as fs from "fs";
import * as path from "path";
import { Lexer } from "./lexer";
import { Parser } from "./parser";
import {
  ProgramNode,
  ProcedureNode,
  FunctionNode,
  GlobalVarDecl,
  GlobalConstDecl,
} from "./ast";

export interface ResolvedModule {
  filePath: string;
  program: ProgramNode;
}

export interface ResolvedProgram {
  mainModule: ResolvedModule;
  dependencies: ResolvedModule[];
  // Map of module names to their public symbols
  moduleSymbols: Map<string, Map<string, SymbolInfo>>;
}

export interface SymbolInfo {
  name: string;
  type: "proc" | "func" | "var" | "const";
  sourceModule: string;
  node: ProcedureNode | FunctionNode | GlobalVarDecl | GlobalConstDecl;
}

export class ModuleResolver {
  private resolvedModules: Map<string, ResolvedModule> = new Map();
  private resolving: Set<string> = new Set(); // For circular dependency detection

  resolve(mainFilePath: string): ResolvedProgram {
    const absolutePath = path.resolve(mainFilePath);

    // Parse the main module and all its dependencies
    const mainModule = this.resolveModule(absolutePath);

    // Collect all dependencies in order (dependencies first)
    const dependencies: ResolvedModule[] = [];
    const visited = new Set<string>();
    this.collectDependencies(mainModule, dependencies, visited);

    // Build symbol table per module for qualified access
    const moduleSymbols = this.buildModuleSymbolTables(dependencies);

    return {
      mainModule,
      dependencies,
      moduleSymbols,
    };
  }

  private resolveModule(filePath: string): ResolvedModule {
    const normalizedPath = path.normalize(filePath);

    // Check if already resolved
    if (this.resolvedModules.has(normalizedPath)) {
      return this.resolvedModules.get(normalizedPath)!;
    }

    // Check for circular dependency
    if (this.resolving.has(normalizedPath)) {
      throw new Error(`Circular import detected: ${normalizedPath}`);
    }

    // Mark as currently resolving
    this.resolving.add(normalizedPath);

    // Read and parse the file
    if (!fs.existsSync(filePath)) {
      throw new Error(`Module not found: ${filePath}`);
    }

    const source = fs.readFileSync(filePath, "utf-8");
    const lexer = new Lexer(source);
    const tokens = lexer.tokenize();
    const parser = new Parser(tokens);
    const program = parser.parse();

    const resolvedModule: ResolvedModule = {
      filePath: normalizedPath,
      program,
    };

    // Recursively resolve uses
    const moduleDir = path.dirname(filePath);
    for (const use of program.uses) {
      const usePath = this.findModule(moduleDir, use.modulePath);
      this.resolveModule(usePath);
    }

    // Mark as resolved
    this.resolving.delete(normalizedPath);
    this.resolvedModules.set(normalizedPath, resolvedModule);

    return resolvedModule;
  }

  private findModule(currentDir: string, modulePath: string): string {
    // Search for the module in:
    // 1. Same directory as the importing file
    // 2. ../lib/ directory

    const searchPaths = [
      path.resolve(currentDir, modulePath),
      path.resolve(currentDir, "..", "lib", modulePath),
    ];

    for (const searchPath of searchPaths) {
      if (fs.existsSync(searchPath)) {
        return searchPath;
      }
    }

    throw new Error(
      `Module not found: ${modulePath}\nSearched in:\n${searchPaths.join("\n")}`
    );
  }

  private collectDependencies(
    module: ResolvedModule,
    result: ResolvedModule[],
    visited: Set<string>
  ): void {
    if (visited.has(module.filePath)) {
      return;
    }
    visited.add(module.filePath);

    // First, recursively collect dependencies of this module
    const moduleDir = path.dirname(module.filePath);
    for (const use of module.program.uses) {
      const usePath = this.findModule(moduleDir, use.modulePath);
      const normalizedPath = path.normalize(usePath);
      const depModule = this.resolvedModules.get(normalizedPath);
      if (depModule) {
        this.collectDependencies(depModule, result, visited);
      }
    }

    // Then add this module (except for the main module)
    if (!result.includes(module)) {
      result.push(module);
    }
  }

  private buildModuleSymbolTables(
    modules: ResolvedModule[]
  ): Map<string, Map<string, SymbolInfo>> {
    const moduleSymbols = new Map<string, Map<string, SymbolInfo>>();

    for (const module of modules) {
      const program = module.program;
      // Use filename-derived module name (e.g., "math.pas" -> "math")
      const moduleName = path.basename(module.filePath, ".pas");
      const symbols = new Map<string, SymbolInfo>();

      // Add public procedures
      for (const proc of program.procedures) {
        if (proc.isPublic) {
          symbols.set(proc.name, {
            name: proc.name,
            type: "proc",
            sourceModule: module.filePath,
            node: proc,
          });
        }
      }

      // Add public functions
      for (const func of program.functions) {
        if (func.isPublic) {
          symbols.set(func.name, {
            name: func.name,
            type: "func",
            sourceModule: module.filePath,
            node: func,
          });
        }
      }

      // Add public global variables
      for (const globalVar of program.globals) {
        if (globalVar.isPublic) {
          symbols.set(globalVar.name, {
            name: globalVar.name,
            type: "var",
            sourceModule: module.filePath,
            node: globalVar,
          });
        }
      }

      // Add public global constants
      for (const globalConst of program.globalConsts) {
        if (globalConst.isPublic) {
          symbols.set(globalConst.name, {
            name: globalConst.name,
            type: "const",
            sourceModule: module.filePath,
            node: globalConst,
          });
        }
      }

      moduleSymbols.set(moduleName, symbols);
    }

    return moduleSymbols;
  }

}
