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
    // Outputs
    output led
    );


// Controller
    //Input
    wire [31:0] Inst = 32'b0;
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
        .Opcode(Inst[31:26]),
        .Function_opcode(Inst[5:0]),
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
    wire [31:0] Mem_data = 32'b0;
    //Output
    wire [31:0] Decoder_Data1 = 32'b0;
    wire [31:0] Decoder_Data2 = 32'b0;
    wire [31:0] Imme;
    Decoder de(
        .Rs(Inst[25:21]),
        .Rt(Inst[20:16]),
        .Rd(Inst[15:11]),
        .ALU_result(ALU_result),
        .Mem_data(Mem_data),
        .WriteRegister(RegWrite),
        .Jal(Jal),
        .MemtoReg(MemtoReg),
        .RegDST(RegDST),
        .Decoder_Data1(Decoder_Data1),
        .Decoder_Data2(Decoder_Data2),
        .Imme(Imme)
        );

//Data_mem
    //Input
    wire Clock;
    wire Address;
    wire WriteData;
    //Output
    wire ReadData;

    Data_mem dm(
        .Clock(clk),
        .MemWrite(MemWrite),
        .Address(ALU_result),
        .WriteData(Decoder_Data2),
        .ReadData(ReadData))

//IFetch
    //Input
    //Output

//ALU
    //Input
    //Output
endmodule
