`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 11:31:00
// Design Name: 
// Module Name: cpu_tb
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


module cpu_tb(

    );
    reg clk;
    reg rst;
    wire [15:0] switches;
    wire [15:0] leds;

    initial fork
        clk = 1'b0; 
	    rst = 1'b0;
        #6000 rst = 1'b1;
        #8000 rst = 1'b0;
    join

    always #10 clk = ~clk;
    
    cpu_top_test ct(
        .clock(clk),
        .rst(rst),
        .switches(switches),
        .ledss(leds)
    );
    
endmodule
