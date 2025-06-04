// Control Unit Module
// Generates control signals based on instruction opcode

module control_unit (
    input wire [5:0] opcode,
    output reg reg_dst,
    output reg jump,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write
);

    // Instruction opcodes
    parameter R_TYPE = 6'b000000;  // R-type instructions
    parameter LW     = 6'b100011;  // Load word
    parameter SW     = 6'b101011;  // Store word
    parameter BEQ    = 6'b000100;  // Branch equal
    parameter ADDI   = 6'b001000;  // Add immediate
    parameter J      = 6'b000010;  // Jump
    
    always @(*) begin
        // Default values
        reg_dst = 1'b0;
        jump = 1'b0;
        branch = 1'b0;
        mem_read = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 2'b00;
        mem_write = 1'b0;
        alu_src = 1'b0;
        reg_write = 1'b0;
        
        case (opcode)
            R_TYPE: begin
                reg_dst = 1'b1;
                reg_write = 1'b1;
                alu_op = 2'b10;
            end
            
            LW: begin
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_op = 2'b00;
            end
            
            SW: begin
                alu_src = 1'b1;
                mem_write = 1'b1;
                alu_op = 2'b00;
            end
            
            BEQ: begin
                branch = 1'b1;
                alu_op = 2'b01;
            end
            
            ADDI: begin
                alu_src = 1'b1;
                reg_write = 1'b1;
                alu_op = 2'b00;
            end
            
            J: begin
                jump = 1'b1;
            end
            
            default: begin
                // NOP - do nothing
            end
        endcase
    end

endmodule

// ALU Control Unit
// Generates ALU control signals based on ALU operation and function field

module alu_control (
    input wire [1:0] alu_op,
    input wire [5:0] funct,
    output reg [3:0] alu_control
);

    // Function codes for R-type instructions
    parameter FUNCT_ADD = 6'b100000;
    parameter FUNCT_SUB = 6'b100010;
    parameter FUNCT_AND = 6'b100100;
    parameter FUNCT_OR  = 6'b100101;
    parameter FUNCT_SLT = 6'b101010;
    
    // ALU control codes
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;
    parameter ALU_SLT = 4'b0111;
    
    always @(*) begin
        case (alu_op)
            2'b00: alu_control = ALU_ADD;  // LW, SW, ADDI
            2'b01: alu_control = ALU_SUB;  // BEQ
            2'b10: begin  // R-type
                case (funct)
                    FUNCT_ADD: alu_control = ALU_ADD;
                    FUNCT_SUB: alu_control = ALU_SUB;
                    FUNCT_AND: alu_control = ALU_AND;
                    FUNCT_OR:  alu_control = ALU_OR;
                    FUNCT_SLT: alu_control = ALU_SLT;
                    default:   alu_control = ALU_ADD;
                endcase
            end
            default: alu_control = ALU_ADD;
        endcase
    end

endmodule