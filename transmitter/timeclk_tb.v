`timescale 1ns/10ps
module insideclk_tb;
parameter DELY=50;
reg clk,rst;

wire[7:0] out;
wire syn_en;
wire hz;
initial clk=0;
always #(DELY) clk=~clk;
initial
 begin
   rst=0;
  #(DELY*300000) $stop;
 end
//acc instance
insideclk #(99)   clk_inst(
   .clk_10M(clk),
   .rst(rst),
    .time_second(out),
    .syn_en(syn_en),
    .hz(hz));
endmodule
