`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/28 16:14:48
// Design Name: 
// Module Name: controller_tb
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


module controller_tb(

    );

    reg [5:0] Opcode;
    reg [5:0] Function_opcode;
    wire Jr; 
    wire RegDST; 
    wire ALUSrc; 
    wire RegWrite; 
    wire MemWrite; 
    wire Branch; 
    wire nBranch; 
    wire Jmp; 
    wire Jal; 
    wire I_format; 
    wire Sftmd; 
    wire ALUOp;
    wire MemorIOtoReg; 
    wire MemRead; 
    wire IORead; 
    wire IOWrite;
    reg [21:0] Alu_resultHigh;
    Controller cl(
        Opcode,
        Function_opcode, 
        Jr, 
        RegDST, 
        ALUSrc, 
        RegWrite, 
        MemWrite, 
        Branch, 
        nBranch, 
        Jmp, 
        Jal, 
        I_format, 
        Sftmd, 
        ALUOp, 
        Alu_resultHigh, 
        MemorIOtoReg, 
        MemRead, 
        IORead, 
        IOWrite
    );

    initial 
    fork 
        #0 Opcode = 6'b10_0011;
        #0 Function_opcode = 6'b01_0011;
        #0 Alu_resultHigh = 22'h3FFFFF;
        #100 Opcode = 6'b10_1011;
        #200 Alu_resultHigh = 22'h3abca;
        #300 Opcode = 6'b10_0011;

    join

endmodule
