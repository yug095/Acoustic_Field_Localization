module transmitter(clk_10M,rst,time_second,data_to_slave,clk_baud,syn_en,hz,baud_cnt,tx_state,num,time_buf);
input clk_10M;
input rst;
output reg hz;
output reg syn_en;
output reg[7:0] time_second;
output  data_to_slave;
output clk_baud;
output [3:0] baud_cnt;
output  tx_state;
output [3:0] num;
output  [7:0] time_buf;


wire [7:0] Data_Second_r;
wire  syn_en_r;
wire hz_r;

insideclk insideclkinst(.clk_10M(clk_10M),.rst(rst),.time_second(Data_Second_r),.syn_en(syn_en_r),.hz(hz_r));

syn_tx   syninst(.syn_en(syn_en_r),.hz(hz_r),.Data_Second(Data_Second_r),.clk_10M(clk_10M),.data_to_slave(data_to_slave),.clk_baud(clk_baud),
.time_buf(time_buf),.num(num),.tx_state(tx_state),.baud_cnt(baud_cnt));



always@(posedge clk_10M)
begin
time_second<=Data_Second_r;
hz<=hz_r;
syn_en<=syn_en_r;
end

endmodule


