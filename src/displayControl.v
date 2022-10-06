module displayControl(rst, clk, displayState, levelNumber, speedNumber, numToFlash, noNumToFlash,GorH, score10s, score1s,timer10s, timer1s,display10s, display1s,disp0,disp1,disp2,disp3,disp4,disp5);
    input rst,clk;
    input [3:0] displayState; // Output to the Display Module ~ controls what Letters/Numbers will be displayed to the 7 seg displays
    input [1:0] speedNumber; // Output (and internal value) to the 7seg Dislay Control. This value Should be displayed on the rightmost 7seg display during the "Speed" State
    input [1:0] levelNumber; // Output (and internal value) to the 7seg Dislay Control. This value Should be displayed on the rightmost 7seg display during the "Level" State
    input [3:0] numToFlash; // Output to the 7seg Display control. This number should be flashed onto the leftmost 7seg display
    input noNumToFlash; // Output to the 7seg Display control. if this signal is high, do not display a value to the leftmost 7seg
    input [3:0] score10s, score1s; // Output to Score Module and  
    input [3:0] timer10s, timer1s; // Output to Timer Module and 
    input [3:0] display10s, display1s; // Output Highscore  Module and 
    input GorH; 
    output [6:0] disp0,disp1,disp2,disp3,disp4,disp5;
    wire [4:0] dp0,dp1,dp2,dp3,dp4,dp5;

	displayState displayState_1(rst, clk, displayState, levelNumber, speedNumber, numToFlash, noNumToFlash,GorH, score10s, score1s,timer10s, timer1s,display10s, display1s,dp0,dp1,dp2,dp3,dp4,dp5);
	decoder decoder_disp0(dp0,disp0);
	decoder decoder_disp1(dp1,disp1);
	decoder decoder_disp2(dp2,disp2);
	decoder decoder_disp3(dp3,disp3);
	decoder decoder_disp4(dp4,disp4);
	decoder decoder_disp5(dp5,disp5);

endmodule
