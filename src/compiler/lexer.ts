// Lexer for the pas6510 language

import { Token, TokenType, KEYWORDS } from "./tokens";

export class Lexer {
  private source: string;
  private pos: number = 0;
  private line: number = 1;
  private column: number = 1;

  constructor(source: string) {
    this.source = source;
  }

  private peek(offset: number = 0): string {
    const pos = this.pos + offset;
    if (pos >= this.source.length) return "\0";
    return this.source[pos];
  }

  private advance(): string {
    const ch = this.peek();
    this.pos++;
    if (ch === "\n") {
      this.line++;
      this.column = 1;
    } else {
      this.column++;
    }
    return ch;
  }

  private skipWhitespace(): void {
    while (this.peek() === " " || this.peek() === "\t" || this.peek() === "\n" || this.peek() === "\r") {
      this.advance();
    }
  }

  private skipComment(): boolean {
    // Single-line comment: //
    if (this.peek() === "/" && this.peek(1) === "/") {
      while (this.peek() !== "\n" && this.peek() !== "\0") {
        this.advance();
      }
      return true;
    }
    // Block comment: { } (but not directives like {ORG})
    if (this.peek() === "{") {
      // Check if this is a directive - peek ahead to see if it starts with ORG
      let lookahead = 1;
      while (this.peek(lookahead) === " " || this.peek(lookahead) === "\t") {
        lookahead++;
      }
      // If it's a directive, don't skip it as a comment
      if (this.source.substring(this.pos + lookahead, this.pos + lookahead + 3).toUpperCase() === "ORG") {
        return false;
      }
      // Otherwise it's a regular comment
      this.advance();
      while (this.peek() !== "}" && this.peek() !== "\0") {
        this.advance();
      }
      if (this.peek() === "}") this.advance();
      return true;
    }
    // Block comment: (* *)
    if (this.peek() === "(" && this.peek(1) === "*") {
      this.advance();
      this.advance();
      while (!(this.peek() === "*" && this.peek(1) === ")") && this.peek() !== "\0") {
        this.advance();
      }
      if (this.peek() === "*") {
        this.advance();
        this.advance();
      }
      return true;
    }
    return false;
  }

  private readDirective(): Token | null {
    if (this.peek() !== "{") return null;

    const startLine = this.line;
    const startColumn = this.column;
    this.advance(); // consume {

    // Skip whitespace
    while (this.peek() === " " || this.peek() === "\t") {
      this.advance();
    }

    // Read directive name
    let name = "";
    while (/[a-zA-Z]/.test(this.peek())) {
      name += this.advance();
    }

    if (name.toUpperCase() === "ORG") {
      // Skip whitespace
      while (this.peek() === " " || this.peek() === "\t") {
        this.advance();
      }

      // Read address value (supports 0x, $, or decimal)
      let value = "";
      if (this.peek() === "0" && (this.peek(1) === "x" || this.peek(1) === "X")) {
        this.advance(); // 0
        this.advance(); // x
        while (/[0-9a-fA-F]/.test(this.peek())) {
          value += this.advance();
        }
        value = "0x" + value;
      } else if (this.peek() === "$") {
        this.advance(); // $
        while (/[0-9a-fA-F]/.test(this.peek())) {
          value += this.advance();
        }
        value = "$" + value;
      } else {
        while (/[0-9]/.test(this.peek())) {
          value += this.advance();
        }
      }

      // Skip to closing brace
      while (this.peek() !== "}" && this.peek() !== "\0") {
        this.advance();
      }
      if (this.peek() === "}") this.advance();

      return this.makeToken(TokenType.DIRECTIVE_ORG, value, startLine, startColumn);
    }

    // Unknown directive - skip as comment
    while (this.peek() !== "}" && this.peek() !== "\0") {
      this.advance();
    }
    if (this.peek() === "}") this.advance();
    return null;
  }

  private makeToken(type: TokenType, value: string, line: number, column: number): Token {
    return { type, value, line, column };
  }

  private readNumber(): Token {
    const startLine = this.line;
    const startColumn = this.column;
    let value = "";

    // Check for hex: $xxxx
    if (this.peek() === "$") {
      value += this.advance();
      while (/[0-9a-fA-F]/.test(this.peek())) {
        value += this.advance();
      }
    } else {
      while (/[0-9]/.test(this.peek())) {
        value += this.advance();
      }
    }

    return this.makeToken(TokenType.NUMBER, value, startLine, startColumn);
  }

  private readString(): Token {
    const startLine = this.line;
    const startColumn = this.column;
    const quote = this.advance(); // consume opening quote
    let value = "";

    while (this.peek() !== quote && this.peek() !== "\0") {
      value += this.advance();
    }

    if (this.peek() === quote) {
      this.advance(); // consume closing quote
    }

    return this.makeToken(TokenType.STRING, value, startLine, startColumn);
  }

  private readIdentifier(): Token {
    const startLine = this.line;
    const startColumn = this.column;
    let value = "";

    while (/[a-zA-Z0-9_]/.test(this.peek())) {
      value += this.advance();
    }

    const keyword = KEYWORDS[value.toLowerCase()];
    if (keyword) {
      return this.makeToken(keyword, value, startLine, startColumn);
    }

    return this.makeToken(TokenType.IDENTIFIER, value, startLine, startColumn);
  }

  tokenize(): Token[] {
    const tokens: Token[] = [];

    while (this.peek() !== "\0") {
      this.skipWhitespace();
      if (this.skipComment()) continue;
      this.skipWhitespace();

      if (this.peek() === "\0") break;

      // Check for directives
      if (this.peek() === "{") {
        const directive = this.readDirective();
        if (directive) {
          tokens.push(directive);
          continue;
        }
      }

      const startLine = this.line;
      const startColumn = this.column;
      const ch = this.peek();

      // Numbers
      if (/[0-9]/.test(ch) || ch === "$") {
        tokens.push(this.readNumber());
        continue;
      }

      // Strings
      if (ch === "'" || ch === '"') {
        tokens.push(this.readString());
        continue;
      }

      // Identifiers and keywords
      if (/[a-zA-Z_]/.test(ch)) {
        tokens.push(this.readIdentifier());
        continue;
      }

      // Two-character operators
      if (ch === ":" && this.peek(1) === "=") {
        this.advance();
        this.advance();
        tokens.push(this.makeToken(TokenType.ASSIGN, ":=", startLine, startColumn));
        continue;
      }
      if (ch === "<" && this.peek(1) === ">") {
        this.advance();
        this.advance();
        tokens.push(this.makeToken(TokenType.NOT_EQUALS, "<>", startLine, startColumn));
        continue;
      }
      if (ch === "<" && this.peek(1) === "=") {
        this.advance();
        this.advance();
        tokens.push(this.makeToken(TokenType.LESS_EQ, "<=", startLine, startColumn));
        continue;
      }
      if (ch === ">" && this.peek(1) === "=") {
        this.advance();
        this.advance();
        tokens.push(this.makeToken(TokenType.GREATER_EQ, ">=", startLine, startColumn));
        continue;
      }

      // Single-character tokens
      this.advance();
      switch (ch) {
        case "+":
          tokens.push(this.makeToken(TokenType.PLUS, "+", startLine, startColumn));
          break;
        case "-":
          tokens.push(this.makeToken(TokenType.MINUS, "-", startLine, startColumn));
          break;
        case "*":
          tokens.push(this.makeToken(TokenType.STAR, "*", startLine, startColumn));
          break;
        case "/":
          tokens.push(this.makeToken(TokenType.SLASH, "/", startLine, startColumn));
          break;
        case "=":
          tokens.push(this.makeToken(TokenType.EQUALS, "=", startLine, startColumn));
          break;
        case "<":
          tokens.push(this.makeToken(TokenType.LESS, "<", startLine, startColumn));
          break;
        case ">":
          tokens.push(this.makeToken(TokenType.GREATER, ">", startLine, startColumn));
          break;
        case "(":
          tokens.push(this.makeToken(TokenType.LPAREN, "(", startLine, startColumn));
          break;
        case ")":
          tokens.push(this.makeToken(TokenType.RPAREN, ")", startLine, startColumn));
          break;
        case "[":
          tokens.push(this.makeToken(TokenType.LBRACKET, "[", startLine, startColumn));
          break;
        case "]":
          tokens.push(this.makeToken(TokenType.RBRACKET, "]", startLine, startColumn));
          break;
        case ":":
          tokens.push(this.makeToken(TokenType.COLON, ":", startLine, startColumn));
          break;
        case ";":
          tokens.push(this.makeToken(TokenType.SEMICOLON, ";", startLine, startColumn));
          break;
        case ",":
          tokens.push(this.makeToken(TokenType.COMMA, ",", startLine, startColumn));
          break;
        default:
          throw new Error(`Unexpected character '${ch}' at line ${startLine}, column ${startColumn}`);
      }
    }

    tokens.push(this.makeToken(TokenType.EOF, "", this.line, this.column));
    return tokens;
  }
}
