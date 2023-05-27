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


module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, m_wdata, io_rdata, io_wdata, r_wdata, r_rdata);
    input mRead; // read memory, from Controller
    input mWrite; // write memory, from Controller
    input ioRead; // read IO, from Controller
    input ioWrite; // write IO, from Controller
    input[`ISA_WIDTH - 1:0] addr_in; // from alu_result in ALU
    input[`ISA_WIDTH - 1:0] m_rdata; // data read from Data-Memory
    input[15:0] io_rdata; // data read from IO,16 bits
    input[`ISA_WIDTH - 1:0] r_rdata; // data read from Decoder(register file)

    output [`ISA_WIDTH - 1:0] addr_out; // address to Data-Memory
    output reg [`ISA_WIDTH - 1:0] m_wdata; // data read from Data-Memory
    output reg [15:0] io_wdata; 
    output reg [`ISA_WIDTH - 1:0] r_wdata; // data to Decoder(register file)

    assign addr_out= addr_in;
    
    // The data wirte to register file may be from memory or io. 
    // While the data is from io, it should be the lower 16bit of r_wdata. 
    always @* begin
        if (mRead) r_wdata = m_rdata;
        else if (ioRead) r_wdata = {16'b0000_0000_0000_0000, io_rdata};
        else r_wdata = 32'bZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ;

        if (ioWrite) io_wdata = r_rdata;

        if (mWrite) m_wdata = r_rdata;
        else m_wdata = 32'bZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ_ZZZZ;
    end

endmodule
