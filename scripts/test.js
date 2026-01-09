#!/usr/bin/env node
// Test script - compiles all .pas files in examples/ to .prg

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const examplesDir = path.join(__dirname, '..', 'examples');
const cliPath = path.join(__dirname, '..', 'dist', 'cli.js');

// Get all .pas files
const pasFiles = fs.readdirSync(examplesDir)
  .filter(f => f.endsWith('.pas'))
  .sort();

console.log(`\nCompiling ${pasFiles.length} test files...\n`);

let passed = 0;
let failed = 0;
const failures = [];

for (const file of pasFiles) {
  const filePath = path.join(examplesDir, file);
  process.stdout.write(`  ${file.padEnd(30)}`);

  try {
    execSync(`node "${cliPath}" "${filePath}"`, {
      stdio: 'pipe',
      cwd: examplesDir
    });
    console.log('OK');
    passed++;
  } catch (err) {
    console.log('FAILED');
    failed++;
    failures.push({
      file,
      error: err.stderr?.toString() || err.message
    });
  }
}

console.log(`\n${'─'.repeat(50)}`);
console.log(`Results: ${passed} passed, ${failed} failed`);

if (failures.length > 0) {
  console.log(`\nFailures:`);
  for (const f of failures) {
    console.log(`\n  ${f.file}:`);
    console.log(`    ${f.error.trim().split('\n').join('\n    ')}`);
  }
  process.exit(1);
}

console.log('\nAll tests passed!\n');
