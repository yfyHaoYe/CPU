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
    input [`OP_CODE_WIDTH - 1:0] Opcode,
    input [`FUNC_CODE_WIDTH - 1:0] Function_opcode,
    output reg Jr,
    output reg Jmp,
    output reg Jal,
    output reg Branch,
    output reg nBranch,
    output reg RegDST,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemWrite,
    output reg ALUSrc,
    output reg Sftmd,
    output reg I_format,
    output reg [1:0] ALUOp
    );
    reg R_format = 1'b0;
    reg Lw = 1'b0;
    always @(*) begin
        R_format = (Opcode == `OP_R_FORMAT);
        Lw = (Opcode == `OP_LW);

        Jr = (R_format && (Function_opcode == `FUNC_JR));
        Jmp = (Opcode == `OP_JMP);
        Jal = (Opcode == `OP_JAL);
        Branch = (Opcode == `OP_BRANCH);
        nBranch = (Opcode == `OP_NBRANCH);
        RegDST = R_format;
        MemtoReg = (Opcode == `OP_MEMTOREG);
        I_format = (Opcode[5:3] == `OP_I_FORMAT);
        RegWrite = (R_format || Lw || Jal || I_format) && !(Jr);
        MemWrite = (Opcode == `OP_SW);
        ALUSrc = (I_format || Lw || MemWrite);
        ALUOp = {(R_format || I_format) , (Branch || nBranch)};
        Sftmd = (((Function_opcode == `OP_SLL)||(Function_opcode == `OP_SLLV)
                ||(Function_opcode == `OP_SRA)||(Function_opcode == `OP_SRAV)
                ||(Function_opcode == `OP_SRL)||(Function_opcode == `OP_SRLV)) && R_format);
    end

endmodule
