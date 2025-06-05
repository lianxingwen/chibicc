// 寄存器文件模块
module register_file(
    input clk,                    // 时钟信号
    input reset,                  // 复位信号
    input reg_write,              // 写使能信号
    input [4:0] read_reg1,        // 读寄存器1地址
    input [4:0] read_reg2,        // 读寄存器2地址
    input [4:0] write_reg,        // 写寄存器地址
    input [31:0] write_data,      // 写数据
    output [31:0] read_data1,     // 读数据1
    output [31:0] read_data2      // 读数据2
);

    // 32个32位寄存器
    reg [31:0] registers [31:0];
    integer i;

    // 初始化寄存器
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (reg_write && write_reg != 5'b00000) begin
            // $0寄存器始终为0，不能写入
            registers[write_reg] <= write_data;
        end
    end

    // 读操作（组合逻辑）
    assign read_data1 = (read_reg1 == 5'b00000) ? 32'h00000000 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'b00000) ? 32'h00000000 : registers[read_reg2];

endmodule