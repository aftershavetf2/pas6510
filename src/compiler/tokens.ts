// Token types for the pas6510 language

export enum TokenType {
  // Keywords
  PROGRAM = "PROGRAM",
  PROC = "PROC",
  FUNC = "FUNC",
  VAR = "VAR",
  DO = "DO",
  END = "END",
  FOR = "FOR",
  TO = "TO",
  IF = "IF",
  THEN = "THEN",
  ELSE = "ELSE",
  WHILE = "WHILE",
  ARRAY = "ARRAY",
  OF = "OF",
  RETURN = "RETURN",

  // Types
  I8 = "I8",
  I16 = "I16",
  U8 = "U8",
  U16 = "U16",
  PTR = "PTR",

  // Literals
  NUMBER = "NUMBER",
  STRING = "STRING",
  IDENTIFIER = "IDENTIFIER",

  // Operators
  PLUS = "PLUS",           // +
  MINUS = "MINUS",         // -
  STAR = "STAR",           // *
  SLASH = "SLASH",         // /
  ASSIGN = "ASSIGN",       // :=
  EQUALS = "EQUALS",       // =
  NOT_EQUALS = "NOT_EQUALS", // <>
  LESS = "LESS",           // <
  GREATER = "GREATER",     // >
  LESS_EQ = "LESS_EQ",     // <=
  GREATER_EQ = "GREATER_EQ", // >=
  AND = "AND",
  OR = "OR",
  NOT = "NOT",

  // Delimiters
  LPAREN = "LPAREN",       // (
  RPAREN = "RPAREN",       // )
  LBRACKET = "LBRACKET",   // [
  RBRACKET = "RBRACKET",   // ]
  COLON = "COLON",         // :
  SEMICOLON = "SEMICOLON", // ;
  COMMA = "COMMA",         // ,

  // Directives
  DIRECTIVE_ORG = "DIRECTIVE_ORG",  // {ORG 0x1000}

  // Special
  EOF = "EOF",
}

export interface Token {
  type: TokenType;
  value: string;
  line: number;
  column: number;
}

export const KEYWORDS: Record<string, TokenType> = {
  program: TokenType.PROGRAM,
  proc: TokenType.PROC,
  func: TokenType.FUNC,
  var: TokenType.VAR,
  do: TokenType.DO,
  end: TokenType.END,
  for: TokenType.FOR,
  to: TokenType.TO,
  if: TokenType.IF,
  then: TokenType.THEN,
  else: TokenType.ELSE,
  while: TokenType.WHILE,
  array: TokenType.ARRAY,
  of: TokenType.OF,
  return: TokenType.RETURN,
  i8: TokenType.I8,
  i16: TokenType.I16,
  u8: TokenType.U8,
  u16: TokenType.U16,
  ptr: TokenType.PTR,
  and: TokenType.AND,
  or: TokenType.OR,
  not: TokenType.NOT,
};
