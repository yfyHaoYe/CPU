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
    wire [31:0] Inst;
    //Output
    wire Jr;
    wire Jmp;
    wire Jal;
    wire Branch;
    wire nBranch;
    wire RegDST;
    wire MemtoReg;
    wire RegWrite;
    wire MemWrite;
    wire ALUSrc;
    wire Sftmd;
    wire I_format;
    wire ALUOp;
    Controller cl(
        .Op(Inst[31:26]),
        .Func(Inst[5:0]),
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
    
//    
endmodule
