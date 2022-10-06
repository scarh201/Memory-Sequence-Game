module topHighScoreModule(userAddress, timeout, timerEnable, score1s, score10s, globalHighSignal, display10s, display1s, rst, clk);
input rst, clk;
input [5:0] userAddress; // from Auth Module
input [3:0] score10s, score1s; // new score values
input timeout, timerEnable;


output globalHighSignal; // 0 for "H", 1 for "G"
output [3:0] display10s, display1s;

wire [3:0] ramDataIn, ramDataOut;
wire readWrite;
wire [5:0] scoreAddress;

RAM_HIGHSCORE DUT_RAM_HIGHSCORE(scoreAddress, clk, ramDataIn, readWrite, ramDataOut);
highScoreModule DUT_highScoreSubModule(userAddress, timeout, timerEnable, score1s, score10s, globalHighSignal, display10s, display1s, rst, clk, scoreAddress, ramDataIn, readWrite, ramDataOut);

endmodule