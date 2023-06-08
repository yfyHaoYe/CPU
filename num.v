module scan4 (
    input clk,
    input [3:0] l0,l1,l2,l3,  //输入数字
    output reg [3:0] ena,  //使能信号
    output [7:0] light  //显像
);
  reg clk_2;//降频后时钟
  reg [1:0] scan = 0;
  parameter x = 200000;
  reg [17:0] cnt = 0;
  reg [ 3:0] num;

  num_to_signal f (
      num,
      light
  );
  //降频
  always @(posedge clk) begin
    if (cnt == (x >> 1) - 1) begin
      clk_2 <= ~clk_2;
      cnt   <= 0;
    end else cnt = cnt + 1;
  end
  
  always @(posedge clk_2) begin
    scan <= scan + 1;
  end
  always @(*) begin
    case (scan)
      2'b00: begin //最右边灯亮
        ena = 4'h01;
        num = l0;
      end  
      2'b01: begin
        ena = 4'h02;
        num = l1;
      end
      2'b10: begin
        ena = 4'h04;
        num = l2;
      end
      2'b11: begin
        ena = 4'h08;
        num = l3;
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
      4'h9: seg_out = 8'b1110_0110;  //9
      4'ha: seg_out = 8'b0000_0010;  //negitive sign
      

    endcase
endmodule