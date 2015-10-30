module receiver(clk_10M, rst,syn_set,syn_time,load_ready,data_to_slave,rx_state,baud_cnt,rx_num,start_detect,syn_time_buf,receive_ready,time_second);
 input clk_10M;
 input rst;
 output  syn_set;
 output [7:0] syn_time;
 output  load_ready;
 output data_to_slave;
 output rx_state;
 output [3:0] baud_cnt;
 output [3:0] rx_num;
 output [1:0] start_detect;
 output [7:0] syn_time_buf;
output  receive_ready ;
output[7:0] time_second;

 wire data_to_slave;

 
 //module transmitter(clk_10M,rst,time_second,data_to_slave,clk_baud,syn_en,hz,baud_cnt,tx_state,num,time_buf);
 transmitter trans_two(.clk_10M(clk_10M),.rst(rst),.data_to_slave(data_to_slave),.time_second(time_second));


// module syn_rx(data_to_slave,clk_10M,syn_set,syn_time,load_ready);
  syn_rx syn_inst(.data_to_slave(data_to_slave),.clk_10M(clk_10M),.syn_set(syn_set),.syn_time(syn_time),.load_ready(load_ready),
  .rx_state(rx_state),.baud_cnt(baud_cnt),.rx_num(rx_num),.start_detect(start_detect),.syn_time_buf(syn_time_buf),.receive_ready(receive_ready))    ;


endmodule
