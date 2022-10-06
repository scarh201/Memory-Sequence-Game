// ECE 5440
// LIL ENGINEERS
// OneSecTimer
// Top level module for the 1 second timer. outputs a pulse every second
module OneSecTimer (clk,rst,enable,OneSec);
input clk, rst, enable;
output OneSec;
wire OneSec,timeout,out_100;
wire ms_one,hundred;

  One_ms_lfsr One_ms_lfsr_1(clk, rst, enable,timeout);
 
  CountTo100 CountTo100_2 (clk,rst,ms_one,out_100);
  
  CountTo10 CountTo10_3 (clk,rst,hundred,OneSec);

assign ms_one = timeout;
assign hundred= out_100;

endmodule 
