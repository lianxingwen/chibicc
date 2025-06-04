// Testbench for Single-Cycle Processor

`timescale 1ns / 1ps

module testbench;

    // Testbench signals
    reg clk;
    reg reset;
    
    // Instantiate the processor
    single_cycle_processor cpu (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period (100MHz)
    end
    
    // Test sequence
    initial begin
        // Initialize
        $display("Starting Single-Cycle Processor Test");
        $display("=====================================");
        
        // Reset the processor
        reset = 1;
        #15;
        reset = 0;
        
        // Monitor key signals
        $monitor("Time: %0t | PC: %h | Instruction: %h | RegWrite: %b | WriteReg: %d | WriteData: %h", 
                 $time, cpu.pc, cpu.instruction, cpu.reg_write, cpu.write_register, cpu.write_data);
        
        // Run for several clock cycles
        #200;
        
        // Display register contents
        $display("\nRegister File Contents:");
        $display("=======================");
        $display("$0  = %h", cpu.regfile.registers[0]);
        $display("$1  = %h", cpu.regfile.registers[1]);
        $display("$2  = %h", cpu.regfile.registers[2]);
        $display("$3  = %h", cpu.regfile.registers[3]);
        $display("$4  = %h", cpu.regfile.registers[4]);
        $display("$5  = %h", cpu.regfile.registers[5]);
        $display("$6  = %h", cpu.regfile.registers[6]);
        $display("$7  = %h", cpu.regfile.registers[7]);
        $display("$8  = %h", cpu.regfile.registers[8]);
        $display("$9  = %h", cpu.regfile.registers[9]);
        $display("$10 = %h", cpu.regfile.registers[10]);
        $display("$11 = %h", cpu.regfile.registers[11]);
        $display("$12 = %h", cpu.regfile.registers[12]);
        $display("$13 = %h", cpu.regfile.registers[13]);
        
        // Display data memory contents
        $display("\nData Memory Contents:");
        $display("=====================");
        $display("Memory[0] = %h", cpu.dmem.memory[0]);
        $display("Memory[1] = %h", cpu.dmem.memory[1]);
        $display("Memory[2] = %h", cpu.dmem.memory[2]);
        $display("Memory[3] = %h", cpu.dmem.memory[3]);
        
        // Verify expected results
        $display("\nVerification:");
        $display("=============");
        
        if (cpu.regfile.registers[1] == 32'h0000000A)
            $display("✓ $1 = 10 (ADDI test passed)");
        else
            $display("✗ $1 = %h, expected 10", cpu.regfile.registers[1]);
            
        if (cpu.regfile.registers[2] == 32'h00000014)
            $display("✓ $2 = 20 (ADDI test passed)");
        else
            $display("✗ $2 = %h, expected 20", cpu.regfile.registers[2]);
            
        if (cpu.regfile.registers[3] == 32'h0000001E)
            $display("✓ $3 = 30 (ADD test passed)");
        else
            $display("✗ $3 = %h, expected 30", cpu.regfile.registers[3]);
            
        if (cpu.regfile.registers[4] == 32'h0000000A)
            $display("✓ $4 = 10 (SUB test passed)");
        else
            $display("✗ $4 = %h, expected 10", cpu.regfile.registers[4]);
            
        if (cpu.regfile.registers[5] == 32'h00000000)
            $display("✓ $5 = 0 (AND test passed)");
        else
            $display("✗ $5 = %h, expected 0", cpu.regfile.registers[5]);
            
        if (cpu.regfile.registers[6] == 32'h0000001E)
            $display("✓ $6 = 30 (OR test passed)");
        else
            $display("✗ $6 = %h, expected 30", cpu.regfile.registers[6]);
            
        if (cpu.regfile.registers[7] == 32'h00000001)
            $display("✓ $7 = 1 (SLT test passed)");
        else
            $display("✗ $7 = %h, expected 1", cpu.regfile.registers[7]);
            
        if (cpu.regfile.registers[8] == 32'h0000001E)
            $display("✓ $8 = 30 (LW test passed)");
        else
            $display("✗ $8 = %h, expected 30", cpu.regfile.registers[8]);
            
        if (cpu.dmem.memory[0] == 32'h0000001E)
            $display("✓ Memory[0] = 30 (SW test passed)");
        else
            $display("✗ Memory[0] = %h, expected 30", cpu.dmem.memory[0]);
            
        if (cpu.regfile.registers[11] == 32'h0000004D)
            $display("✓ $11 = 77 (Branch test passed)");
        else
            $display("✗ $11 = %h, expected 77", cpu.regfile.registers[11]);
            
        if (cpu.regfile.registers[13] == 32'h00000037)
            $display("✓ $13 = 55 (Jump test passed)");
        else
            $display("✗ $13 = %h, expected 55", cpu.regfile.registers[13]);
        
        $display("\nTest completed!");
        $finish;
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("processor_waveform.vcd");
        $dumpvars(0, testbench);
    end

endmodule