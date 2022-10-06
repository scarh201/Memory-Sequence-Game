//ECE 5440
//Lil Engineers
// Timer module 
// combination of two DigitTimers + Time Scaling module + OneSecTimer. 
//
module Timer(rst, clk, ReConfig, Ones_Digit, Tens_Digit, enable, Tens_BorrowUp,Ones_NoBorrowDn,increment,decrement);
 
 input clk, rst;
 input ReConfig; // needs to remain high will inc/decrementing 
 input enable; // high signal means the one sec timer will start pusling

 input increment,decrement; // input from game controller 
 output Tens_BorrowUp;   // wil be left to float
 output Ones_NoBorrowDn; //timeout signal for when timer is finished 
 wire   Tens_BorrowUp, Ones_NoBorrowDn, Tens_NoBorrowDn;

 output [3:0] Ones_Digit, Tens_Digit; // output to the 7 seg display module 
 wire [3:0] Ones_Digit, Tens_Digit;
 wire [3:0] Num,Num_in; // input from scaling module. this will be starting value for tens place. ones place is hardcoded to 9

 wire  BorrowUp_T2O; //  intermediate wire between from Ten to One digit timers
 
 OneSecTimer OneSecTimer_1 (clk,rst,enable,OneSec); // OnesSec pulses every one second
 Time_Scaling Time_Scaling_1 (rst,clk,increment,decrement,Num);
 DigitTimer DigitTImer_2 (rst, clk, ReConfig,4'd9 ,Ones_Digit, BorrowUp_T2O, OneSec, Tens_NoBorrowDn,Ones_NoBorrowDn); //ones 
 DigitTimer DigitTimer_1 (rst, clk, ReConfig,Num_in ,Tens_Digit, Tens_BorrowUp, BorrowUp_T2O,   1'b1, Tens_NoBorrowDn); // tens 

 
assign Num_in = Num;
 
endmodule 
