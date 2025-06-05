// 多周期处理器顶层模块
module multicycle_processor(
    input clk,                    // 时钟信号
    input reset                   // 复位信号
);

    // 控制信号
    wire pc_write, pc_write_cond, i_or_d, mem_read, mem_write;
    wire mem_to_reg, ir_write, reg_write, alu_src_a;
    wire [1:0] reg_dst, alu_src_b, pc_source;
    wire [3:0] alu_control;
    wire [5:0] opcode, funct;
    wire zero;

    // 实例化控制单元
    control_unit ctrl_unit(
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .funct(funct),
        .zero(zero),
        .pc_write(pc_write),
        .pc_write_cond(pc_write_cond),
        .i_or_d(i_or_d),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .ir_write(ir_write),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .alu_control(alu_control),
        .pc_source(pc_source)
    );

    // 实例化数据通路
    datapath dp(
        .clk(clk),
        .reset(reset),
        .pc_write(pc_write),
        .pc_write_cond(pc_write_cond),
        .i_or_d(i_or_d),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .ir_write(ir_write),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .alu_control(alu_control),
        .pc_source(pc_source),
        .opcode(opcode),
        .funct(funct),
        .zero(zero)
    );

endmodule