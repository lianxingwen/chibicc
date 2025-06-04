// Single-Cycle Processor Top Module
// Supports R-type, I-type, and basic branch/jump instructions

module single_cycle_processor (
    input wire clk,
    input wire reset
);

    // Internal signals
    reg [31:0] pc;
    wire [31:0] pc_next, pc_plus4, pc_branch, pc_jump;
    wire [31:0] instruction;
    wire [31:0] read_data1, read_data2, write_data;
    wire [31:0] sign_extend;
    wire [31:0] alu_result, alu_input2;
    wire [31:0] mem_read_data;
    wire [4:0] write_register;
    
    // Control signals
    wire reg_dst, jump, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write;
    wire [1:0] alu_op;
    wire [3:0] alu_control;
    wire zero_flag;
    wire pc_src;
    
    // Instruction fields
    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs = instruction[25:21];
    wire [4:0] rt = instruction[20:16];
    wire [4:0] rd = instruction[15:11];
    wire [5:0] funct = instruction[5:0];
    wire [15:0] immediate = instruction[15:0];
    wire [25:0] jump_address = instruction[25:0];
    
    // Program Counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h00000000;
        else
            pc <= pc_next;
    end
    
    // PC calculation
    assign pc_plus4 = pc + 4;
    assign pc_branch = pc_plus4 + (sign_extend << 2);
    assign pc_jump = {pc_plus4[31:28], jump_address, 2'b00};
    assign pc_src = branch & zero_flag;
    assign pc_next = jump ? pc_jump : (pc_src ? pc_branch : pc_plus4);
    
    // Sign extension
    assign sign_extend = {{16{immediate[15]}}, immediate};
    
    // Register destination selection
    assign write_register = reg_dst ? rd : rt;
    
    // ALU input selection
    assign alu_input2 = alu_src ? sign_extend : read_data2;
    
    // Write data selection
    assign write_data = mem_to_reg ? mem_read_data : alu_result;
    
    // Instantiate modules
    instruction_memory imem (
        .address(pc[7:2]),  // Word-aligned addressing
        .instruction(instruction)
    );
    
    register_file regfile (
        .clk(clk),
        .reg_write(reg_write),
        .read_register1(rs),
        .read_register2(rt),
        .write_register(write_register),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    alu main_alu (
        .input1(read_data1),
        .input2(alu_input2),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero_flag)
    );
    
    data_memory dmem (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(alu_result[7:2]),  // Word-aligned addressing
        .write_data(read_data2),
        .read_data(mem_read_data)
    );
    
    control_unit control (
        .opcode(opcode),
        .reg_dst(reg_dst),
        .jump(jump),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );
    
    alu_control alu_ctrl (
        .alu_op(alu_op),
        .funct(funct),
        .alu_control(alu_control)
    );

endmodule