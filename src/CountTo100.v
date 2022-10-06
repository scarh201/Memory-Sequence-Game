// ECE 5440
// Mohammed Kassif 6092
// CountTo100
// counts to 100
module CountTo100 (clk,rst,enput,one_Hundred);
input clk, rst,enput;

reg[6:0] count;
output one_Hundred;
reg one_Hundred;
  
always @ (posedge clk) begin
// if (enput==1'b1) begin
  if(rst==1'b0) begin
   count<= 7'b0;
   one_Hundred <=1'b0;
   end
  else begin 
     if (enput==1'b0 ) 
       one_Hundred<=1'b0;
 
     else begin
      if (count == 7'd100) begin //100
        one_Hundred<= 1;
        count <=0;
        end
      else begin
        count <= count +1;
        one_Hundred<= 0;
          end
      end
   //end
   end
end 

endmodule 





/*


module CountTo100 (clk,rst,enput,one_ms);
input clk, rst,enput;

reg[6:0] count;
output one_ms;
reg one_ms;
  
always @ (posedge clk) begin
// if (enput==1'b1) begin
  if(rst==1'b0) begin
   count<= 7'b0;
   one_ms <=1'b0;
   end
  else begin 
     if (count == 4'd2 ) begin
       one_ms<=1'b1;
       count<=0;
     end
     else begin
      if (enput == 1'b1 ) begin //50000
        one_ms<= 0;
        count <=count+1;
        end
      else begin
        //count <= count +1;
        one_ms<= 0;
          end
      end
   //end
   end
end 

endmodule 

module CountTo100 (clk,rst,one_ms,enable);
input clk, rst,one_ms;

reg[3:0] count;
output enable;
reg enable;
  
always @ (posedge clk) begin

if (one_ms==1'b1) begin
  if(rst==1'b0) begin
   count<= 4'b0;
   enable <=1'b0;
   end
  else begin
   if (count == 4'd3) begin  //100
      enable<= 1'b1;
      count <=1'b0;
   end
   else begin
    count <= count +1;
    //enable<= 0;
   end
  end
 end
end 

endmodule 
*/