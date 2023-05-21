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
    input [`OP_CODE_WIDTH - 1:0] Op,
    input [`FUNC_CODE_WIDTH - 1:0] Func,
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
        R_format = (Op == `OP_R_FORMAT);
        Lw = (Op == `OP_LW);

        Jr = (R_format && (Func == `FUNC_JR));
        Jmp = (Op == `OP_JMP);
        Jal = (Op == `OP_JAL);
        Branch = (Op == `OP_BRANCH);
        nBranch = (Op == `OP_NBRANCH);
        RegDST = R_format;
        MemtoReg = (Op == `OP_MEMTOREG);
        RegWrite = (R_format || Lw || Jal || I_format) && !(Jr);
        I_format = (Op[5:3] == `OP_I_FORMAT);
        ALUOp = {(R_format || I_format) , (Branch || nBranch)};
        Sftmd = (((Func == `OP_SLL)||(Func == `OP_SLLV)
                ||(Func == `OP_SRA)||(Func == `OP_SRAV)
                ||(Func == `OP_SRL)||(Func == `OP_SRLV)) && R_format);
    end

endmodule
