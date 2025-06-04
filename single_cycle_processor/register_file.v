// Register File Module
// 32 registers, each 32-bit wide
// 2 read ports, 1 write port

module register_file (
    input wire clk,
    input wire reg_write,
    input wire [4:0] read_register1,
    input wire [4:0] read_register2,
    input wire [4:0] write_register,
    input wire [31:0] write_data,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

    // Register array
    reg [31:0] registers [0:31];
    
    // Initialize registers
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'h00000000;
        end
    end
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (reg_write && write_register != 5'b00000) begin
            registers[write_register] <= write_data;
        end
    end
    
    // Read operations (combinational)
    // Register $0 is always 0
    assign read_data1 = (read_register1 == 5'b00000) ? 32'h00000000 : registers[read_register1];
    assign read_data2 = (read_register2 == 5'b00000) ? 32'h00000000 : registers[read_register2];

endmodule