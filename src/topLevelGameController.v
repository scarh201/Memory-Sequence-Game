module topLevelGameController(rst, clk, Button1_Wire, Button2_Wire, Button3_Wire, loggedInSignalInput, passInput, playInput, logOutSignalOutput, decrementTime10, incrementTime10, displayState, levelNumber, speedNumber, numToFlash, noNumToFlash, score10s, score1s, timerEnable, ReConfig, timeout, mux, passBeginAddress, correctLED, incorrectLED);

input rst, clk;
input Button1_Wire, Button2_Wire, Button3_Wire;
input loggedInSignalInput;
input [3:0] passInput, playInput;
input [5:0] passBeginAddress;
input timeout;

output [3:0] numToFlash;
output logOutSignalOutput;
output decrementTime10, incrementTime10;
output [3:0] displayState;
output [1:0] speedNumber, levelNumber;
output noNumToFlash;
output [3:0] score10s, score1s;
output timerEnable, ReConfig;
output mux;
output correctLED, incorrectLED;


wire timerDisplayEnable, timerWaitEnable;
wire timeoutDisplay, timeoutWait;
wire [3:0] rngDigit;
wire rngFetchSignal;
wire [3:0] ramDigitWrite, ramDigit;
wire [4:0] ramDigitAddress;
wire readWriteSignal;



rngLFSR DUT_rngLFSR(rst, clk, rngDigit, rngFetchSignal);
gameStateAndScoreControl DUT_gameStateAndScoreControl(rst, clk, Button1_Wire, Button2_Wire, Button3_Wire, loggedInSignalInput, rngFetchSignal, rngDigit, playInput, passInput, logOutSignalOutput, decrementTime10, incrementTime10, displayState, levelNumber, speedNumber, numToFlash, noNumToFlash, score10s, score1s, timerEnable, ReConfig, speedMultiplier, timerDisplayEnable, timerWaitEnable, timeout, timeoutDisplay, timeoutWait, mux, passBeginAddress, correctLED, incorrectLED, ramDigitAddress, ramDigitWrite, readWriteSignal, ramDigit); 
timerNoFlash DUT_timerNoFlash(timeoutWait, timerWaitEnable, rst, clk);
timerSequenceFlash DUT_timerSequenceFlash(timeoutDisplay, speedMultiplier, timerDisplayEnable, rst, clk);
RAM_SEQUENCE DUT_RAM_SEQUENCE(ramDigitAddress, clk, ramDigitWrite, readWriteSignal, ramDigit);

endmodule