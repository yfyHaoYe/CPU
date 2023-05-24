`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 14:05:05
// Design Name: 
// Module Name: cpu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// minisys 32 CPU Top Module

module cpu_top(
    // Inputs
    input clk,
    input rst,
    input [7:0] switch,
    // Outputs
    output [7:0] led
    );


// Controller
    //Input
    wire [31:0] Instruction = 32'b0;
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
        .ALUOp(ALUOp)
        );
    
// Decoder
    //Input
    wire [31:0] ALU_result = 32'b0;
    wire [31:0] opcplus4 = 32'b0;
    wire [31:0] Mem_data = 32'b0;
    //Output
    wire [31:0] Decoder_Data1 = 32'b0;
    wire [31:0] Decoder_Data2 = 32'b0;
    wire [31:0] Sign_extend;

    Decoder de(
        .clock(clk),
        .reset(rst),
        .Instruction(Instruction),
        .opcplus4(link_addr),
        .ALU_result(ALU_result),
        .mem_data(Mem_data),
        .RegWrite(RegWrite),
        .Jal(Jal),
        .MemtoReg(MemtoReg),
        .RegDST(RegDST),
        .read_data_1(Decoder_Data1),
        .read_data_2(Decoder_Data2),
        .Sign_extend(Sign_extend)
        );

//Data_mem
    //Input
    wire Clock;
    wire Address;
    wire WriteData;
    //Output

    Data_mem dm(
        .Clock(clk),
        .MemWrite(MemWrite),
        .Address(ALU_result),
        .WriteData(Decoder_Data2),
        .ReadData(Mem_data)
        );

//IFetch
    //Input
    wire Zero;
    //Output
    wire branch_base_addr;

    IFetch ife(
        .clock(clk),
        .reset(rst),
        .Addr_result(ALU_result),
        .Zero(Zero),
        .Read_Data_1(Decoder_Data1),
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
        .Addr_Result(Addr_result),
        .PC_plus_4(PC_plus_4)
        );
endmodule
