`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/21 20:08:47
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] Read_data_1,
    input [31:0] Read_data_2,
    input [31:0] Sign_extend,
    input [4:0] Opcode,
    input [4:0] Function_opcode,
    input [4:0] Shamt,
    input [31:0] PC_plus_4,
    input [1:0] ALUOp,
    input ALUSrc,
    input I_format,
    input Sftmd,
    output [31:0] ALU_Result,
    output [31:0] Zero,
    output [31:0] Addr_Result
    );
endmodule
