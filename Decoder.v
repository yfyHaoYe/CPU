`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/21 20:08:47
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    input [4:0] Rs,
    input [4:0] Rt,
    input [4:0] Rd,
    input [31:0] ALU_result,
    input [31:0] Mem_data,
    input WriteRegister,
    input Jal,
    input MemtoReg,
    input RegDST,
    output [31:0] Decoder_Data1,
    output [31:0] Decoder_Data2,
    output [31:0] Imme
    );
endmodule
