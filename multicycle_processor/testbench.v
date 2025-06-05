// 多周期处理器测试平台
`timescale 1ns/1ps

module testbench;

    // 测试信号
    reg clk;
    reg reset;

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
        
        // 显示寄存器内容
        $display("=== 处理器执行结果 ===");
        $display("$1 = %d", cpu.dp.reg_file_inst.registers[1]);
        $display("$2 = %d", cpu.dp.reg_file_inst.registers[2]);
        $display("$3 = %d", cpu.dp.reg_file_inst.registers[3]);
        $display("$4 = %d", cpu.dp.reg_file_inst.registers[4]);
        $display("$5 = %d", cpu.dp.reg_file_inst.registers[5]);
        $display("$6 = %d", cpu.dp.reg_file_inst.registers[6]);
        $display("$7 = %d", cpu.dp.reg_file_inst.registers[7]);
        
        $display("=== 预期结果 ===");
        $display("$1 = 5 (addi $1, $1, 5)");
        $display("$2 = 3 (addi $2, $0, 3)");
        $display("$3 = 8 (add $3, $1, $2)");
        $display("$4 = 5 (sub $4, $3, $2)");
        $display("$5 = 0 (应该被跳过)");
        $display("$6 = 0 (应该被跳过)");
        $display("$7 = 100 (addi $7, $0, 100)");
        
        $finish;
    end

    // 监控重要信号
    initial begin
        $monitor("时间=%0t, PC=%h, 指令=%h, 状态=%b", 
                 $time, cpu.dp.pc, cpu.dp.instruction, cpu.ctrl_unit.state);
    end

    // 生成波形文件
    initial begin
        $dumpfile("multicycle_processor.vcd");
        $dumpvars(0, testbench);
    end

endmodule