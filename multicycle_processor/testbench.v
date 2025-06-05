// 多周期处理器测试平台
`timescale 1ns/1ps

module testbench;

    // 测试信号
    reg clk;
    reg reset;
    
    // 用于波形显示的wire信号
    wire clk_wire = clk;
    wire reset_wire = reset;
    
    // 处理器内部信号的wire连接（便于波形查看）
    wire [31:0] pc_wire = cpu.dp.pc;
    wire [31:0] instruction_wire = cpu.dp.instruction;
    wire [3:0] state_wire = cpu.ctrl_unit.state;
    wire [31:0] reg1_wire = cpu.dp.reg_file_inst.registers[1];
    wire [31:0] reg2_wire = cpu.dp.reg_file_inst.registers[2];
    wire [31:0] reg3_wire = cpu.dp.reg_file_inst.registers[3];
    wire [31:0] reg4_wire = cpu.dp.reg_file_inst.registers[4];
    wire [31:0] reg7_wire = cpu.dp.reg_file_inst.registers[7];

    // 实例化处理器
    multicycle_processor cpu(
        .clk(clk),
        .reset(reset)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns周期，100MHz时钟
    end

    // 测试序列
    initial begin
        // 初始化
        reset = 1;
        #20;
        reset = 0;
        
        // 运行足够的时钟周期来执行测试程序
        #1000;
        
        // Display register contents
        $display("=== Processor Execution Results ===");
        $display("$1 = %d", cpu.dp.reg_file_inst.registers[1]);
        $display("$2 = %d", cpu.dp.reg_file_inst.registers[2]);
        $display("$3 = %d", cpu.dp.reg_file_inst.registers[3]);
        $display("$4 = %d", cpu.dp.reg_file_inst.registers[4]);
        $display("$5 = %d", cpu.dp.reg_file_inst.registers[5]);
        $display("$6 = %d", cpu.dp.reg_file_inst.registers[6]);
        $display("$7 = %d", cpu.dp.reg_file_inst.registers[7]);
        
        $display("=== Expected Results ===");
        $display("$1 = 5 (addi $1, $0, 5)");
        $display("$2 = 3 (addi $2, $0, 3)");
        $display("$3 = 8 (add $3, $1, $2)");
        $display("$4 = 5 (sub $4, $3, $2)");
        $display("$5 = 10 (addi $5, $0, 10)");
        $display("$6 = 20 (addi $6, $0, 20)");
        $display("$7 = 100 (addi $7, $0, 100)");
        
        $finish;
    end

    // Monitor important signals
    initial begin
        $monitor("Time=%0t, PC=%h, Instruction=%h, State=%b", 
                 $time, cpu.dp.pc, cpu.dp.instruction, cpu.ctrl_unit.state);
    end

    // 生成波形文件
    initial begin
        $dumpfile("multicycle_processor.vcd");
        $dumpvars(0, testbench);  // 导出整个testbench层次结构
    end

endmodule