`timescale 1ns/10ps
module transmitter_tb;
parameter DELY=50;
reg clk,rst;

wire[7:0] second;
wire data_to_slave;
wire clk_baud;
wire syn_en;
wire hz;
wire [3:0] baud_cnt;
wire tx_state;
wire [3:0] num;
wire[7:0] time_buf;

initial clk=0;
always #(DELY) clk=~clk;
initial
 begin
   rst=0;
  #(DELY*300000) $stop;
 end

transmitter    trans_inst(
   .clk_10M(clk),
   .rst(rst),
    .time_second(second),
    .data_to_slave(data_to_slave),
    .clk_baud(clk_baud),
    .syn_en(syn_en),
    .hz(hz),
    .baud_cnt(baud_cnt),
    .tx_state(tx_state),
    .num(num),
    .time_buf(time_buf));
    
endmodule


