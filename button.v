`timescale 1ns / 1ps

module button (//接受一个按钮的端口，按钮按下1次(clk为原始时钟)时pos在瞬间为1, 输出需放在时序always内
    input  clk,
    input  bt,
    output reg pos = 0
);
  reg [1:0] trig = 2'b00;  //中按键模拟上升沿
  reg cnt = 0;
  reg [28:0] cnt_1s = 0;  //
  always @(posedge clk) begin
    trig[0] <= bt;
    trig[1] <= trig[0];
    if (~cnt & (trig[0] ^ trig[1])) begin
      cnt <= 1;
      cnt_1s <= 0;
      pos <= bt;
    end 
    else if(~cnt) begin 
      cnt <= 0;
      cnt_1s <= 0;
      pos <= pos;
    end
    else if(cnt_1s == 20) begin
        cnt <= 0;
        cnt_1s <= 0;
        pos <= bt;
      end
    else begin
      cnt_1s <= cnt_1s + 1;
      pos <= pos;
      cnt <= cnt;
    end
  end

endmodule