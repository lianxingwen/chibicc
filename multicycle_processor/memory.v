// 存储器模块（指令存储器和数据存储器）
module memory(
    input clk,                    // 时钟信号
    input mem_read,               // 读使能
    input mem_write,              // 写使能
    input [31:0] address,         // 地址
    input [31:0] write_data,      // 写数据
    output reg [31:0] read_data   // 读数据
);

    // 1024个32位存储单元（4KB存储器）
    reg [31:0] memory_array [1023:0];
    wire [9:0] mem_addr;
    
    // 地址映射（字地址）
    assign mem_addr = address[11:2];
    
    integer i;
    
    // 初始化存储器
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory_array[i] = 32'h00000000;
        end
        
        // Load test instructions (matching testbench expectations)
        // addi $1, $0, 5    # $1 = 5
        memory_array[0] = 32'h20010005;
        // addi $2, $0, 3    # $2 = 3
        memory_array[1] = 32'h20020003;
        // add $3, $1, $2    # $3 = $1 + $2 = 8
        memory_array[2] = 32'h00221820;
        // sub $4, $3, $2    # $4 = $3 - $2 = 5
        memory_array[3] = 32'h00622022;
        // beq $1, $2, 1     # if $1 == $2, jump 1 instruction (should not branch)
        memory_array[4] = 32'h10220001;
        // addi $5, $0, 10   # $5 = 10 (should be executed)
        memory_array[5] = 32'h2005000A;
        // addi $6, $0, 20   # $6 = 20 (should be executed)
        memory_array[6] = 32'h20060014;
        // j 8               # jump to address 32 (0x20)
        memory_array[7] = 32'h08000008;
        // addi $7, $0, 100  # $7 = 100 (at address 32)
        memory_array[8] = 32'h20070064;
    end

    // 读操作
    always @(*) begin
        if (mem_read) begin
            read_data = memory_array[mem_addr];
        end else begin
            read_data = 32'h00000000;
        end
    end

    // 写操作
    always @(posedge clk) begin
        if (mem_write) begin
            memory_array[mem_addr] <= write_data;
        end
    end

endmodule