`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/21 20:08:47
// Design Name: 
// Module Name: Data_mem
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


module Data_mem(clock, memWrite, address, writeData, readData);
    input clock;   //Clock signal.
    input memWrite;  //From controller. 1'b1 indicates write operations to data-memory.
    input [31:0] address;  //The unit is byte. The address of memory unit which is to be read/writen.
    input [31:0] writeData; //Data to be wirten to the memory unit.
    output[31:0] readData;  //Data read from memory unit.
endmodule
