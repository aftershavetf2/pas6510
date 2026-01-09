#!/usr/bin/env node
// pas6510 CLI

import * as fs from "fs";
import * as path from "path";
import { execSync } from "child_process";
import { compileFile } from "./compiler";

function printUsage(): void {
  console.log("pas6510 - Pascal compiler for 6510 CPU");
  console.log("");
  console.log("Usage: pas6510 <input.pas> [options]");
  console.log("");
  console.log("Options:");
  console.log("  -o <file>      Output filename (default: input.prg)");
  console.log("  --asm-only     Only generate .asm, don't assemble");
  console.log("  -h, --help     Show this help");
  console.log("");
  console.log("Example:");
  console.log("  pas6510 game.pas              # Creates game.asm and game.prg");
  console.log("  pas6510 game.pas --asm-only   # Only creates game.asm");
  console.log("  pas6510 game.pas -o out.prg");
}

function runCommand(cmd: string, description: string): void {
  try {
    execSync(cmd, { stdio: "pipe" });
  } catch (e: any) {
    const stderr = e.stderr?.toString() || "";
    const stdout = e.stdout?.toString() || "";
    console.error(`Error during ${description}:`);
    if (stderr) console.error(stderr);
    if (stdout) console.error(stdout);
    process.exit(1);
  }
}

function main(): void {
  const args = process.argv.slice(2);

  if (args.length === 0 || args.includes("-h") || args.includes("--help")) {
    printUsage();
    process.exit(args.length === 0 ? 1 : 0);
  }

  let inputFile: string | null = null;
  let outputFile: string | null = null;
  let asmOnly = args.includes("--asm-only");

  for (let i = 0; i < args.length; i++) {
    if (args[i] === "-o" && i + 1 < args.length) {
      outputFile = args[++i];
    } else if (args[i] === "--asm-only") {
      // Already handled
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
  const inputDir = path.dirname(inputPath);
  const baseName = path.basename(inputFile, path.extname(inputFile));

  if (!fs.existsSync(inputPath)) {
    console.error(`Error: File not found: ${inputPath}`);
    process.exit(1);
  }

  // Output filenames
  const asmFile = path.join(inputDir, baseName + ".asm");
  const objFile = path.join(inputDir, baseName + ".o");
  const prgFile = outputFile
    ? path.resolve(outputFile)
    : path.join(inputDir, baseName + ".prg");
  const cfgFile = path.join(inputDir, baseName + ".cfg");

  // Compile with module resolution
  console.log(`Compiling ${inputFile}...`);

  try {
    const assembly = compileFile(inputPath);

    fs.writeFileSync(asmFile, assembly);
    console.log(`  ${baseName}.asm`);

    if (asmOnly) {
      return;
    }

    // Extract start address from assembly for linker config
    const orgMatch = assembly.match(/\.org \$([0-9A-Fa-f]+)/);
    const startAddr = orgMatch ? orgMatch[1] : "0801";

    // Create linker config
    const linkerConfig = `
MEMORY {
  RAM: start = $${startAddr}, size = $10000 - $${startAddr}, file = %O, fill = no;
}
SEGMENTS {
  CODE: load = RAM, type = rw;
}
`;
    fs.writeFileSync(cfgFile, linkerConfig);

    // Assemble with ca65
    runCommand(`ca65 -o "${objFile}" "${asmFile}"`, "assembly (ca65)");
    console.log(`  ${baseName}.o`);

    // Link with ld65 to temp file
    const tmpBinFile = path.join(inputDir, baseName + ".bin");
    runCommand(`ld65 -C "${cfgFile}" -o "${tmpBinFile}" "${objFile}"`, "linking (ld65)");

    // Create PRG with load address header
    const startAddrNum = parseInt(startAddr, 16);
    const header = Buffer.from([startAddrNum & 0xff, (startAddrNum >> 8) & 0xff]);
    const binary = fs.readFileSync(tmpBinFile);
    fs.writeFileSync(prgFile, Buffer.concat([header, binary]));
    console.log(`  ${baseName}.prg`);

    // Clean up intermediate files
    fs.unlinkSync(objFile);
    fs.unlinkSync(cfgFile);
    fs.unlinkSync(tmpBinFile);

    console.log("Done!");

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
