// ECE 5440
// Mohammed Kassif 6092
// CountTo10
// counts to 10.  output at 1 second intervals 

module CountTo10 (clk,rst,enput,Ten);
input clk, rst,enput;

reg[3:0] count;
output Ten;
reg Ten;
  
always @ (posedge clk) begin
// if (enput==1'b1) begin
  if(rst==1'b0) begin
   count<= 16'b0;
   Ten <=1'b0;
   end
  else begin 
   if (enput==1'b1) begin
     if (count == 4'd10) begin //50000
      Ten<= 1;
      count <=0;
      end
     else begin
      count <= count +1;
      Ten<= 0;
      end
    end
 
   else begin
   Ten<=1'b0;
   end
end
end 

endmodule 

/*module CountTo10 (clk,rst,enable,OneSec);
input clk, rst,enable;

reg[3:0] count;
output OneSec;
reg OneSec;
  always @ (posedge clk) begin
 if (enable == 1'b1) begin 
  if(rst==1'b0) begin
   count<= 4'b0;
   OneSec <=0;
  end
  else begin 
   if (count == 4'd 2) begin //2
      OneSec<= 1;
      count <=0;
   end
   else begin
    count <= count +1;
   // OneSec<= 0;
    end
   end
 end
end 

endmodule 
*/