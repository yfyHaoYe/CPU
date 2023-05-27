`timescale 1ns / 1ps
`include "definitions.v"

// minisys 32 CPU Top Module

module cpu_top(
    // Inputs
    input clock,
    input rst,
    input [15:0] switches,
    // Outputs
    output [15:0] leds
    );

    wire clk;

    cpuclk cclk(
        .clk_in1(clock),
        .clk_out1(clk)
    );

// Controller
    //Input
    wire [`ISA_WIDTH - 1 : 0] Instruction;
    //Output
    wire Jr = 1'b0;
    wire Jmp = 1'b0;
    wire Jal = 1'b0;
    wire Branch = 1'b0;
    wire nBranch = 1'b0;
    wire RegDST = 1'b0;
    wire MemtoReg = 1'b0;
    wire RegWrite = 1'b0;
    wire MemWrite = 1'b0;
    wire ALUSrc = 1'b0;
    wire Sftmd = 1'b0;
    wire I_format = 1'b0;
    wire [1:0] ALUOp = 1'b0;
    wire MemRead = 1'b0;
    wire IORead = 1'b0;
    wire IOWrite = 1'b0;


    Controller ctrl(
        .Opcode(Instruction[31:26]),
        .Function_opcode(Instruction[5:0]),
        .Jr(Jr),
        .Jmp(Jmp),
        .Jal(Jal),
        .Branch(Branch),
        .nBranch(nBranch),
        .RegDST(RegDST),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .Sftmd(Sftmd),
        .I_format(I_format),
        .ALUOp(ALUOp),
        .Alu_resultHigh(ALU_result[21:0]), 
        .MemorIOtoReg(), 
        .MemRead(MemRead), 
        .IORead(IORead), 
        .IOWrite(IOWrite)
        );
    
// Decoder
    //Input
    wire [`ISA_WIDTH - 1 : 0] ALU_result = 32'b0;
    wire [`ISA_WIDTH - 1 : 0] m_rdata = 32'b0;
    wire [`ISA_WIDTH - 1 : 0] r_wdata = 32'b0;
    wire [`ISA_WIDTH - 1 : 0] link_addr = 32'b0;
    //Output
    wire [`ISA_WIDTH - 1 : 0] Decoder_Data1 = 32'b0;
    wire [`ISA_WIDTH - 1 : 0] Decoder_Data2 = 32'b0;
    wire [`ISA_WIDTH - 1 : 0] Sign_extend;

    Decoder de(
        .clock(clk),
        .reset(rst),
        .Instruction(Instruction),
        .opcplus4(link_addr),
        .ALU_result(ALU_result),
        .r_wdata(r_wdata),
        .RegWrite(RegWrite),
        .Jal(Jal),
        .MemtoReg(MemtoReg),
        .RegDst(RegDST),
        .read_data_1(Decoder_Data1),
        .read_data_2(Decoder_Data2),
        .Sign_extend(Sign_extend)
        );

//Data_mem
    //Input
    wire [`ISA_WIDTH - 1:0] Address;
    wire [`ISA_WIDTH - 1:0] m_wdata;
    //Output

    Data_mem dm(
        .clock(clk),
        .memWrite(MemWrite),
        .address(Address),
        .writeData(m_wdata),
        .readData(m_rdata)
        );

//IFetch
    //Input
    wire Zero;
    //Output
    wire branch_base_addr;

    IFetch ife(
        .clock(clk),
        .reset(rst),
        .Addr_result(),
        .Zero(Zero),
        .Read_data_1(Decoder_Data1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Instruction(Instruction),
        .branch_base_addr(branch_base_addr),
        .link_addr(link_addr)
        );

//ALU
    //Input
    //Output

    ALU alu(
        .Read_data_1(Decoder_Data1),
        .Read_data_2(Decoder_Data2),
        .Sign_extend(Sign_extend),
        .Exe_opcode(Exe_opcode),
        .Function_opcode(Function_opcode),
        .Shamt(Shamt),
        .PC_plus_4(branch_base_addr),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .I_format(I_format),
        .Sftmd(Sftmd),
        .Jr(Jr),
        .ALU_Result(ALU_result),
        .Zero(Zero),
        .Addr_Result(Addr_result)
        );


//MemOrIO
    //Input
    //Output

    MemOrIO moi(
        .mRead(MemRead),
        .mWrite(MemWrite), 
        .ioRead(IORead), 
        .ioWrite(IOWrite),
        .addr_in(ALU_Result), 
        .addr_out(Address),
        .m_rdata(m_rdata),
        .m_wdata(),//m_wdata),
        .io_rdata(switches),
        .io_wdata(leds),
        .r_wdata(r_wdata),
        .r_rdata(Decoder_Data2)
    );

endmodule
