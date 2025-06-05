// 控制单元模块
module control_unit(
    input clk,                    // 时钟信号
    input reset,                  // 复位信号
    input [5:0] opcode,           // 指令操作码
    input [5:0] funct,            // 功能码（R型指令）
    input zero,                   // ALU零标志位
    output reg pc_write,          // PC写使能
    output reg pc_write_cond,     // PC条件写使能
    output reg i_or_d,            // 指令/数据存储器选择
    output reg mem_read,          // 存储器读使能
    output reg mem_write,         // 存储器写使能
    output reg mem_to_reg,        // 存储器到寄存器
    output reg ir_write,          // 指令寄存器写使能
    output reg [1:0] reg_dst,     // 寄存器目标选择
    output reg reg_write,         // 寄存器写使能
    output reg alu_src_a,         // ALU源A选择
    output reg [1:0] alu_src_b,   // ALU源B选择
    output reg [3:0] alu_control, // ALU控制信号
    output reg [1:0] pc_source    // PC源选择
);

    // 状态定义
    parameter FETCH     = 4'b0000;
    parameter DECODE    = 4'b0001;
    parameter MEMADR    = 4'b0010;
    parameter MEMREAD   = 4'b0011;
    parameter MEMWB     = 4'b0100;
    parameter MEMWRITE  = 4'b0101;
    parameter EXECUTE   = 4'b0110;
    parameter ALUWRITEBACK = 4'b0111;
    parameter BRANCH    = 4'b1000;
    parameter ADDIEXECUTE = 4'b1001;
    parameter ADDIWRITEBACK = 4'b1010;
    parameter JUMP      = 4'b1011;

    // 指令操作码定义
    parameter R_TYPE = 6'b000000;
    parameter LW     = 6'b100011;
    parameter SW     = 6'b101011;
    parameter BEQ    = 6'b000100;
    parameter ADDI   = 6'b001000;
    parameter J      = 6'b000010;

    // ALU功能码定义
    parameter ADD_FUNCT = 6'b100000;
    parameter SUB_FUNCT = 6'b100010;
    parameter AND_FUNCT = 6'b100100;
    parameter OR_FUNCT  = 6'b100101;
    parameter SLT_FUNCT = 6'b101010;

    reg [3:0] state, next_state;

    // 状态寄存器
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= FETCH;
        else
            state <= next_state;
    end

    // 下一状态逻辑
    always @(*) begin
        case (state)
            FETCH: next_state = DECODE;
            DECODE: begin
                case (opcode)
                    LW, SW: next_state = MEMADR;
                    R_TYPE: next_state = EXECUTE;
                    BEQ: next_state = BRANCH;
                    ADDI: next_state = ADDIEXECUTE;
                    J: next_state = JUMP;
                    default: next_state = FETCH;
                endcase
            end
            MEMADR: begin
                if (opcode == LW)
                    next_state = MEMREAD;
                else
                    next_state = MEMWRITE;
            end
            MEMREAD: next_state = MEMWB;
            MEMWB: next_state = FETCH;
            MEMWRITE: next_state = FETCH;
            EXECUTE: next_state = ALUWRITEBACK;
            ALUWRITEBACK: next_state = FETCH;
            BRANCH: next_state = FETCH;
            ADDIEXECUTE: next_state = ADDIWRITEBACK;
            ADDIWRITEBACK: next_state = FETCH;
            JUMP: next_state = FETCH;
            default: next_state = FETCH;
        endcase
    end

    // 控制信号生成
    always @(*) begin
        // 默认值
        pc_write = 0;
        pc_write_cond = 0;
        i_or_d = 0;
        mem_read = 0;
        mem_write = 0;
        mem_to_reg = 0;
        ir_write = 0;
        reg_dst = 2'b00;
        reg_write = 0;
        alu_src_a = 0;
        alu_src_b = 2'b00;
        alu_control = 4'b0010; // ADD
        pc_source = 2'b00;

        case (state)
            FETCH: begin
                mem_read = 1;
                alu_src_a = 0;
                alu_src_b = 2'b01;
                alu_control = 4'b0010; // ADD
                pc_source = 2'b00;
                pc_write = 1;
                ir_write = 1;
            end
            DECODE: begin
                alu_src_a = 0;
                alu_src_b = 2'b11;
                alu_control = 4'b0010; // ADD
            end
            MEMADR: begin
                alu_src_a = 1;
                alu_src_b = 2'b10;
                alu_control = 4'b0010; // ADD
            end
            MEMREAD: begin
                mem_read = 1;
                i_or_d = 1;
            end
            MEMWB: begin
                reg_dst = 2'b00;
                reg_write = 1;
                mem_to_reg = 1;
            end
            MEMWRITE: begin
                mem_write = 1;
                i_or_d = 1;
            end
            EXECUTE: begin
                alu_src_a = 1;
                alu_src_b = 2'b00;
                case (funct)
                    ADD_FUNCT: alu_control = 4'b0010; // ADD
                    SUB_FUNCT: alu_control = 4'b0110; // SUB
                    AND_FUNCT: alu_control = 4'b0000; // AND
                    OR_FUNCT:  alu_control = 4'b0001; // OR
                    SLT_FUNCT: alu_control = 4'b0111; // SLT
                    default:   alu_control = 4'b0010; // ADD
                endcase
            end
            ALUWRITEBACK: begin
                reg_dst = 2'b01;
                reg_write = 1;
                mem_to_reg = 0;
            end
            BRANCH: begin
                alu_src_a = 1;
                alu_src_b = 2'b00;
                alu_control = 4'b0110; // SUB
                pc_write_cond = 1;
                pc_source = 2'b01;
            end
            ADDIEXECUTE: begin
                alu_src_a = 1;
                alu_src_b = 2'b10;
                alu_control = 4'b0010; // ADD
            end
            ADDIWRITEBACK: begin
                reg_dst = 2'b00;
                reg_write = 1;
                mem_to_reg = 0;
            end
            JUMP: begin
                pc_write = 1;
                pc_source = 2'b10;
            end
        endcase
    end

endmodule