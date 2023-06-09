module scan4 (
    input clk,
    input rst,
    input LEDCtrl,
    input [15:0]ledwdata,  //输入数字
    output reg [3:0] ena = 0,  //使能信号
    output [7:0] light  //显像
);
  // reg clk_2 = 0;//降频后时钟
  reg [1:0] scan = 0;
  parameter x = 2000;
  reg [17:0] cnt = 0;
  reg [3:0] num = 0;

  num_to_signal f (
      num,
      light
  );

  reg [15:0]ledout = 16'h0000;


  always @ (posedge clk or posedge rst) begin
    if (rst)
      ledout <=16'h0000;
		else if (LEDCtrl) 
				ledout[15:0] <= ledwdata[15:0];
    else 
      ledout <= ledout;
  end

  reg clk_2 =0 ;
  //降频
  always @(posedge clk) begin
    if (cnt == (x >> 1) - 1) begin
      clk_2 <= ~clk_2;
      cnt   <= 0;
    end else cnt <= cnt + 1;
  end
  
  always @(posedge clk_2) begin
    scan <= scan + 1;
  end

  always @(*) begin
    if (rst) begin
      ena = 4'h01;
      num = 0;
    end
	  else 
    case (scan)
      2'b00: begin //最右边灯亮
        ena = 4'h1;
        num = ledwdata[3:0];
      end  
      2'b01: begin
        ena = 4'h2;
        num = ledwdata[7:4];
      end
      2'b10: begin
        ena = 4'h4;
        num = ledwdata[11:8];
      end
      2'b11: begin
        ena = 4'h8;
        num = ledwdata[15:12];
      end
    endcase
  end
endmodule

module num_to_signal (
    input [3:0] num,
    output reg [7:0] seg_out
);
  always @*
    case (num)
      4'h0: seg_out = 8'b1111_1100;  //0
      4'h1: seg_out = 8'b0110_0000;  //1
      4'h2: seg_out = 8'b1101_1010;  //2
      4'h3: seg_out = 8'b1111_0010;  //3
      4'h4: seg_out = 8'b0110_0110;  //4
      4'h5: seg_out = 8'b1011_0110;  //5
      4'h6: seg_out = 8'b1011_1110;  //6
      4'h7: seg_out = 8'b1110_0000;  //7
      4'h8: seg_out = 8'b1111_1110;  //8
      4'h9: seg_out = 8'b1111_0110;  //9
      4'ha: seg_out = 8'b1110_1110;  //a
      4'hb: seg_out = 8'b0011_1110;  //b
      4'hc: seg_out = 8'b1001_1100;  //c
      4'hd: seg_out = 8'b0111_1010;  //d
      4'he: seg_out = 8'b1001_1110;  //e
      4'hf: seg_out = 8'b1000_1110;  //f
      default: seg_out = 8'b1111_1100;

    endcase
endmodule