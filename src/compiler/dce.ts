// Dead Code Elimination - finds reachable procedures/functions from main()

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
        calls.add(stmt.name);
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
      calls.add(expr.name);
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

    for (const proc of dep.program.procedures) {
      if (proc.isPublic) {
        callGraph.set(proc.name, getCallsFromProcedure(proc));
      }
    }
    for (const func of dep.program.functions) {
      if (func.isPublic) {
        callGraph.set(func.name, getCallsFromFunction(func));
      }
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
