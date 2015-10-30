module insideclk(clk_10M,rst,time_second,syn_en,hz);
//#(
//parameter         HZ_CNT=10                 ,   
//)
parameter HZ_CNT=99;
parameter SYN_CNT=2;

input clk_10M;
input rst;
output reg [7:0] time_second;
output reg syn_en;
output hz;
reg hz;
reg [1:0] syn_cnt_num;
reg [23:0] cnt;
initial
begin
cnt=0; 
time_second=0;
syn_en=0;
hz=0;
syn_cnt_num=0;
end

always@(posedge clk_10M)
begin
  if(rst)
   begin
     time_second<=8'd0;
     cnt<=24'd0;
     //syn_en<=1'b0;
     hz<=1'b0;
    syn_cnt_num<=0;
   end
  else
   begin
    if(cnt==HZ_CNT)
     begin
       //syn_en<=1'b1;
      hz<=1'b1;
      time_second<=time_second+1;
      cnt<=8'd0;
     end
    else
    begin
    //syn_en<=1'b0;
    hz<=1'b0;
    cnt<=cnt+1;
    end
    end
end

always@(negedge clk_10M)
 begin
   if(hz)
     begin
      syn_cnt_num<=syn_cnt_num+1;
        if(syn_cnt_num==SYN_CNT)
          begin
            syn_en<=1'b1;
            syn_cnt_num<=1'b0;
          end
     end
  else
    begin
    syn_en<=1'b0;
  end
end

      
 
endmodule
