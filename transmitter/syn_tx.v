module syn_tx(syn_en,hz,Data_Second,clk_10M,data_to_slave,clk_baud,time_buf,num,tx_state,baud_cnt);
/*#(
parameter           TIME_LOAD                 ,  
parameter           BAUD_DIV                 ,   
parameter           BAUD_DIV_HALF            ,  
parameter           DATA_TX                  ,   
parameter           DATA_NUM                 ,  
parameter           NUM_CNT                  ,  
)  */

parameter TIME_LOAD=80;
parameter BAUD_DIV=4;
parameter DATA_NUM=10;
parameter NUM_CNT=2;
parameter BAUD_DIV_HALF=2;

input syn_en;
input hz;                              
input [7:0] Data_Second;                       
input clk_10M;                                
output reg data_to_slave;                     
output clk_baud;                             
reg [23:0] hz_cnt;                       
output reg [3:0]    baud_cnt;                    
output reg      tx_state;                        
output reg [3:0] num;                           
output reg [7:0] time_buf;                         
reg  clk_baud_r;

initial
begin
baud_cnt=0;
hz_cnt=0;
time_buf=0;
num=0;
clk_baud_r=0;
data_to_slave=0;
tx_state=0;
end

always@(negedge clk_10M)                //
begin
  if(hz)
  begin
  baud_cnt<=0;
  hz_cnt=0;
  end
end

always@(posedge clk_10M)                   
 begin
   hz_cnt<=hz_cnt+1;
   if(hz_cnt==TIME_LOAD)
      time_buf<=Data_Second+8'd1;
end

always @(posedge clk_10M)                   
  begin
   if(baud_cnt==BAUD_DIV)
      baud_cnt<=0;
   else
      baud_cnt<=baud_cnt+1;
   end



always@(posedge clk_10M)
begin
  if(tx_state==1'b0)
     begin
       if(syn_en)
        begin
          tx_state<=1'b1;
        end
       else
        begin
          tx_state<=1'b0;
        end
       end
   else
     begin
        if(num==DATA_NUM)
          begin
           tx_state<=1'b0;
          end
        else
          begin
            tx_state<=1'b1;
          end
     end
  end

always@(posedge clk_10M)
 begin
   if(tx_state)
     begin
       if(baud_cnt==NUM_CNT)
         begin
           num<=num+1;
           if(num==DATA_NUM)
             begin
               num<=4'd0;
             end
          end
      end
    else
      begin
        num<=4'd0;
      end
 end


always @(negedge clk_10M)
begin
  if(tx_state)
   begin
    case(num)
     4'd1: data_to_slave<=1'b1;
     4'd2: data_to_slave<=time_buf[7];
     4'd3: data_to_slave<=time_buf[6];
     4'd4: data_to_slave<=time_buf[5];
     4'd5: data_to_slave<=time_buf[4];
     4'd6: data_to_slave<=time_buf[3];
     4'd7: data_to_slave<=time_buf[2];
     4'd8: data_to_slave<=time_buf[1];
     4'd9: data_to_slave<=time_buf[0];
     default:  data_to_slave<=1'b0;
    endcase
   end
  else
   begin
     data_to_slave<=1'b0;
   end
end

always@(posedge clk_10M)
begin
  if(baud_cnt==BAUD_DIV)
    begin
      clk_baud_r<=1'b1;
    end
  else
    begin
     if(baud_cnt==BAUD_DIV_HALF)
       begin
         clk_baud_r<=1'b0;
       end
    end
end

assign clk_baud=clk_baud_r;

endmodule







