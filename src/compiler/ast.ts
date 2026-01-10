// AST node types for the pas6510 language

export type DataType = "i8" | "i16" | "u8" | "u16" | "ptr" | "void";

export interface ArrayType {
  elementType: DataType;
  size: number;
}

export type VarType = DataType | ArrayType;

export function isArrayType(t: VarType): t is ArrayType {
  return typeof t === "object" && "elementType" in t;
}

// Base AST node
export interface ASTNode {
  kind: string;
}

// Import statement
export interface ImportNode {
  names: string[];       // imported symbols
  modulePath: string;    // path to the module
}

// Program node - root of AST
export interface ProgramNode extends ASTNode {
  kind: "Program";
  name: string;
  org?: number;  // Optional origin address
  imports: ImportNode[];  // Module imports
  globals: GlobalVarDecl[];  // Global variables
  procedures: ProcedureNode[];
  functions: FunctionNode[];
}

// Global variable declaration
export interface GlobalVarDecl {
  name: string;
  varType: VarType;
  isPublic: boolean;
}

// Variable declaration
export interface VarDecl {
  name: string;
  varType: VarType;
}

// Procedure declaration
export interface ProcedureNode extends ASTNode {
  kind: "Procedure";
  name: string;
  params: VarDecl[];
  locals: VarDecl[];
  body: StatementNode[];
  isPublic: boolean;
}

// Function declaration
export interface FunctionNode extends ASTNode {
  kind: "Function";
  name: string;
  params: VarDecl[];
  returnType: DataType;
  locals: VarDecl[];
  body: StatementNode[];
  isPublic: boolean;
}

// Statements
export type StatementNode =
  | AssignmentNode
  | ForLoopNode
  | WhileLoopNode
  | IfNode
  | CallNode
  | ReturnNode;

export interface AssignmentNode extends ASTNode {
  kind: "Assignment";
  target: LValueNode;
  value: ExpressionNode;
}

export interface ForLoopNode extends ASTNode {
  kind: "ForLoop";
  variable: string;
  start: ExpressionNode;
  end: ExpressionNode;
  body: StatementNode[];
}

export interface WhileLoopNode extends ASTNode {
  kind: "WhileLoop";
  condition: ExpressionNode;
  body: StatementNode[];
}

export interface IfNode extends ASTNode {
  kind: "If";
  condition: ExpressionNode;
  thenBranch: StatementNode[];
  elseBranch: StatementNode[];
}

export interface CallNode extends ASTNode {
  kind: "Call";
  name: string;
  args: ExpressionNode[];
}

export interface ReturnNode extends ASTNode {
  kind: "Return";
  value?: ExpressionNode;
}

// L-values (things that can be assigned to)
export type LValueNode = VariableNode | ArrayAccessNode;

// Expressions
export type ExpressionNode =
  | NumberLiteralNode
  | StringLiteralNode
  | VariableNode
  | ArrayAccessNode
  | BinaryOpNode
  | UnaryOpNode
  | CallExprNode;

export interface NumberLiteralNode extends ASTNode {
  kind: "NumberLiteral";
  value: number;
  inferredType?: "u8" | "u16";  // Set for hex literals based on digit count
}

export interface StringLiteralNode extends ASTNode {
  kind: "StringLiteral";
  value: string;
}

export interface VariableNode extends ASTNode {
  kind: "Variable";
  name: string;
}

export interface ArrayAccessNode extends ASTNode {
  kind: "ArrayAccess";
  array: string;
  index: ExpressionNode;
}

export interface BinaryOpNode extends ASTNode {
  kind: "BinaryOp";
  operator: "+" | "-" | "*" | "/" | "=" | "<>" | "<" | ">" | "<=" | ">=" | "and" | "or";
  left: ExpressionNode;
  right: ExpressionNode;
}

export interface UnaryOpNode extends ASTNode {
  kind: "UnaryOp";
  operator: "-" | "not";
  operand: ExpressionNode;
}

export interface CallExprNode extends ASTNode {
  kind: "CallExpr";
  name: string;
  args: ExpressionNode[];
}
