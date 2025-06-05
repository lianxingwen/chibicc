// 数据通路模块
module datapath(
    input clk,                    // 时钟信号
    input reset,                  // 复位信号
    input pc_write,               // PC写使能
    input pc_write_cond,          // PC条件写使能
    input i_or_d,                 // 指令/数据存储器选择
    input mem_read,               // 存储器读使能
    input mem_write,              // 存储器写使能
    input mem_to_reg,             // 存储器到寄存器
    input ir_write,               // 指令寄存器写使能
    input [1:0] reg_dst,          // 寄存器目标选择
    input reg_write,              // 寄存器写使能
    input alu_src_a,              // ALU源A选择
    input [1:0] alu_src_b,        // ALU源B选择
    input [3:0] alu_control,      // ALU控制信号
    input [1:0] pc_source,        // PC源选择
    output [5:0] opcode,          // 指令操作码
    output [5:0] funct,           // 功能码
    output zero                   // ALU零标志位
);

    // 内部信号
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] mem_data;
    wire [31:0] reg_data1, reg_data2;
    wire [31:0] alu_a, alu_result;
    wire [31:0] sign_extend;
    wire [31:0] shift_left_2;
    wire [31:0] branch_addr;
    wire [31:0] jump_addr;
    wire [31:0] write_data;
    wire pc_enable;

    // 寄存器
    reg [31:0] pc_reg;
    reg [31:0] instruction_reg;
    reg [31:0] mdr; // 存储器数据寄存器
    reg [31:0] a_reg, b_reg; // ALU操作数寄存器
    reg [31:0] alu_out; // ALU输出寄存器

    // PC寄存器
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_reg <= 32'h00000000;
        else if (pc_enable)
            pc_reg <= pc_next;
    end

    assign pc = pc_reg;
    assign pc_enable = pc_write | (pc_write_cond & zero);

    // 指令寄存器
    always @(posedge clk) begin
        if (ir_write)
            instruction_reg <= mem_data;
    end

    assign instruction = instruction_reg;
    assign opcode = instruction[31:26];
    assign funct = instruction[5:0];

    // 存储器数据寄存器
    always @(posedge clk) begin
        mdr <= mem_data;
    end

    // ALU操作数寄存器
    always @(posedge clk) begin
        a_reg <= reg_data1;
        b_reg <= reg_data2;
    end

    // ALU输出寄存器
    always @(posedge clk) begin
        alu_out <= alu_result;
    end

    // 符号扩展
    assign sign_extend = {{16{instruction[15]}}, instruction[15:0]};

    // 左移2位（分支地址计算）
    assign shift_left_2 = {sign_extend[29:0], 2'b00};

    // 分支地址计算
    assign branch_addr = pc + shift_left_2;

    // 跳转地址计算
    assign jump_addr = {pc[31:28], instruction[25:0], 2'b00};

    // 多路选择器
    // 存储器地址选择
    wire [31:0] mem_addr;
    assign mem_addr = i_or_d ? alu_out : pc;

    // ALU源A选择
    assign alu_a = alu_src_a ? a_reg : pc;

    // ALU源B选择
    reg [31:0] alu_b;
    always @(*) begin
        case (alu_src_b)
            2'b00: alu_b = b_reg;
            2'b01: alu_b = 32'h00000004; // PC+4
            2'b10: alu_b = sign_extend;
            2'b11: alu_b = shift_left_2;
            default: alu_b = 32'h00000000;
        endcase
    end

    // 寄存器目标选择
    reg [4:0] write_reg;
    always @(*) begin
        case (reg_dst)
            2'b00: write_reg = instruction[20:16]; // rt
            2'b01: write_reg = instruction[15:11]; // rd
            2'b10: write_reg = 5'b11111; // $ra
            default: write_reg = 5'b00000;
        endcase
    end

    // 写数据选择
    assign write_data = mem_to_reg ? mdr : alu_out;

    // PC下一值选择
    reg [31:0] pc_next;
    always @(*) begin
        case (pc_source)
            2'b00: pc_next = alu_result; // PC+4
            2'b01: pc_next = alu_out;    // 分支地址
            2'b10: pc_next = jump_addr;  // 跳转地址
            default: pc_next = 32'h00000000;
        endcase
    end

    // 实例化模块
    memory mem_inst(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(mem_addr),
        .write_data(b_reg),
        .read_data(mem_data)
    );

    register_file reg_file_inst(
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(instruction[25:21]),
        .read_reg2(instruction[20:16]),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    alu alu_inst(
        .a(alu_a),
        .b(alu_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

endmodule