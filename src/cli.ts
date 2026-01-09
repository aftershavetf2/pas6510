#!/usr/bin/env node
// pas6510 CLI

import * as fs from "fs";
import * as path from "path";
import { compile } from "./compiler";

function printUsage(): void {
  console.log("pas6510 - Pascal compiler for 6510 CPU");
  console.log("");
  console.log("Usage: pas6510 <input.pas> [options]");
  console.log("");
  console.log("Options:");
  console.log("  -o <file>    Output filename (default: input.asm)");
  console.log("  -h, --help   Show this help");
  console.log("");
  console.log("Example:");
  console.log("  pas6510 game.pas           # Creates game.asm");
  console.log("  pas6510 game.pas -o out.asm");
}

function main(): void {
  const args = process.argv.slice(2);

  if (args.length === 0 || args.includes("-h") || args.includes("--help")) {
    printUsage();
    process.exit(args.length === 0 ? 1 : 0);
  }

  let inputFile: string | null = null;
  let outputFile: string | null = null;

  for (let i = 0; i < args.length; i++) {
    if (args[i] === "-o" && i + 1 < args.length) {
      outputFile = args[++i];
    } else if (!args[i].startsWith("-")) {
      inputFile = args[i];
    }
  }

  if (!inputFile) {
    console.error("Error: No input file specified");
    process.exit(1);
  }

  // Resolve paths
  const inputPath = path.resolve(inputFile);

  if (!fs.existsSync(inputPath)) {
    console.error(`Error: File not found: ${inputPath}`);
    process.exit(1);
  }

  // Default output filename
  if (!outputFile) {
    const ext = path.extname(inputFile);
    outputFile = inputFile.slice(0, -ext.length) + ".asm";
  }
  const outputPath = path.resolve(outputFile);

  // Read and compile
  console.log(`Compiling ${inputFile}...`);

  try {
    const source = fs.readFileSync(inputPath, "utf-8");
    const assembly = compile(source);

    fs.writeFileSync(outputPath, assembly);
    console.log(`Written: ${outputFile}`);

  } catch (e) {
    if (e instanceof Error) {
      console.error(`Compilation error: ${e.message}`);
    } else {
      console.error("Compilation error:", e);
    }
    process.exit(1);
  }
}

main();
