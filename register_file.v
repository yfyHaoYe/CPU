`include "definitions.v"
`timescale 1ns / 1ps

/*
    Input:
        clk:        clock signal
        read_reg_addr_1, read_reg_addr_2, write_reg_addr: 
        write_data: the data to be written into register, which comes from alu result or memory

    Output:
        read_data_1: comes from rs
        read_data_2: comes from rt
*/
module register_file (
    input  clk, rst_n,
    input                               write_en,
    input  [`REG_FILE_ADDR_WIDTH - 1:0] write_reg_addr,
    input  [`ISA_WIDTH - 1:0]           write_data,
    
    input  [`REG_FILE_ADDR_WIDTH - 1:0] read_reg_addr_1,
    output [`ISA_WIDTH - 1:0]           read_data_1,
    input  [`REG_FILE_ADDR_WIDTH - 1:0] read_reg_addr_2, 
    output [`ISA_WIDTH - 1:0]           read_data_2
    );

    reg [`ISA_WIDTH - 1:0] registers [`ISA_WIDTH - 1:0];

    // always @(negedge clk) begin
    //     if (~id_no_op) begin
    //         read_data_1 <= registers[read_reg_addr_1];
    //         read_data_2 <= registers[read_reg_addr_2];
    //     end
    // end

    integer i;
    always @(negedge clk, negedge rst_n) begin
        if (~rst_n)
            for (i = 0; i < `ISA_WIDTH; i = i + 1)
                registers[i] <= 0;
        else if (write_en & (write_reg_addr != 0)) 
            registers[write_reg_addr] <= write_data;
        else 
            registers[0] <= 0;
    end

    assign read_data_1 = (registers[read_reg_addr_1]);
    assign read_data_2 = (registers[read_reg_addr_2]);

endmodule