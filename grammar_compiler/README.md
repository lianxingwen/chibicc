# Simple Grammar Compiler

A complete grammar compiler that generates recursive descent parsers from BNF-like grammar definitions.

## Features

- Lexical analysis with support for identifiers, strings, and operators
- Recursive descent parser for grammar definitions
- AST generation for grammar rules
- C code generation for parsers
- Support for:
  - Terminal symbols (strings)
  - Non-terminal symbols (identifiers)
  - Choice (|)
  - Sequence (concatenation)
  - Optional elements (?)
  - Zero or more repetition (*)
  - One or more repetition (+)
  - Grouping with parentheses

## Grammar Syntax

The grammar compiler accepts BNF-like syntax:

```
rule_name: production;
```

Where `production` can contain:
- `"terminal"` - literal strings
- `nonterminal` - references to other rules
- `a | b` - choice between alternatives
- `a b` - sequence of elements
- `a?` - optional element
- `a*` - zero or more repetitions
- `a+` - one or more repetitions
- `(a b)` - grouping

## Usage

```bash
# Compile the grammar compiler
make

# Generate a parser from a grammar file
./grammar_compiler examples/arithmetic.grammar arithmetic_parser.c

# Compile the generated parser
gcc arithmetic_parser.c -o test_arithmetic

# Test the parser
./test_arithmetic "2+3*4"
```

## Examples

### Simple Grammar (`examples/simple.grammar`)
```
start: greeting name;
greeting: "hello" | "hi";
name: "world" | "there";
```

This accepts inputs like:
- "hello world"
- "hi there"
- "hello there"
- "hi world"

### Arithmetic Grammar (`examples/arithmetic.grammar`)
```
expr: term (("+" | "-") term)*;
term: factor (("*" | "/") factor)*;
factor: number | "(" expr ")";
number: "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9";
```

This accepts arithmetic expressions like:
- "1+2*3"
- "(1+2)*3"
- "1+2-3*4/5"

## Building

```bash
make
```

## Testing

### Quick Test
```bash
# Test simple grammar
./grammar_compiler examples/simple.grammar simple_parser.c
gcc -o test_simple simple_parser.c
./test_simple "hello world"

# Test arithmetic grammar
./grammar_compiler examples/arithmetic.grammar arithmetic_parser.c
gcc -o test_arithmetic arithmetic_parser.c
./test_arithmetic "1+2*3"
```

### Comprehensive Test Suite
```bash
./test_all.sh
```

This runs all test cases for both grammars and verifies that valid inputs are accepted and invalid inputs are properly rejected.

## Architecture

- `lexer.h/c` - Tokenizer for grammar definitions
- `parser.h/c` - Parser for grammar definitions
- `ast.h/c` - Abstract syntax tree representation
- `codegen.h/c` - C code generator for parsers
- `main.c` - Main program
- `examples/` - Example grammar files
- `test_all.sh` - Comprehensive test suite

## Status

✅ **COMPLETE**: The grammar compiler is fully functional and supports:
- Simple choice and sequence grammars
- Complex arithmetic expressions with operator precedence
- Repetition patterns (*, +)
- Proper error handling and rejection of invalid input
- All test cases pass successfully