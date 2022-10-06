module timerSequenceFlash(timeout, speedMultiplier, enable, rst, clk);
input rst, clk, enable;
input [1:0] speedMultiplier;
output timeout;
wire time50000, time500;

One_ms_lfsr DUT_oneMillisec(clk, rst, enable,time50000);
countTo500 speed_countTo500(time500, time50000, rst, clk);
timerMultiplier speed_speedMultiplier(timeout, speedMultiplier, time500, rst, clk);

endmodule