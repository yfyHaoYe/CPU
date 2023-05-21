`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/21 20:08:47
// Design Name: 
// Module Name: IFetch
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


module IFetch(
    input Clock,
    input Reset,
    input [31:0] Address,
    input Zero,
    input [31:0] Read_Data_1,
    input Branch,
    input nBranch,
    input Jmp,
    input Jal,
    input Jr,
    output [31:0] Instruction,
    output [31:0] branch_base_addr,
    output [31:0] link_addr
    );
endmodule
