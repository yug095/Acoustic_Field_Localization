module syn_rx(data_to_slave,clk_10M,syn_set,syn_time,load_ready,rx_state,baud_cnt,rx_num,start_detect,syn_time_buf,receive_ready);
/*#(
parameter          RXBIT                  ,   //�źŽ�������λ������
parameter          START                  ,   //��ʼ�źż�����
parameter          BAUD_DIV               ,   //������ʱ�ӷ�Ƶ����
)   */
parameter RXBIT=10;
parameter START=2;
parameter BAUD_DIV=4;

input data_to_slave;     //��FPGA���յ���λ����
input clk_10M ;          //ϵͳʱ��
output reg syn_set   ;       //���յ�ͬ���źŵı�־���ߵ�ƽʱ���Ͻ� 1hz_cnt�õ�ĳ����ֵ
output reg [7:0]  syn_time;  //���յ��Ĵ����������ϳ�8λ���ź�
output  load_ready;     //��������ʱ����ź�

output reg rx_state;   //��������״̬  0λ����״̬ 1Ϊ����̬
output reg [3:0] baud_cnt ; //����������ʱ�ӵļ�����
output reg [3:0] rx_num;   //��������λ���Ĵ���
output reg [1:0] start_detect;
output reg [7:0] syn_time_buf;
output reg receive_ready ; //����ȫ���������
reg receive_ready_temp0;
reg receive_ready_temp1;
reg receive_ready_temp2;
initial
begin
rx_state=0;
baud_cnt=0;
rx_num=0;
start_detect=0;
syn_time_buf=0;
receive_ready=0;
receive_ready_temp0=0;
receive_ready_temp1=0;
receive_ready_temp2=0;

syn_set=0;
syn_time=0;
end

always@(posedge clk_10M)
 begin
  if(rx_state==1'b0)
    begin
     receive_ready<=1'b0;
     syn_set<=0;
     if(data_to_slave==1'b0)
      begin
       rx_state<=1'b0;
       start_detect<=2'd0;
      end
     else
       begin
        start_detect<=start_detect+1;
         if(start_detect==START)
           begin
            rx_state<=1'b1;
            start_detect<=0;
            syn_set<=1'b1;
           end
         else
           begin
            syn_set<=0;
            rx_state<=1'b0;
           end
        end
     end
  else
    begin
      if((rx_num)==RXBIT-1)
        begin
         receive_ready<=1'b1;
         rx_state<=1'b0;
        end
      else
         begin
          receive_ready<=1'b0;
          rx_state<=1'b1;
          syn_set<=0;
         end
     end
end


always@(posedge clk_10M)
 begin
   if(rx_state==1'b0)
    begin
      baud_cnt<=0;
    end
   else
    begin
      if(baud_cnt==BAUD_DIV)
        begin
         baud_cnt<=0;
        end
      else
       begin
         baud_cnt<=baud_cnt+1;
       end
    end
 end


always @(posedge clk_10M)
 begin
   if(rx_state==1'b0)
    begin
      rx_num<=0;
      syn_time_buf<=0;
    end
   else
     begin
       if(baud_cnt==BAUD_DIV-1)
         begin
          rx_num<=rx_num+1;
         end
     end
 end

always@(negedge clk_10M)
 begin
   if(baud_cnt==BAUD_DIV)
  case(rx_num)
   4'd1: syn_time_buf[7]<=data_to_slave;
   4'd2: syn_time_buf[6]<=data_to_slave;
   4'd3: syn_time_buf[5]<=data_to_slave;
   4'd4: syn_time_buf[4]<=data_to_slave;
   4'd5: syn_time_buf[3]<=data_to_slave;
   4'd6: syn_time_buf[2]<=data_to_slave;
   4'd7: syn_time_buf[1]<=data_to_slave;
   4'd8: syn_time_buf[0]<=data_to_slave;
  endcase
 end

always@(posedge clk_10M)
 begin
   if(receive_ready)
    syn_time<=syn_time_buf;
 end

always@(posedge clk_10M)
begin
        receive_ready_temp0 <= receive_ready;
        receive_ready_temp1 <= receive_ready_temp0;
        receive_ready_temp2 <= receive_ready_temp1;
end


assign load_ready = ~receive_ready_temp2 & receive_ready_temp1;
endmodule

