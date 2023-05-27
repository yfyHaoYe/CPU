`timescale 1ns / 1ps
`include "definitions.v"

module Controller(Opcode, Function_opcode, Jr, RegDST, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, nBranch, Jmp, Jal, I_format, Sftmd, ALUOp, Alu_resultHigh, MemorIOtoReg, MemRead, IORead, IOWrite);
    input[`OP_CODE_WIDTH - 1 : 0] Opcode;            // 来自IFetch模块的指令高6bit
    input[`FUNC_CODE_WIDTH - 1 : 0] Function_opcode;  	// 来自IFetch模块的指令低6bit，用于区分r-类型中的指令
    output Jr;         	 // 为1表明当前指令是jr，为0表示当前指令不是jr
    output RegDST;          // 为1表明目的寄存器是rd，为0时表示目的寄存器是rt
    output ALUSrc;          // 为1表明第二个操作数（ALU中的Binput）来自立即数（beq，bne除外），为0时表示第二个操作数来自寄存器
    output MemtoReg;     // 为1表明从存储器或I/O读取数据写到寄存器，为0时表示将ALU模块输出数据写到寄存器
    output RegWrite;   	  // 为1表明该指令需要写寄存器，为0时表示不需要写寄存器
    output MemWrite;       // 为1表明该指令需要写存储器，为0时表示不需要写储存器
    output Branch;        // 为1表明是beq指令，为0时表示不是beq指令
    output nBranch;       // 为1表明是bne指令，为0时表示不是bne指令
    output Jmp;            // 为1表明是j指令，为0时表示不是j指令
    output Jal;            // 为1表明是jal指令，为0时表示不是jal指令
    output I_format;      // 为1表明该指令是除beq，bne，lw，sw之外的I-类型指令，其余情况为0
    output Sftmd;         // 为1表明是移位指令，为0表明不是移位指令
    output [`ALU_OP_CODE_WIDTH - 1 : 0] ALUOp;        // 当指令为R-type或I_format为1时，ALUOp的高比特位为1，否则高比特位为0; 当指令为beq或bne时，ALUOp的低比特位为1，否则低比特位为0
    
    input[21:0] Alu_resultHigh; // From the execution unit Alu_Result[31..10】
    output MemorIOtoReg; // 1 indicates that data needs to be read from memory or I/O to the regist
    output MemRead; // 1 indicates that the instruction needs to read from the memory
    output IORead; // 1 indicates I/O read
    output IOWrite; // 1 indicates I/O write

    wire R_format = 1'b0;
    wire Lw = 1'b0;
    wire Sw = 1'b0;
    
    assign R_format = (Opcode == `OP_R_FORMAT);
    assign Lw = (Opcode == `OP_LW);
    assign Sw = (Opcode == `OP_SW);

    assign Jr = (R_format && (Function_opcode == `FUNC_JR));
    assign Jmp = (Opcode == `OP_JMP);
    assign Jal = (Opcode == `OP_JAL);
    assign Branch = (Opcode == `OP_BRANCH);
    assign nBranch = (Opcode == `OP_NBRANCH);
    assign RegDST = R_format;
    assign MemtoReg = (Opcode == `OP_MEMTOREG);
    assign I_format = (Opcode[5:3] == `OP_I_FORMAT);
    assign MemWrite = (Opcode == `OP_SW);
    assign ALUSrc = (I_format || Lw || MemWrite);
    assign ALUOp = {(R_format || I_format) , (Branch || nBranch)};
    assign Sftmd = (((Function_opcode == `OP_SLL)||(Function_opcode == `OP_SLLV)
                ||(Function_opcode == `OP_SRA)||(Function_opcode == `OP_SRAV)
                ||(Function_opcode == `OP_SRL)||(Function_opcode == `OP_SRLV)) && R_format);


    assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr) ; // Write memory or write IO
    assign MemWrite = Sw && Alu_resultHigh[21:0] != 22'h3FFFFF;
    assign MemRead = Lw && Alu_resultHigh[21:0] != 22'h3FFFFF; // Read memory
    assign IORead = Lw && Alu_resultHigh[21:0] == 22'h3FFFFF; // Read input port
    assign IOWrite = Sw && Alu_resultHigh[21:0] == 22'h3FFFFF; // Write output port
    // Read operations require reading data from memory or I/O to write to the register
    assign MemorIOtoReg = IORead || MemRead;
endmodule
