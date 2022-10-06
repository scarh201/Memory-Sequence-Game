// ECE 5440
// Lil Engineers 
// DigitTimer
// single digit timer module, multiple can be combined


module DigitTimer(rst, clk, ReConfig,Num_in ,Digit, BorrowUp, BorrowDn, No_BorrowUp, No_BorrowDn);
 input rst, clk, ReConfig, No_BorrowUp, BorrowDn;
 input [3:0] Num_in; // output of the scaling module
 output BorrowUp, No_BorrowDn; //  
 output [3:0] Digit; // the current out number 
 reg BorrowUp, No_BorrowDn;
 reg[3:0] Digit;
 wire [3:0] Num; // for assign function
 always @ (posedge clk) begin
  // Digit<=Num; 
     BorrowUp<=1'b0;
   if (rst == 1'b0) begin
    BorrowUp<=1'b0;
    No_BorrowDn<=1'b0; 
    Digit<=Num;
   end
   else begin 
   if (ReConfig==1'b1) begin // 
    No_BorrowDn<=1'b0;
    Digit<=Num; // sets the output digit to whatever the scaling module number is  
                // so output only updates while ReConfig == 1;
   end
   else begin 
    
    if (BorrowDn==1  ) begin // 1 sec pulse 
     if (Digit==4'b0001 ) begin
       if( No_BorrowUp==1) begin
          No_BorrowDn <= 1'b1;  end
	 end
        if (Digit == 4'd0 ) begin
           if (No_BorrowUp==0) begin
            Digit<=4'd9; 
            BorrowUp<=1'b1;    end       
           else 
              No_BorrowDn <= 1'b1; // after this step its done. 
           end  
        else
          Digit<=Digit-1;
       end
       end 
  
   end
    end 
 assign Num=Num_in; 
endmodule 





