`timescale 1ns / 1ps
`include "definitions.v"

module Decoder(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);
    output[`ISA_WIDTH - 1:0] read_data_1;               // 输出的第一操作数
    output[`ISA_WIDTH - 1:0] read_data_2;               // 输出的第二操作数
    input[`ISA_WIDTH - 1:0]  Instruction;               // 取指单元来的指令
    input[`ISA_WIDTH - 1:0]  mem_data;   				//  从DATA RAM or I/O port取出的数据
    input[`ISA_WIDTH - 1:0]  ALU_result;   				// 从执行单元来的运算的结果
    input        Jal;                       //  来自控制单元，说明是JAL指令 
    input        RegWrite;                  // 来自控制单元
    input        MemtoReg;              // 来自控制单元
    input        RegDst;             
    output reg[`ISA_WIDTH - 1:0] Sign_extend;               // 扩展后的32位立即数
    input		 clock,reset;                // 时钟和复位
    input[`ISA_WIDTH - 1:0]  opcplus4;                 // 来自取指单元，JAL中用
    reg decoder_write;              //控制寄存器写入
    reg [`REG_FILE_ADDR_WIDTH - 1:0] write_addr,read_addr_1,read_addr_2;            //寄存器地址
    reg [`ISA_WIDTH - 1:0] decoder_write_data;              //寄存器写入数据

    

    always @* begin
        if(Instruction[15] == 1) Sign_extend = {16'b1111_1111_1111_1111, Instruction[`IMMEDIATE_WIDTH - 1:0]};//符号位拓展
        else Sign_extend = {16'b0000_0000_0000_0000, Instruction[`IMMEDIATE_WIDTH - 1:0]};
        if(Jal) begin // Jal命令
           decoder_write = 1; // 写入$RA寄存器
           write_addr = 5'b11111;
           decoder_write_data = opcplus4;
        end
        else if(RegWrite && MemtoReg)
            ; // 
        else ;// 
    end

    register_file registers(
        .clk(clock),
        .rst_n(reset),
        .write_en(RegWrite||MemtoReg),
        .write_reg_addr(RegDst),
        .write_data(ALU_result),
        .read_reg_addr_1()
    );
endmodule