module finalTopLevel(Button1, Button2, Button3, rst, clk, passSwitches, playSwitches, disp0, disp1, disp2, disp3, disp4, disp5, LoggedIn, LoggedOut, correctLED, incorrectLED);
input Button1, Button2, Button3, rst;
input clk;
input [3:0] passSwitches, playSwitches;

output [6:0] disp0, disp1, disp2, disp3, disp4, disp5;
output LoggedIn, LoggedOut, correctLED, incorrectLED;

wire Button1_Wire, Button2_Wire, Button3_Wire;
wire decrementTime10, incrementTime10; // timer to game controller signals
wire ReConfig, timerEnable, timeout; // timer to game controller signals
wire Passed, LogoutSignal;
wire mux;
wire [3:0] displayState;
wire [1:0] speedNumber, levelNumber;
wire [3:0] numToFlash, score10s, score1s, timer10s, timer1s, display10s, display1s;
wire noNumToFlash, GorH;
wire [5:0] Addr;

// Button Shaping Modules
buttonShaper DUT_button1(Button1, Button1_Wire, clk, rst); // Button1 used for Pass Enter during Auth and Pass Reset / rngFetch button during Game active state
buttonShaper DUT_button2(Button2, Button2_Wire, clk, rst); // Button2 used for inputting Player's values during Sequence Checking
buttonShaper DUT_button3(Button3, Button3_Wire, clk, rst); // Button3 used for transitioning between Reconfiguring States and Starting/Restarting the game

// authentication
Authentication DUT_Authentication(Button1_Wire, passSwitches, LoggedIn, LoggedOut, Passed, Addr, LogoutSignal, mux, clk, rst);

// gameController
topLevelGameController DUT_topLevelGameController(rst, clk, Button1_Wire, Button2_Wire, Button3_Wire, Passed, passSwitches, playSwitches, LogoutSignal, decrementTime10, incrementTime10, displayState, levelNumber, speedNumber, numToFlash, noNumToFlash, score10s, score1s, timerEnable, ReConfig, timeout, mux, Addr, correctLED, incorrectLED);

// timer
Timer DUT_topLvl_DigitTimer(rst, clk, ReConfig, timer1s, timer10s, timerEnable, Tens_BorrowUp,timeout,incrementTime10,decrementTime10);

// high score module
topHighScoreModule DUT_highscore(Addr, timeout, timerEnable, score1s, score10s, GorH, display10s, display1s, rst, clk);

// display
displayControl DUT_display(rst, clk, displayState, levelNumber, speedNumber, numToFlash, noNumToFlash,GorH, score10s, score1s,timer10s, timer1s,display10s, display1s,disp0,disp1,disp2,disp3,disp4,disp5);

endmodule