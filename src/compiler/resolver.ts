// Module resolver for the pas6510 compiler
// Handles module imports and circular dependency detection

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
  // All public symbols available for the main module
  availableSymbols: Map<string, SymbolInfo>;
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

    // Build symbol table from all public exports
    const availableSymbols = this.buildSymbolTable(dependencies);

    // Validate that all imports can be satisfied
    this.validateImports(mainModule, availableSymbols);

    return {
      mainModule,
      dependencies,
      availableSymbols,
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

    // Recursively resolve imports
    const moduleDir = path.dirname(filePath);
    for (const imp of program.imports) {
      const importPath = path.resolve(moduleDir, imp.modulePath);
      this.resolveModule(importPath);
    }

    // Mark as resolved
    this.resolving.delete(normalizedPath);
    this.resolvedModules.set(normalizedPath, resolvedModule);

    return resolvedModule;
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
    for (const imp of module.program.imports) {
      const importPath = path.normalize(path.resolve(moduleDir, imp.modulePath));
      const depModule = this.resolvedModules.get(importPath);
      if (depModule) {
        this.collectDependencies(depModule, result, visited);
      }
    }

    // Then add this module (except for the main module)
    if (!result.includes(module)) {
      result.push(module);
    }
  }

  private buildSymbolTable(
    modules: ResolvedModule[]
  ): Map<string, SymbolInfo> {
    const symbols = new Map<string, SymbolInfo>();

    for (const module of modules) {
      const program = module.program;

      // Add public procedures
      for (const proc of program.procedures) {
        if (proc.isPublic) {
          if (symbols.has(proc.name)) {
            throw new Error(
              `Duplicate symbol '${proc.name}' exported from multiple modules`
            );
          }
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
          if (symbols.has(func.name)) {
            throw new Error(
              `Duplicate symbol '${func.name}' exported from multiple modules`
            );
          }
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
          if (symbols.has(globalVar.name)) {
            throw new Error(
              `Duplicate symbol '${globalVar.name}' exported from multiple modules`
            );
          }
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
          if (symbols.has(globalConst.name)) {
            throw new Error(
              `Duplicate symbol '${globalConst.name}' exported from multiple modules`
            );
          }
          symbols.set(globalConst.name, {
            name: globalConst.name,
            type: "const",
            sourceModule: module.filePath,
            node: globalConst,
          });
        }
      }
    }

    return symbols;
  }

  private validateImports(
    module: ResolvedModule,
    availableSymbols: Map<string, SymbolInfo>
  ): void {
    const moduleDir = path.dirname(module.filePath);

    for (const imp of module.program.imports) {
      const importPath = path.normalize(path.resolve(moduleDir, imp.modulePath));
      const importedModule = this.resolvedModules.get(importPath);

      if (!importedModule) {
        throw new Error(`Module not found: ${imp.modulePath}`);
      }

      // Check each imported symbol
      for (const symbolName of imp.names) {
        // Check if the symbol is exported from the specified module
        const isExportedFromModule =
          importedModule.program.procedures.some(
            (p) => p.name === symbolName && p.isPublic
          ) ||
          importedModule.program.functions.some(
            (f) => f.name === symbolName && f.isPublic
          ) ||
          importedModule.program.globals.some(
            (g) => g.name === symbolName && g.isPublic
          ) ||
          importedModule.program.globalConsts.some(
            (c) => c.name === symbolName && c.isPublic
          );

        if (!isExportedFromModule) {
          // Check if symbol exists but is not public
          const existsButNotPublic =
            importedModule.program.procedures.some(
              (p) => p.name === symbolName
            ) ||
            importedModule.program.functions.some(
              (f) => f.name === symbolName
            ) ||
            importedModule.program.globals.some((g) => g.name === symbolName) ||
            importedModule.program.globalConsts.some((c) => c.name === symbolName);

          if (existsButNotPublic) {
            throw new Error(
              `Symbol '${symbolName}' in ${imp.modulePath} is not public. Add 'pub' keyword to export it.`
            );
          } else {
            throw new Error(
              `Symbol '${symbolName}' not found in ${imp.modulePath}`
            );
          }
        }
      }
    }
  }
}
