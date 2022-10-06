// ECE 5440
// Mohammed Kassif 6092
// One_ms_lsfr
// counts to 50k/1 ms using lsfr
module One_ms_lfsr(clk, rst, enable,timeout);
  input clk, rst, enable;
  output timeout;
  reg timeout ;
  reg[15:0] LFSR;
  wire feedback = LFSR[15];

  always @(posedge clk)  begin
  timeout<=1'b0;

 if(rst==1'b0) begin
  LFSR <=16'd1; // no 0000 state.
  timeout<=1'b0;
 end
 else  begin
   if (enable<=1'b0) 
    timeout<=1'b0;  
   
   else begin
    if (LFSR == 16'b1100010000100110) begin //1100010000100110
     timeout<=1'b1;
     LFSR <=16'd1; 
    end 
   
   else begin
    LFSR[0] <= feedback;
    LFSR[1] <= LFSR[0];
    LFSR[2] <= LFSR[1] ^ feedback;
    LFSR[3] <= LFSR[2] ^ feedback;
    LFSR[4] <= LFSR[3];
    LFSR[5] <= LFSR[4] ^ feedback;
    LFSR[6] <= LFSR[5];
    LFSR[7] <= LFSR[6];
    LFSR[8] <= LFSR[7];
    LFSR[9] <= LFSR[8];
    LFSR[10] <= LFSR[9];
    LFSR[11] <= LFSR[10];
    LFSR[12] <= LFSR[11];
    LFSR[13] <= LFSR[12];
    LFSR[14] <= LFSR[13];
    LFSR[15] <= LFSR[14];
   end  
 end 
 end
  end

endmodule  