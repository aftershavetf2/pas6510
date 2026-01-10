// Parser for the pas6510 language

import { Token, TokenType } from "./tokens";
import {
  ProgramNode,
  ProcedureNode,
  FunctionNode,
  VarDecl,
  GlobalVarDecl,
  ImportNode,
  StatementNode,
  ExpressionNode,
  DataType,
  VarType,
  AssignmentNode,
  ForLoopNode,
  WhileLoopNode,
  IfNode,
  CallNode,
  ReturnNode,
  LValueNode,
} from "./ast";

export class Parser {
  private tokens: Token[];
  private pos: number = 0;

  constructor(tokens: Token[]) {
    this.tokens = tokens;
  }

  private peek(offset: number = 0): Token {
    const pos = this.pos + offset;
    if (pos >= this.tokens.length) {
      return this.tokens[this.tokens.length - 1]; // EOF
    }
    return this.tokens[pos];
  }

  private advance(): Token {
    const token = this.peek();
    this.pos++;
    return token;
  }

  private expect(type: TokenType, message?: string): Token {
    const token = this.peek();
    if (token.type !== type) {
      throw new Error(
        message ||
          `Expected ${type} but got ${token.type} at line ${token.line}, column ${token.column}`
      );
    }
    return this.advance();
  }

  private match(...types: TokenType[]): boolean {
    return types.includes(this.peek().type);
  }

  parse(): ProgramNode {
    return this.parseProgram();
  }

  private parseProgram(): ProgramNode {
    // Parse imports first (before ORG and PROGRAM)
    const imports: ImportNode[] = [];
    while (this.match(TokenType.IMPORT)) {
      imports.push(this.parseImportStatement());
    }

    // Check for optional ORG directive before program
    let org: number | undefined;
    if (this.match(TokenType.DIRECTIVE_ORG)) {
      const orgToken = this.advance();
      org = this.parseAddress(orgToken.value);
    }

    this.expect(TokenType.PROGRAM);
    const nameToken = this.expect(TokenType.IDENTIFIER);

    const globals: GlobalVarDecl[] = [];
    const procedures: ProcedureNode[] = [];
    const functions: FunctionNode[] = [];

    while (!this.match(TokenType.EOF)) {
      // Check for 'pub' modifier
      const isPublic = this.match(TokenType.PUB);
      if (isPublic) {
        this.advance();
      }

      if (this.match(TokenType.PROC)) {
        procedures.push(this.parseProcedure(isPublic));
      } else if (this.match(TokenType.FUNC)) {
        functions.push(this.parseFunction(isPublic));
      } else if (this.match(TokenType.VAR)) {
        globals.push(this.parseGlobalVar(isPublic));
      } else {
        throw new Error(
          `Unexpected token ${this.peek().type} at line ${this.peek().line}`
        );
      }
    }

    return {
      kind: "Program",
      name: nameToken.value,
      org,
      imports,
      globals,
      procedures,
      functions,
    };
  }

  private parseImportStatement(): ImportNode {
    this.expect(TokenType.IMPORT);
    const names: string[] = [];

    // Parse comma-separated list of identifiers
    names.push(this.expect(TokenType.IDENTIFIER).value);
    while (this.match(TokenType.COMMA)) {
      this.advance();
      names.push(this.expect(TokenType.IDENTIFIER).value);
    }

    this.expect(TokenType.FROM);
    const modulePath = this.expect(TokenType.STRING).value;
    this.expect(TokenType.SEMICOLON);

    return { names, modulePath };
  }

  private parseGlobalVar(isPublic: boolean): GlobalVarDecl {
    this.expect(TokenType.VAR);
    const name = this.expect(TokenType.IDENTIFIER).value;
    this.expect(TokenType.COLON);
    const varType = this.parseType();
    this.expect(TokenType.SEMICOLON);

    return { name, varType, isPublic };
  }

  private parseAddress(value: string): number {
    if (value.startsWith("0x") || value.startsWith("0X")) {
      return parseInt(value.slice(2), 16);
    } else if (value.startsWith("$")) {
      return parseInt(value.slice(1), 16);
    }
    return parseInt(value, 10);
  }

  private parseProcedure(isPublic: boolean = false): ProcedureNode {
    this.expect(TokenType.PROC);
    const nameToken = this.expect(TokenType.IDENTIFIER);
    const params = this.parseParams();

    const locals: VarDecl[] = [];
    const body: StatementNode[] = [];

    // Parse var declarations and statements until 'end'
    while (!this.match(TokenType.END)) {
      if (this.match(TokenType.VAR)) {
        locals.push(...this.parseVarDeclarations());
      } else {
        body.push(this.parseStatement());
      }
    }

    this.expect(TokenType.END);
    this.expect(TokenType.SEMICOLON);

    return {
      kind: "Procedure",
      name: nameToken.value,
      params,
      locals,
      body,
      isPublic,
    };
  }

  private parseFunction(isPublic: boolean = false): FunctionNode {
    this.expect(TokenType.FUNC);
    const nameToken = this.expect(TokenType.IDENTIFIER);
    const params = this.parseParams();
    this.expect(TokenType.COLON);
    const returnType = this.parseDataType();

    const locals: VarDecl[] = [];
    const body: StatementNode[] = [];

    while (!this.match(TokenType.END)) {
      if (this.match(TokenType.VAR)) {
        locals.push(...this.parseVarDeclarations());
      } else {
        body.push(this.parseStatement());
      }
    }

    this.expect(TokenType.END);
    this.expect(TokenType.SEMICOLON);

    return {
      kind: "Function",
      name: nameToken.value,
      params,
      returnType,
      locals,
      body,
      isPublic,
    };
  }

  private parseParams(): VarDecl[] {
    this.expect(TokenType.LPAREN);
    const params: VarDecl[] = [];

    if (!this.match(TokenType.RPAREN)) {
      do {
        if (this.match(TokenType.COMMA)) this.advance();
        const name = this.expect(TokenType.IDENTIFIER).value;
        this.expect(TokenType.COLON);
        const varType = this.parseType();
        params.push({ name, varType });
      } while (this.match(TokenType.COMMA));
    }

    this.expect(TokenType.RPAREN);
    return params;
  }

  private parseVarDeclarations(): VarDecl[] {
    this.expect(TokenType.VAR);
    const decls: VarDecl[] = [];

    const name = this.expect(TokenType.IDENTIFIER).value;
    this.expect(TokenType.COLON);
    const varType = this.parseType();
    this.expect(TokenType.SEMICOLON);
    decls.push({ name, varType });

    return decls;
  }

  private parseType(): VarType {
    if (this.match(TokenType.ARRAY)) {
      this.advance();
      this.expect(TokenType.LBRACKET);
      const sizeToken = this.expect(TokenType.NUMBER);
      const size = this.parseNumber(sizeToken.value).value;
      this.expect(TokenType.RBRACKET);
      this.expect(TokenType.OF);
      const elementType = this.parseDataType();
      return { elementType, size };
    }
    return this.parseDataType();
  }

  private parseDataType(): DataType {
    const token = this.advance();
    switch (token.type) {
      case TokenType.I8:
        return "i8";
      case TokenType.I16:
        return "i16";
      case TokenType.U8:
        return "u8";
      case TokenType.U16:
        return "u16";
      case TokenType.PTR:
        return "ptr";
      default:
        throw new Error(
          `Expected type but got ${token.type} at line ${token.line}`
        );
    }
  }

  private parseStatement(): StatementNode {
    // For loop
    if (this.match(TokenType.FOR)) {
      return this.parseForLoop();
    }

    // While loop
    if (this.match(TokenType.WHILE)) {
      return this.parseWhileLoop();
    }

    // If statement
    if (this.match(TokenType.IF)) {
      return this.parseIf();
    }

    // Return statement
    if (this.match(TokenType.RETURN)) {
      return this.parseReturn();
    }

    // Assignment or procedure call
    if (this.match(TokenType.IDENTIFIER)) {
      const name = this.advance().value;

      // Procedure call
      if (this.match(TokenType.LPAREN)) {
        const args = this.parseArgs();
        this.expect(TokenType.SEMICOLON);
        return { kind: "Call", name, args } as CallNode;
      }

      // Array assignment
      if (this.match(TokenType.LBRACKET)) {
        this.advance();
        const index = this.parseExpression();
        this.expect(TokenType.RBRACKET);
        this.expect(TokenType.ASSIGN);
        const value = this.parseExpression();
        this.expect(TokenType.SEMICOLON);
        return {
          kind: "Assignment",
          target: { kind: "ArrayAccess", array: name, index },
          value,
        } as AssignmentNode;
      }

      // Variable assignment
      this.expect(TokenType.ASSIGN);
      const value = this.parseExpression();
      this.expect(TokenType.SEMICOLON);
      return {
        kind: "Assignment",
        target: { kind: "Variable", name },
        value,
      } as AssignmentNode;
    }

    throw new Error(
      `Unexpected token ${this.peek().type} at line ${this.peek().line}`
    );
  }

  private parseForLoop(): ForLoopNode {
    this.expect(TokenType.FOR);
    const variable = this.expect(TokenType.IDENTIFIER).value;
    this.expect(TokenType.EQUALS);
    const start = this.parseExpression();
    this.expect(TokenType.TO);
    const end = this.parseExpression();
    this.expect(TokenType.DO);

    const body: StatementNode[] = [];
    while (!this.match(TokenType.END)) {
      body.push(this.parseStatement());
    }
    this.expect(TokenType.END);
    this.expect(TokenType.SEMICOLON);

    return { kind: "ForLoop", variable, start, end, body };
  }

  private parseWhileLoop(): WhileLoopNode {
    this.expect(TokenType.WHILE);
    const condition = this.parseExpression();
    this.expect(TokenType.DO);

    const body: StatementNode[] = [];
    while (!this.match(TokenType.END)) {
      body.push(this.parseStatement());
    }
    this.expect(TokenType.END);
    this.expect(TokenType.SEMICOLON);

    return { kind: "WhileLoop", condition, body };
  }

  private parseIf(): IfNode {
    this.expect(TokenType.IF);
    const condition = this.parseExpression();
    this.expect(TokenType.THEN);

    const thenBranch: StatementNode[] = [];
    while (!this.match(TokenType.END) && !this.match(TokenType.ELSE)) {
      thenBranch.push(this.parseStatement());
    }

    const elseBranch: StatementNode[] = [];
    if (this.match(TokenType.ELSE)) {
      this.advance();
      while (!this.match(TokenType.END)) {
        elseBranch.push(this.parseStatement());
      }
    }

    this.expect(TokenType.END);
    this.expect(TokenType.SEMICOLON);

    return { kind: "If", condition, thenBranch, elseBranch };
  }

  private parseReturn(): ReturnNode {
    this.expect(TokenType.RETURN);
    let value: ExpressionNode | undefined;
    if (!this.match(TokenType.SEMICOLON)) {
      value = this.parseExpression();
    }
    this.expect(TokenType.SEMICOLON);
    return { kind: "Return", value };
  }

  private parseArgs(): ExpressionNode[] {
    this.expect(TokenType.LPAREN);
    const args: ExpressionNode[] = [];

    if (!this.match(TokenType.RPAREN)) {
      args.push(this.parseExpression());
      while (this.match(TokenType.COMMA)) {
        this.advance();
        args.push(this.parseExpression());
      }
    }

    this.expect(TokenType.RPAREN);
    return args;
  }

  private parseExpression(): ExpressionNode {
    return this.parseOr();
  }

  private parseOr(): ExpressionNode {
    let left = this.parseAnd();

    while (this.match(TokenType.OR)) {
      this.advance();
      const right = this.parseAnd();
      left = { kind: "BinaryOp", operator: "or", left, right };
    }

    return left;
  }

  private parseAnd(): ExpressionNode {
    let left = this.parseComparison();

    while (this.match(TokenType.AND)) {
      this.advance();
      const right = this.parseComparison();
      left = { kind: "BinaryOp", operator: "and", left, right };
    }

    return left;
  }

  private parseComparison(): ExpressionNode {
    let left = this.parseAdditive();

    while (
      this.match(
        TokenType.EQUALS,
        TokenType.NOT_EQUALS,
        TokenType.LESS,
        TokenType.GREATER,
        TokenType.LESS_EQ,
        TokenType.GREATER_EQ
      )
    ) {
      const op = this.advance();
      const right = this.parseAdditive();
      const operator = this.tokenToOperator(op.type);
      left = { kind: "BinaryOp", operator, left, right };
    }

    return left;
  }

  private parseAdditive(): ExpressionNode {
    let left = this.parseMultiplicative();

    while (this.match(TokenType.PLUS, TokenType.MINUS)) {
      const op = this.advance();
      const right = this.parseMultiplicative();
      const operator = op.type === TokenType.PLUS ? "+" : "-";
      left = { kind: "BinaryOp", operator, left, right };
    }

    return left;
  }

  private parseMultiplicative(): ExpressionNode {
    let left = this.parseUnary();

    while (this.match(TokenType.STAR, TokenType.SLASH)) {
      const op = this.advance();
      const right = this.parseUnary();
      const operator = op.type === TokenType.STAR ? "*" : "/";
      left = { kind: "BinaryOp", operator, left, right };
    }

    return left;
  }

  private parseUnary(): ExpressionNode {
    if (this.match(TokenType.MINUS)) {
      this.advance();
      const operand = this.parseUnary();
      return { kind: "UnaryOp", operator: "-", operand };
    }

    if (this.match(TokenType.NOT)) {
      this.advance();
      const operand = this.parseUnary();
      return { kind: "UnaryOp", operator: "not", operand };
    }

    return this.parsePrimary();
  }

  private parsePrimary(): ExpressionNode {
    // Number literal
    if (this.match(TokenType.NUMBER)) {
      const token = this.advance();
      const parsed = this.parseNumber(token.value);
      return { kind: "NumberLiteral", value: parsed.value, inferredType: parsed.inferredType };
    }

    // String literal
    if (this.match(TokenType.STRING)) {
      const token = this.advance();
      return { kind: "StringLiteral", value: token.value };
    }

    // Parenthesized expression
    if (this.match(TokenType.LPAREN)) {
      this.advance();
      const expr = this.parseExpression();
      this.expect(TokenType.RPAREN);
      return expr;
    }

    // Identifier (variable or function call)
    if (this.match(TokenType.IDENTIFIER)) {
      const name = this.advance().value;

      // Function call
      if (this.match(TokenType.LPAREN)) {
        const args = this.parseArgs();
        return { kind: "CallExpr", name, args };
      }

      // Array access
      if (this.match(TokenType.LBRACKET)) {
        this.advance();
        const index = this.parseExpression();
        this.expect(TokenType.RBRACKET);
        return { kind: "ArrayAccess", array: name, index };
      }

      // Simple variable
      return { kind: "Variable", name };
    }

    throw new Error(
      `Unexpected token ${this.peek().type} at line ${this.peek().line}`
    );
  }

  private parseNumber(value: string): { value: number; inferredType?: "u8" | "u16" } {
    if (value.startsWith("$")) {
      const hexPart = value.slice(1);
      const numValue = parseInt(hexPart, 16);
      // 1-2 hex digits = u8, 3-4 hex digits = u16
      const inferredType = hexPart.length <= 2 ? "u8" : "u16";
      return { value: numValue, inferredType };
    }
    return { value: parseInt(value, 10) };
  }

  private tokenToOperator(
    type: TokenType
  ): "=" | "<>" | "<" | ">" | "<=" | ">=" {
    switch (type) {
      case TokenType.EQUALS:
        return "=";
      case TokenType.NOT_EQUALS:
        return "<>";
      case TokenType.LESS:
        return "<";
      case TokenType.GREATER:
        return ">";
      case TokenType.LESS_EQ:
        return "<=";
      case TokenType.GREATER_EQ:
        return ">=";
      default:
        throw new Error(`Invalid comparison operator: ${type}`);
    }
  }
}
