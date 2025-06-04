// Arithmetic Logic Unit (ALU)
// Supports basic arithmetic and logic operations

module alu (
    input wire [31:0] input1,
    input wire [31:0] input2,
    input wire [3:0] alu_control,
    output reg [31:0] result,
    output wire zero
);

    // ALU control codes
    parameter ALU_AND  = 4'b0000;
    parameter ALU_OR   = 4'b0001;
    parameter ALU_ADD  = 4'b0010;
    parameter ALU_SUB  = 4'b0110;
    parameter ALU_SLT  = 4'b0111;
    parameter ALU_NOR  = 4'b1100;
    
    always @(*) begin
        case (alu_control)
            ALU_AND:  result = input1 & input2;
            ALU_OR:   result = input1 | input2;
            ALU_ADD:  result = input1 + input2;
            ALU_SUB:  result = input1 - input2;
            ALU_SLT:  result = ($signed(input1) < $signed(input2)) ? 32'h00000001 : 32'h00000000;
            ALU_NOR:  result = ~(input1 | input2);
            default:  result = 32'h00000000;
        endcase
    end
    
    // Zero flag
    assign zero = (result == 32'h00000000);

endmodule