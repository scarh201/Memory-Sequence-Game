// ECE 5440
// Lil Engineers 
// Time_Scaling
// 

module Time_Scaling(rst,clk,increment,decrement,num);
input rst,clk;
input increment,decrement; // pulse inputs to increment or decrement 

output [3:0] num; // output to the digit timer
reg [3:0] num;

always @ (posedge clk) begin

  if (rst == 1'b0) begin 
   num<=4'd0; //default value 
  end  
  else begin 
   if (increment == 1'b1) begin
    if (num==4'd9) begin // loops back around after 9 
      //num<=4'd9; 
		end
    else  
     num<=num+1;
    end
 
   else begin
   if (decrement == 1'b1) begin
    if (num==4'd0) begin
  //   num<=4'd0;
    end
    else    
     num<=num-1;
   end 

   end 

 
end //rst else
   

end // always 
endmodule
