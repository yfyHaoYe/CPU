`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 14:41:33
// Design Name: 
// Module Name: Controller
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


module Controller(
    input [4:0] Op,
    input [4:0] Func,
    output Jr,
    output Jmp,
    output Jal,
    output Branch,
    output nBranch,
    output RegDST,
    output MemtoReg,
    output RegWrite,
    output MemWrite,
    output ALUSrc,
    output Sftmd,
    output I_format,
    output [1:0] ALUOp
    );
endmodule
