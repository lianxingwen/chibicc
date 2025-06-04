# Sample Programs for Single-Cycle Processor

This document contains sample assembly programs that can be run on the single-cycle processor.

## Program 1: Basic Arithmetic

```assembly
# Calculate: result = (a + b) * (c - d)
# where a=5, b=3, c=10, d=2

addi $1, $0, 5      # a = 5
addi $2, $0, 3      # b = 3  
addi $3, $0, 10     # c = 10
addi $4, $0, 2      # d = 2

add  $5, $1, $2     # $5 = a + b = 8
sub  $6, $3, $4     # $6 = c - d = 8
# Note: MUL not implemented, so result would be 8 * 8 = 64
```

**Hex Encoding:**
```
memory[0] = 32'h20010005;  // addi $1, $0, 5
memory[1] = 32'h20020003;  // addi $2, $0, 3
memory[2] = 32'h2003000A;  // addi $3, $0, 10
memory[3] = 32'h20040002;  // addi $4, $0, 2
memory[4] = 32'h00222820;  // add $5, $1, $2
memory[5] = 32'h00643022;  // sub $6, $3, $4
```

## Program 2: Array Sum

```assembly
# Calculate sum of array elements
# Array: [10, 20, 30, 40]

addi $1, $0, 0      # sum = 0
addi $2, $0, 0      # base address = 0

# Store array elements in memory
addi $3, $0, 10     # element 1
sw   $3, 0($2)      # store at memory[0]
addi $3, $0, 20     # element 2  
sw   $3, 4($2)      # store at memory[1]
addi $3, $0, 30     # element 3
sw   $3, 8($2)      # store at memory[2]
addi $3, $0, 40     # element 4
sw   $3, 12($2)     # store at memory[3]

# Sum the elements
lw   $4, 0($2)      # load memory[0]
add  $1, $1, $4     # sum += element
lw   $4, 4($2)      # load memory[1]
add  $1, $1, $4     # sum += element
lw   $4, 8($2)      # load memory[2]
add  $1, $1, $4     # sum += element
lw   $4, 12($2)     # load memory[3]
add  $1, $1, $4     # sum += element
# Final sum in $1 = 100
```

## Program 3: Conditional Execution

```assembly
# Find maximum of two numbers
# a = 15, b = 25

addi $1, $0, 15     # a = 15
addi $2, $0, 25     # b = 25
slt  $3, $1, $2     # $3 = (a < b) ? 1 : 0

beq  $3, $0, else   # if a >= b, goto else
add  $4, $0, $2     # max = b
j    end            # goto end

else:
add  $4, $0, $1     # max = a

end:
# Maximum value is in $4
```

## Program 4: Simple Loop (Unrolled)

```assembly
# Calculate factorial of 4 (4! = 24)
# Since we don't have multiplication, we'll use repeated addition

addi $1, $0, 4      # n = 4
addi $2, $0, 1      # result = 1

# Multiply by 4: result = result * 4 = 1 * 4 = 4
add  $2, $2, $2     # result = 2
add  $2, $2, $2     # result = 4

# Multiply by 3: result = result * 3 = 4 * 3 = 12
add  $3, $2, $2     # temp = 8
add  $2, $2, $3     # result = 12

# Multiply by 2: result = result * 2 = 12 * 2 = 24
add  $2, $2, $2     # result = 24

# Result (24) is in $2
```

## How to Load a New Program

To load a new program into the processor:

1. **Convert assembly to hex** using the instruction decoder or manual encoding
2. **Edit `instruction_memory.v`** and replace the memory initialization
3. **Recompile and simulate**:
   ```bash
   make clean
   make simulate
   ```

### Example: Loading Program 1

Edit `instruction_memory.v` around line 22:

```verilog
// Replace the existing program with:
memory[0] = 32'h20010005;  // addi $1, $0, 5
memory[1] = 32'h20020003;  // addi $2, $0, 3
memory[2] = 32'h2003000A;  // addi $3, $0, 10
memory[3] = 32'h20040002;  // addi $4, $0, 2
memory[4] = 32'h00222820;  // add $5, $1, $2
memory[5] = 32'h00643022;  // sub $6, $3, $4
```

## Instruction Encoding Reference

### R-Type Instructions
Format: `[opcode:6][rs:5][rt:5][rd:5][shamt:5][funct:6]`

| Instruction | Opcode | Funct | Example | Hex |
|-------------|--------|-------|---------|-----|
| ADD | 000000 | 100000 | add $3,$1,$2 | 00221820 |
| SUB | 000000 | 100010 | sub $3,$1,$2 | 00221822 |
| AND | 000000 | 100100 | and $3,$1,$2 | 00221824 |
| OR  | 000000 | 100101 | or $3,$1,$2  | 00221825 |
| SLT | 000000 | 101010 | slt $3,$1,$2 | 0022182A |

### I-Type Instructions
Format: `[opcode:6][rs:5][rt:5][immediate:16]`

| Instruction | Opcode | Example | Hex |
|-------------|--------|---------|-----|
| ADDI | 001000 | addi $1,$0,10 | 2001000A |
| LW   | 100011 | lw $1,0($0)   | 8C010000 |
| SW   | 101011 | sw $1,0($0)   | AC010000 |
| BEQ  | 000100 | beq $1,$2,4   | 10220004 |

### J-Type Instructions
Format: `[opcode:6][address:26]`

| Instruction | Opcode | Example | Hex |
|-------------|--------|---------|-----|
| J | 000010 | j 100 | 08000064 |

## Limitations and Extensions

### Current Limitations:
- No multiplication/division instructions
- No shift instructions
- No floating-point support
- Limited branching (only BEQ)
- No function calls (JAL/JR)

### Possible Extensions:
1. **Add more instructions**: MUL, DIV, SLL, SRL, BNE, etc.
2. **Implement pipeline**: Convert to multi-cycle or pipelined processor
3. **Add cache**: Implement instruction and data caches
4. **Exception handling**: Add interrupt and exception support
5. **Floating-point unit**: Add FPU for floating-point operations