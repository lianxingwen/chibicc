// Instruction Memory Module
// 64-word instruction memory (256 bytes)

module instruction_memory (
    input wire [5:0] address,
    output wire [31:0] instruction
);

    // Instruction memory array
    reg [31:0] memory [0:63];
    
    // Initialize with a simple test program
    integer i;
    initial begin
        // Initialize all memory to NOP (add $0, $0, $0)
        for (i = 0; i < 64; i = i + 1) begin
            memory[i] = 32'h00000020;  // NOP
        end
        
        // Sample program:
        // addi $1, $0, 10      # $1 = 10
        memory[0] = 32'h2001000A;
        
        // addi $2, $0, 20      # $2 = 20
        memory[1] = 32'h20020014;
        
        // add $3, $1, $2       # $3 = $1 + $2 = 30
        memory[2] = 32'h00221820;
        
        // sub $4, $2, $1       # $4 = $2 - $1 = 10
        memory[3] = 32'h00412022;
        
        // and $5, $1, $2       # $5 = $1 & $2
        memory[4] = 32'h00222824;
        
        // or $6, $1, $2        # $6 = $1 | $2
        memory[5] = 32'h00223025;
        
        // slt $7, $1, $2       # $7 = ($1 < $2) ? 1 : 0
        memory[6] = 32'h0022382A;
        
        // sw $3, 0($0)         # Store $3 to memory[0]
        memory[7] = 32'hAC030000;
        
        // lw $8, 0($0)         # Load from memory[0] to $8
        memory[8] = 32'h8C080000;
        
        // beq $1, $1, 2        # Branch if $1 == $1 (always true), skip 2 instructions
        memory[9] = 32'h10210002;
        
        // addi $9, $0, 99      # This should be skipped
        memory[10] = 32'h20090063;
        
        // addi $10, $0, 88     # This should be skipped
        memory[11] = 32'h200A0058;
        
        // addi $11, $0, 77     # This should execute
        memory[12] = 32'h200B004D;
        
        // j 15                 # Jump to address 15
        memory[13] = 32'h0800000F;
        
        // addi $12, $0, 66     # This should be skipped
        memory[14] = 32'h200C0042;
        
        // addi $13, $0, 55     # Jump target
        memory[15] = 32'h200D0037;
    end
    
    // Combinational read
    assign instruction = memory[address];

endmodule