module timerNoFlash(timeout, enable, rst, clk);
input rst, clk, enable;
output timeout;
wire time50000;

One_ms_lfsr speed_millisec(clk, rst, enable, time50000);
countTo500 speed_countTo500(timeout, time50000, rst, clk);


endmodule 