`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/28 03:07:47
// Design Name: 
// Module Name: ALU_sim
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


module ALU_sim(

    );
wire [31:0] ALU_result;
wire [31:0] Addr_result;
wire [31:0] PC_plus_4;
    ALU alu(
        32'b1111_1111_1111_1111_1110_0101_1100_0001,
        32'b0000_0000_0000_0000_0000_0000_0000_0000,
        32'b1111_1111_1111_1111_1111_1111_1111_1111,
        6'b11_1111,
        6'b10_0011,
        2'b00,
        5'b11111,
        1'b0,
        1'b1,
        1'b0,
        1'b0,
        1'b0,
        ALU_result,
        Addr_result,
        PC_plus_4
    );
endmodule
