// Data Memory Module
// 64-word data memory (256 bytes)

module data_memory (
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire [5:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);

    // Data memory array
    reg [31:0] memory [0:63];
    
    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
    end
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address] <= write_data;
        end
    end
    
    // Read operation (combinational)
    assign read_data = mem_read ? memory[address] : 32'h00000000;

endmodule