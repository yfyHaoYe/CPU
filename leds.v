`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds (
    input			ledrst,		// reset, active high 
    input			led_clk,	// clk for led 
    input			ledwrite,	// led write enable, active high 
    input			ledcs,		// 1 means the leds are selected as output 
    input	[1:0]	ledaddr,	// 2'b00 means updata the low 16bits of ledout, 2'b10 means updata the high 8 bits of ledout
    input	[31:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output	reg [31:0]	ledout		// the data writen to the leds  of the board
);
    
    always @ (posedge led_clk or posedge ledrst) begin
        if (ledrst)
            ledout <= 32'h00000000;
		else if (ledcs && ledwrite) begin
			if (ledaddr == 2'b00)
				ledout[31:0] <= ledwdata[31:0];
			else
				ledout <= ledout;
        end 
        else begin
            ledout <= ledout;
        end
        
    end
	
endmodule
