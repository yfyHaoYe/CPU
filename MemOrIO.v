`timescale 1ns / 1ps
`include "definitions.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/26 11:18:31
// Design Name: 
// Module Name: MemOrIO
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


// module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, m_wdata, io_rdata, io_wdata, r_wdata, r_rdata);
//     input mRead; // read memory, from Controller
//     input mWrite; // write memory, from Controller
//     input ioRead; // read IO, from Controller
//     input ioWrite; // write IO, from Controller
//     input[`ISA_WIDTH - 1:0] addr_in; // from alu_result in ALU
//     input[`ISA_WIDTH - 1:0] m_rdata; // data read from Data-Memory
//     input[15:0] io_rdata; // data read from IO,16 bits
//     input[`ISA_WIDTH - 1:0] r_rdata; // data read from Decoder(register file)

//     output [`ISA_WIDTH - 1:0] addr_out; // address to Data-Memory
//     output reg [`ISA_WIDTH - 1:0] m_wdata; // data read from Data-Memory
//     output reg [15:0] io_wdata; 
//     output reg [`ISA_WIDTH - 1:0] r_wdata; // data to Decoder(register file)

//     assign addr_out= addr_in;
    
//     // The data wirte to register file may be from memory or io. 
//     // While the data is from io, it should be the lower 16bit of r_wdata. 
//     always @* begin
//         if (mRead) r_wdata = m_rdata;
//         else if (ioRead) r_wdata = {16'b0000_0000_0000_0000, io_rdata};
//         else r_wdata = 32'bZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ;

//         if (ioWrite) io_wdata = r_rdata;

//         if (mWrite) m_wdata = r_rdata;
//         else m_wdata = 32'bZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ;
//     end
module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl);
    input mRead; // read memory, from Controller
    input mWrite; // write memory, from Controller
    input ioRead; // read IO, from Controller
    input ioWrite; // write IO, from Controller
    input[31:0] addr_in; // from alu_result in ALU
    output[31:0] addr_out; // address to Data-Memory
    input[31:0] m_rdata; // data read from Data-Memory
    input[15:0] io_rdata; // data read from IO,16 bits
    output[31:0] r_wdata; // data to Decoder(register file)
    input[31:0] r_rdata; // data read from Decoder(register file)
    output reg[31:0] write_data; // data to memory or I/O（m_wdata, io_wdata）
    output LEDCtrl; // LED Chip Select
    output SwitchCtrl; // Switch Chip Select
    assign addr_out= addr_in;
    assign r_wdata = ioRead ? {16'h0000, io_rdata} : mRead ? m_rdata : 32'h0000_0000;
    // The data wirte to register file may be from memory or io. // While the data is from io, it should be the lower 16bit of r_wdata. assign r_wdata = ？？？
    // Chip select signal of Led and Switch are all active high;
    assign LEDCtrl= ioWrite;
    assign SwitchCtrl= ioRead;
    always @* begin
        if((mWrite==1)||(ioWrite==1))
        //write_data could go to either memory or IO. where is it from?
            write_data = r_rdata;
        else
            write_data = 32'hZZZZZZZZ;
    end
endmodule
