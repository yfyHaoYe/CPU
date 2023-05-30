`timescale 1ns / 1ps
`include "definitions.v"

module Decoder(read_data_1,read_data_2,Instruction,r_wdata,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);
    output[`ISA_WIDTH - 1:0] read_data_1;               // 输出的第一操作数
    output[`ISA_WIDTH - 1:0] read_data_2;               // 输出的第二操作数
    input[`ISA_WIDTH - 1:0]  Instruction;               // 取指单元来的指令
    input[`ISA_WIDTH - 1:0]  r_wdata;   				//  从DATA RAM or I/O port取出的数据
    input[`ISA_WIDTH - 1:0]  ALU_result;   				// 从执行单元来的运算的结果
    input        Jal;                       //  来自控制单元，说明是JAL指令 
    input        RegWrite;                  // 来自控制单元，为1表明该指令需要写寄存器，为0时表示不需要写寄存器
    input        MemtoReg;              // 来自控制单元，为1表明从存储器或I/O读取数据写到寄存器，为0时表示将ALU模块输出数据写到寄存器
    input        RegDst;             //0 = rt，1 = rd
    output reg[`ISA_WIDTH - 1:0] Sign_extend;               // 扩展后的32位立即数
    input		 clock,reset;                // 时钟和复位
    input[`ISA_WIDTH - 1:0]  opcplus4;                 // 来自取指单元，JAL中用
    reg [`REG_FILE_ADDR_WIDTH - 1:0] write_addr,read_addr_1,read_addr_2;            //寄存器地址
    reg [`ISA_WIDTH - 1:0] decoder_write_data;              //寄存器写入数据

    
    always @(Instruction, RegDst, Jal, RegWrite, MemtoReg, opcplus4, r_wdata, ALU_result) begin
        read_addr_1 = Instruction[25:21];
        read_addr_2 = Instruction[20:16];
        if(Instruction[15])
        Sign_extend = { 16'hffff , Instruction[`IMMEDIATE_WIDTH - 1 : 0]};
        else
        Sign_extend = { 16'h0000 , Instruction[`IMMEDIATE_WIDTH - 1 : 0]};
        if(RegDst) write_addr = Instruction[15:11];
        else write_addr = Instruction[20:16];
        if(Jal) begin // Jal命令
           write_addr = 5'b11111;
           decoder_write_data = opcplus4;
        end
        else if(RegWrite && MemtoReg)
            decoder_write_data = r_wdata; // 从存储器或I/O读取数据写到寄存器
        else decoder_write_data = ALU_result;// 将ALU模块输出数据写到寄存器
    end

    register_file registers(
        .clk(clock),
        .rst_n(reset),
        .write_en(RegWrite),
        .write_reg_addr(write_addr),
        .write_data(decoder_write_data),
        .read_reg_addr_1(read_addr_1),
        .read_reg_addr_2(read_addr_2),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );
endmodule