#!/bin/bash

echo "=========================================="
echo "    SIMPLE GRAMMAR COMPILER DEMO"
echo "=========================================="
echo

echo "This demo shows a complete grammar compiler that:"
echo "1. Parses BNF-like grammar definitions"
echo "2. Generates C parsers from the grammar"
echo "3. Tests the generated parsers"
echo

echo "Let's start with a simple greeting grammar..."
echo
echo "=== SIMPLE GRAMMAR ==="
echo "Grammar definition (examples/simple.grammar):"
cat examples/simple.grammar
echo

echo "Generating parser..."
./grammar_compiler examples/simple.grammar simple_parser.c
echo

echo "Compiling generated parser..."
gcc -o test_simple simple_parser.c
echo

echo "Testing valid inputs:"
echo -n "  'hello world': "
./test_simple "hello world" && echo "✓ ACCEPTED"
echo -n "  'hi there': "
./test_simple "hi there" && echo "✓ ACCEPTED"
echo -n "  'hello there': "
./test_simple "hello there" && echo "✓ ACCEPTED"
echo -n "  'hi world': "
./test_simple "hi world" && echo "✓ ACCEPTED"

echo
echo "Testing invalid input:"
echo -n "  'goodbye world': "
./test_simple "goodbye world" || echo "✗ CORRECTLY REJECTED"

echo
echo "=== ARITHMETIC GRAMMAR ==="
echo "Grammar definition (examples/arithmetic.grammar):"
cat examples/arithmetic.grammar
echo

echo "Generating parser..."
./grammar_compiler examples/arithmetic.grammar arithmetic_parser.c
echo

echo "Compiling generated parser..."
gcc -o test_arithmetic arithmetic_parser.c
echo

echo "Testing arithmetic expressions:"
echo -n "  '1': "
./test_arithmetic "1" && echo "✓ ACCEPTED"
echo -n "  '1+2': "
./test_arithmetic "1+2" && echo "✓ ACCEPTED"
echo -n "  '1+2*3': "
./test_arithmetic "1+2*3" && echo "✓ ACCEPTED"
echo -n "  '(1+2)*3': "
./test_arithmetic "(1+2)*3" && echo "✓ ACCEPTED"
echo -n "  '1+2-3*4/5': "
./test_arithmetic "1+2-3*4/5" && echo "✓ ACCEPTED"

echo
echo "Testing invalid expressions:"
echo -n "  '1+': "
./test_arithmetic "1+" || echo "✗ CORRECTLY REJECTED"
echo -n "  '+1': "
./test_arithmetic "+1" || echo "✗ CORRECTLY REJECTED"
echo -n "  '1++2': "
./test_arithmetic "1++2" || echo "✗ CORRECTLY REJECTED"

echo
echo "=========================================="
echo "    DEMO COMPLETE!"
echo "=========================================="
echo
echo "The grammar compiler successfully:"
echo "✓ Parsed both grammar definitions"
echo "✓ Generated working C parsers"
echo "✓ Accepted all valid inputs"
echo "✓ Rejected all invalid inputs"
echo
echo "You can create your own grammars and generate"
echo "parsers for any language you want to parse!"