# Single-Cycle Processor in Verilog

This project implements a complete single-cycle RISC processor in Verilog. The processor supports a subset of MIPS instructions and demonstrates fundamental computer architecture concepts.

## Architecture Overview

The processor implements a classic single-cycle datapath with the following components:

### Core Components

1. **Program Counter (PC)** - 32-bit register pointing to current instruction
2. **Instruction Memory** - 64-word ROM containing the program
3. **Register File** - 32 general-purpose 32-bit registers
4. **ALU** - Arithmetic Logic Unit supporting basic operations
5. **Data Memory** - 64-word RAM for load/store operations
6. **Control Unit** - Generates control signals based on instruction opcode

### Supported Instructions

#### R-Type Instructions
- `ADD rd, rs, rt` - Add registers
- `SUB rd, rs, rt` - Subtract registers  
- `AND rd, rs, rt` - Bitwise AND
- `OR rd, rs, rt` - Bitwise OR
- `SLT rd, rs, rt` - Set less than

#### I-Type Instructions
- `ADDI rt, rs, imm` - Add immediate
- `LW rt, offset(rs)` - Load word from memory
- `SW rt, offset(rs)` - Store word to memory
- `BEQ rs, rt, offset` - Branch if equal

#### J-Type Instructions
- `J target` - Unconditional jump

## File Structure

```
single_cycle_processor/
├── single_cycle_processor.v    # Top-level processor module
├── instruction_memory.v        # Instruction memory (ROM)
├── register_file.v            # 32-register file
├── alu.v                      # Arithmetic Logic Unit
├── data_memory.v              # Data memory (RAM)
├── control_unit.v             # Control unit and ALU control
├── testbench.v                # Comprehensive testbench
├── Makefile                   # Build automation
└── README.md                  # This file
```

## Getting Started

### Prerequisites

Install the required tools:
```bash
make install-deps
```

Or manually install:
- **iverilog** - Icarus Verilog simulator
- **gtkwave** - Waveform viewer (optional)

### Running the Simulation

1. **Compile and simulate:**
   ```bash
   make simulate
   ```

2. **View waveforms (optional):**
   ```bash
   make wave
   ```

3. **Clean generated files:**
   ```bash
   make clean
   ```

## Test Program

The processor comes with a pre-loaded test program that demonstrates all supported instructions:

```assembly
# Test program demonstrating processor capabilities

addi $1, $0, 10      # $1 = 10
addi $2, $0, 20      # $2 = 20
add  $3, $1, $2      # $3 = $1 + $2 = 30
sub  $4, $2, $1      # $4 = $2 - $1 = 10
and  $5, $1, $2      # $5 = $1 & $2 = 0
or   $6, $1, $2      # $6 = $1 | $2 = 30
slt  $7, $1, $2      # $7 = ($1 < $2) ? 1 : 0 = 1
sw   $3, 0($0)       # Store $3 to memory[0]
lw   $8, 0($0)       # Load from memory[0] to $8
beq  $1, $1, 2       # Branch (skip next 2 instructions)
addi $9, $0, 99      # Skipped
addi $10, $0, 88     # Skipped
addi $11, $0, 77     # Executed
j    15              # Jump to instruction 15
addi $12, $0, 66     # Skipped
addi $13, $0, 55     # Jump target
```

## Expected Results

After simulation, the registers should contain:
- `$1 = 10` (0x0000000A)
- `$2 = 20` (0x00000014)
- `$3 = 30` (0x0000001E)
- `$4 = 10` (0x0000000A)
- `$5 = 0` (0x00000000)
- `$6 = 30` (0x0000001E)
- `$7 = 1` (0x00000001)
- `$8 = 30` (0x0000001E)
- `$11 = 77` (0x0000004D)
- `$13 = 55` (0x00000037)

Memory location 0 should contain 30 (0x0000001E).

## Design Details

### Instruction Format

The processor uses standard MIPS instruction formats:

**R-Type:** `[opcode:6][rs:5][rt:5][rd:5][shamt:5][funct:6]`
**I-Type:** `[opcode:6][rs:5][rt:5][immediate:16]`
**J-Type:** `[opcode:6][address:26]`

### Control Signals

| Signal | Description |
|--------|-------------|
| RegDst | Register destination selection |
| Jump | Jump control |
| Branch | Branch control |
| MemRead | Memory read enable |
| MemToReg | Memory to register selection |
| ALUOp | ALU operation type |
| MemWrite | Memory write enable |
| ALUSrc | ALU source selection |
| RegWrite | Register write enable |

### ALU Operations

| ALU Control | Operation |
|-------------|-----------|
| 0000 | AND |
| 0001 | OR |
| 0010 | ADD |
| 0110 | SUB |
| 0111 | SLT |

## Customization

### Adding New Instructions

1. **Update instruction memory** with new opcodes
2. **Extend control unit** to handle new opcodes
3. **Modify ALU** if new operations are needed
4. **Update testbench** to verify new functionality

### Modifying Memory Size

Change the address width in:
- `instruction_memory.v` - Line 6: `input wire [5:0] address`
- `data_memory.v` - Line 7: `input wire [5:0] address`
- `single_cycle_processor.v` - Lines 47, 78: `pc[7:2]`, `alu_result[7:2]`

## Limitations

- **Single-cycle design** - All instructions take one clock cycle
- **Harvard architecture** - Separate instruction and data memory
- **Limited instruction set** - Subset of MIPS instructions
- **No pipeline** - Instructions execute sequentially
- **No cache** - Direct memory access only

## Educational Value

This processor demonstrates:
- **Datapath design** - How instructions flow through the processor
- **Control unit design** - How opcodes generate control signals
- **Memory hierarchy** - Instruction and data memory organization
- **ALU design** - Arithmetic and logic operations
- **Register file design** - Multi-port register storage

## Future Enhancements

Possible improvements include:
- **Pipeline implementation** - Multi-stage instruction execution
- **Cache memory** - Faster memory access
- **Floating-point unit** - Support for floating-point operations
- **Exception handling** - Interrupt and exception support
- **Branch prediction** - Improved branch performance

## License

This project is provided for educational purposes. Feel free to modify and extend for learning and research.