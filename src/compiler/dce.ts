// Dead Code Elimination - finds reachable procedures/functions from main()

import * as path from "path";
import {
  ProgramNode,
  ProcedureNode,
  FunctionNode,
  StatementNode,
  ExpressionNode,
} from "./ast";
import { ResolvedProgram } from "./resolver";

// Collect all function/procedure calls from a list of statements
function collectCallsFromStatements(statements: StatementNode[], calls: Set<string>): void {
  for (const stmt of statements) {
    switch (stmt.kind) {
      case "Call":
        // Handle qualified names (moduleName_funcName)
        if (stmt.moduleName) {
          calls.add(`${stmt.moduleName}_${stmt.name}`);
        } else {
          calls.add(stmt.name);
        }
        // Also check arguments for nested function calls
        for (const arg of stmt.args) {
          collectCallsFromExpression(arg, calls);
        }
        break;
      case "Assignment":
        collectCallsFromExpression(stmt.value, calls);
        // Check if target is an array access with expression index
        if (stmt.target.kind === "ArrayAccess") {
          collectCallsFromExpression(stmt.target.index, calls);
        }
        break;
      case "ForLoop":
        collectCallsFromExpression(stmt.start, calls);
        collectCallsFromExpression(stmt.end, calls);
        collectCallsFromStatements(stmt.body, calls);
        break;
      case "WhileLoop":
        collectCallsFromExpression(stmt.condition, calls);
        collectCallsFromStatements(stmt.body, calls);
        break;
      case "If":
        collectCallsFromExpression(stmt.condition, calls);
        collectCallsFromStatements(stmt.thenBranch, calls);
        collectCallsFromStatements(stmt.elseBranch, calls);
        break;
      case "Return":
        if (stmt.value) {
          collectCallsFromExpression(stmt.value, calls);
        }
        break;
    }
  }
}

// Collect all function calls from an expression
function collectCallsFromExpression(expr: ExpressionNode, calls: Set<string>): void {
  switch (expr.kind) {
    case "CallExpr":
      // Handle qualified names (moduleName_funcName)
      if (expr.moduleName) {
        calls.add(`${expr.moduleName}_${expr.name}`);
      } else {
        calls.add(expr.name);
      }
      for (const arg of expr.args) {
        collectCallsFromExpression(arg, calls);
      }
      break;
    case "BinaryOp":
      collectCallsFromExpression(expr.left, calls);
      collectCallsFromExpression(expr.right, calls);
      break;
    case "UnaryOp":
      collectCallsFromExpression(expr.operand, calls);
      break;
    case "ArrayAccess":
      collectCallsFromExpression(expr.index, calls);
      break;
    // NumberLiteral, StringLiteral, Variable don't contain calls
  }
}

// Collect all variable references from a list of statements
function collectVarsFromStatements(statements: StatementNode[], vars: Set<string>): void {
  for (const stmt of statements) {
    switch (stmt.kind) {
      case "Call":
        for (const arg of stmt.args) {
          collectVarsFromExpression(arg, vars);
        }
        break;
      case "Assignment":
        // Target variable
        if (stmt.target.kind === "Variable") {
          // Handle qualified names (moduleName.varName)
          if (stmt.target.moduleName) {
            vars.add(`${stmt.target.moduleName}.${stmt.target.name}`);
          } else {
            vars.add(stmt.target.name);
          }
        } else if (stmt.target.kind === "ArrayAccess") {
          // Handle qualified names (moduleName.varName)
          if (stmt.target.moduleName) {
            vars.add(`${stmt.target.moduleName}.${stmt.target.array}`);
          } else {
            vars.add(stmt.target.array);
          }
          collectVarsFromExpression(stmt.target.index, vars);
        }
        collectVarsFromExpression(stmt.value, vars);
        break;
      case "ForLoop":
        vars.add(stmt.variable);
        collectVarsFromExpression(stmt.start, vars);
        collectVarsFromExpression(stmt.end, vars);
        collectVarsFromStatements(stmt.body, vars);
        break;
      case "WhileLoop":
        collectVarsFromExpression(stmt.condition, vars);
        collectVarsFromStatements(stmt.body, vars);
        break;
      case "If":
        collectVarsFromExpression(stmt.condition, vars);
        collectVarsFromStatements(stmt.thenBranch, vars);
        collectVarsFromStatements(stmt.elseBranch, vars);
        break;
      case "Return":
        if (stmt.value) {
          collectVarsFromExpression(stmt.value, vars);
        }
        break;
    }
  }
}

// Collect all variable references from an expression
function collectVarsFromExpression(expr: ExpressionNode, vars: Set<string>): void {
  switch (expr.kind) {
    case "Variable":
      // Handle qualified names (moduleName.varName)
      if (expr.moduleName) {
        vars.add(`${expr.moduleName}.${expr.name}`);
      } else {
        vars.add(expr.name);
      }
      break;
    case "ArrayAccess":
      // Handle qualified names (moduleName.varName)
      if (expr.moduleName) {
        vars.add(`${expr.moduleName}.${expr.array}`);
      } else {
        vars.add(expr.array);
      }
      collectVarsFromExpression(expr.index, vars);
      break;
    case "CallExpr":
      for (const arg of expr.args) {
        collectVarsFromExpression(arg, vars);
      }
      break;
    case "BinaryOp":
      collectVarsFromExpression(expr.left, vars);
      collectVarsFromExpression(expr.right, vars);
      break;
    case "UnaryOp":
      collectVarsFromExpression(expr.operand, vars);
      break;
    // NumberLiteral, StringLiteral don't contain variable references
  }
}

// Get all variables referenced by a procedure
function getVarsFromProcedure(proc: ProcedureNode): Set<string> {
  const vars = new Set<string>();
  collectVarsFromStatements(proc.body, vars);
  return vars;
}

// Get all variables referenced by a function
function getVarsFromFunction(func: FunctionNode): Set<string> {
  const vars = new Set<string>();
  collectVarsFromStatements(func.body, vars);
  return vars;
}

// Get all calls made by a procedure
function getCallsFromProcedure(proc: ProcedureNode): Set<string> {
  const calls = new Set<string>();
  collectCallsFromStatements(proc.body, calls);
  return calls;
}

// Get all calls made by a function
function getCallsFromFunction(func: FunctionNode): Set<string> {
  const calls = new Set<string>();
  collectCallsFromStatements(func.body, calls);
  return calls;
}

// Build a call graph: maps each procedure/function to the set of procedures/functions it calls
export function buildCallGraph(resolved: ResolvedProgram): Map<string, Set<string>> {
  const callGraph = new Map<string, Set<string>>();

  // Process main module
  const mainProgram = resolved.mainModule.program;
  for (const proc of mainProgram.procedures) {
    callGraph.set(proc.name, getCallsFromProcedure(proc));
  }
  for (const func of mainProgram.functions) {
    callGraph.set(func.name, getCallsFromFunction(func));
  }

  // Process all dependencies
  for (const dep of resolved.dependencies) {
    if (dep.filePath === resolved.mainModule.filePath) continue;

    // Use filename-derived module name (e.g., "math.pas" -> "math")
    const moduleName = path.basename(dep.filePath, ".pas");

    // Build set of module's own procedure/function names for resolving internal calls
    const moduleFuncs = new Set<string>();
    for (const p of dep.program.procedures) {
      moduleFuncs.add(p.name);
    }
    for (const f of dep.program.functions) {
      moduleFuncs.add(f.name);
    }

    // Include ALL procedures/functions in call graph (not just public ones)
    // because public procedures may call internal ones
    for (const proc of dep.program.procedures) {
      const calls = getCallsFromProcedure(proc);
      // Qualify internal calls to same module's functions
      const qualifiedCalls = new Set<string>();
      for (const call of calls) {
        // If this is an unqualified call to a function in this module, qualify it
        if (moduleFuncs.has(call)) {
          qualifiedCalls.add(`${moduleName}_${call}`);
        } else {
          qualifiedCalls.add(call);
        }
      }
      callGraph.set(`${moduleName}_${proc.name}`, qualifiedCalls);
    }
    for (const func of dep.program.functions) {
      const calls = getCallsFromFunction(func);
      // Qualify internal calls to same module's functions
      const qualifiedCalls = new Set<string>();
      for (const call of calls) {
        // If this is an unqualified call to a function in this module, qualify it
        if (moduleFuncs.has(call)) {
          qualifiedCalls.add(`${moduleName}_${call}`);
        } else {
          qualifiedCalls.add(call);
        }
      }
      callGraph.set(`${moduleName}_${func.name}`, qualifiedCalls);
    }
  }

  return callGraph;
}

// Find all procedures/functions reachable from the entry point (main)
export function findReachable(callGraph: Map<string, Set<string>>): Set<string> {
  const reachable = new Set<string>();
  const worklist: string[] = ["main"];

  while (worklist.length > 0) {
    const current = worklist.pop()!;

    if (reachable.has(current)) {
      continue;
    }

    reachable.add(current);

    // Add all functions called by current
    const calls = callGraph.get(current);
    if (calls) {
      for (const callee of calls) {
        if (!reachable.has(callee)) {
          worklist.push(callee);
        }
      }
    }
  }

  return reachable;
}

// Main entry point: compute reachable set for a resolved program
export function computeReachableSet(resolved: ResolvedProgram): Set<string> {
  const callGraph = buildCallGraph(resolved);
  return findReachable(callGraph);
}

// Compute the set of variables used by reachable procedures/functions
export function computeUsedVariables(resolved: ResolvedProgram, reachable: Set<string>): Set<string> {
  const usedVars = new Set<string>();

  // Process main module
  const mainProgram = resolved.mainModule.program;
  for (const proc of mainProgram.procedures) {
    if (reachable.has(proc.name)) {
      const vars = getVarsFromProcedure(proc);
      for (const v of vars) {
        usedVars.add(v);
      }
      // Also add parameter names (they become variables)
      for (const param of proc.params) {
        usedVars.add(param.name);
      }
      // Also add local variable names
      for (const local of proc.locals) {
        usedVars.add(local.name);
      }
    }
  }
  for (const func of mainProgram.functions) {
    if (reachable.has(func.name)) {
      const vars = getVarsFromFunction(func);
      for (const v of vars) {
        usedVars.add(v);
      }
      for (const param of func.params) {
        usedVars.add(param.name);
      }
      for (const local of func.locals) {
        usedVars.add(local.name);
      }
    }
  }

  // Process dependencies
  for (const dep of resolved.dependencies) {
    if (dep.filePath === resolved.mainModule.filePath) continue;

    // Use filename-derived module name (e.g., "math.pas" -> "math")
    const moduleName = path.basename(dep.filePath, ".pas");

    // Build set of module's own global variable names for resolving unqualified refs
    const moduleGlobals = new Set<string>();
    for (const g of dep.program.globals) {
      moduleGlobals.add(g.name);
    }
    for (const c of dep.program.globalConsts) {
      moduleGlobals.add(c.name);
    }

    for (const proc of dep.program.procedures) {
      const qualifiedName = `${moduleName}_${proc.name}`;
      if (proc.isPublic && reachable.has(qualifiedName)) {
        const vars = getVarsFromProcedure(proc);
        for (const v of vars) {
          // If this is an unqualified reference to module's own global, qualify it
          if (!v.includes(".") && moduleGlobals.has(v)) {
            usedVars.add(`${moduleName}.${v}`);
          } else {
            usedVars.add(v);
          }
        }
        for (const param of proc.params) {
          usedVars.add(param.name);
        }
        for (const local of proc.locals) {
          usedVars.add(local.name);
        }
      }
    }
    for (const func of dep.program.functions) {
      const qualifiedName = `${moduleName}_${func.name}`;
      if (func.isPublic && reachable.has(qualifiedName)) {
        const vars = getVarsFromFunction(func);
        for (const v of vars) {
          // If this is an unqualified reference to module's own global, qualify it
          if (!v.includes(".") && moduleGlobals.has(v)) {
            usedVars.add(`${moduleName}.${v}`);
          } else {
            usedVars.add(v);
          }
        }
        for (const param of func.params) {
          usedVars.add(param.name);
        }
        for (const local of func.locals) {
          usedVars.add(local.name);
        }
      }
    }
  }

  return usedVars;
}
