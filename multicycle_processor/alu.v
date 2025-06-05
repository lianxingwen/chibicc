// ALU模块 - 算术逻辑单元
module alu(
    input [31:0] a,          // 操作数A
    input [31:0] b,          // 操作数B
    input [3:0] alu_control, // ALU控制信号
    output reg [31:0] result,// ALU结果
    output zero              // 零标志位
);

    // ALU控制信号定义
    parameter ALU_AND  = 4'b0000;
    parameter ALU_OR   = 4'b0001;
    parameter ALU_ADD  = 4'b0010;
    parameter ALU_SUB  = 4'b0110;
    parameter ALU_SLT  = 4'b0111;
    parameter ALU_NOR  = 4'b1100;

    always @(*) begin
        case (alu_control)
            ALU_AND:  result = a & b;
            ALU_OR:   result = a | b;
            ALU_ADD:  result = a + b;
            ALU_SUB:  result = a - b;
            ALU_SLT:  result = (a < b) ? 32'h00000001 : 32'h00000000;
            ALU_NOR:  result = ~(a | b);
            default:  result = 32'h00000000;
        endcase
    end

    assign zero = (result == 32'h00000000);

endmodule