module highScoreModule(userAddress, timeout, timerEnable, score1s, score10s, globalHighSignal, display10s, display1s, rst, clk, scoreAddress, ramDataIn, readWrite, ramDataOut);
input rst, clk;
input [5:0] userAddress; // from Auth Module
input [3:0] score10s, score1s; // new score values
input timeout, timerEnable;
input [3:0] ramDataOut;


output globalHighSignal; // 0 for "H", 1 for "G"
output [3:0] display10s, display1s; // values to display to the rightmost Displays when the Game is Over
output [3:0] ramDataIn;
output [5:0] scoreAddress;
output readWrite;


reg readWrite;
reg globalHighSignal;
reg [5:0] scoreAddress;
reg [3:0] ramDataIn;
reg [3:0] temp10s, temp1s;
reg [3:0] display1s, display10s;

reg [3:0] countState;

reg [2:0] State;
parameter WaitForGameStart=0, WaitForGameOver=1, DisplayGuest=2, CheckHigh=3, UpdateHigh=4, CheckGlobal=5, UpdateGlobal=6;


always@(posedge clk) begin
	if(rst==0) begin
		scoreAddress<=0;
		globalHighSignal<=0;
		display10s<=0;
		display1s<=0;
		readWrite<=0;
		ramDataIn<=0;
		temp10s<=0;
		temp1s<=0;
	end
	else begin
		case(State)
		WaitForGameStart: begin
			if(timerEnable==1) begin
				State<=WaitForGameOver;
				display10s<=0;
				display1s<=0;
			end
		end
		WaitForGameOver: begin
			if(timeout==1) begin
				scoreAddress<=userAddress;
				countState<=0;
				globalHighSignal<=0;
				if(userAddress==40) begin // checks if user/guest is logged in
					State<=DisplayGuest;
				end
				else begin
					State<=CheckHigh;
				end
			end
		end
		DisplayGuest: begin
			countState<=countState+1;
			globalHighSignal<=1;
			if(countState==4) begin // allow time for value to be fetched
				display10s<=ramDataOut; // ramDataOut should be the Global high value for 10s
			end
			if(countState==5) begin
				scoreAddress<=scoreAddress+1;
			end
			if(countState==10) begin // allow time for value to be fetched
				display1s<=ramDataOut; // ramDataOut should be the Global high value for 1s
				State<=WaitForGameStart; // waits for the Next Game to Begin
			end
		end
		CheckHigh: begin
			countState<=countState+1;
			if(countState==4) begin
				temp10s<=ramDataOut;
			end
			if(countState==5) begin
				scoreAddress<=scoreAddress+1;
			end
			if(countState==10) begin
				temp1s<=ramDataOut;
			end
			if(countState==11) begin
				if(score10s>=temp10s) begin
					if(score1s>=temp1s) begin
						State<=UpdateHigh; // updates high score if appropriate
						countState<=0;
						scoreAddress<=userAddress;
					end
					else begin
						display10s<=temp10s; // displays old HighScore 10s
						display1s<=temp1s; // displays old high score 1s
						State<=WaitForGameStart;
					end
				end
				else begin
					display10s<=temp10s;
					display1s<=temp1s;
					State<=WaitForGameStart;
				end
			end
		end
		UpdateHigh: begin
			countState<=countState+1;
			if(countState==4) begin
				ramDataIn<=score10s;
			end
			if(countState==5) begin
				readWrite<=1;
			end
			if(countState==6) begin
				readWrite<=0;
			end
			if(countState==7) begin
				scoreAddress<=scoreAddress+1;
				ramDataIn<=score1s;
			end
			if(countState==12) begin
				readWrite<=1;
			end
			if(countState==13) begin
				readWrite<=0;
			end
			if(countState==15) begin
				scoreAddress<=40; // address of Global high 10s value
				State<=CheckGlobal;
				countState<=0;
				globalHighSignal<=1; // set display for G
			end
		end
		CheckGlobal: begin
			countState<=countState+1;
			if(countState==4) begin
				temp10s<=ramDataOut;
			end
			if(countState==5) begin
				scoreAddress<=scoreAddress+1;
			end
			if(countState==10) begin
				temp1s<=ramDataOut;
			end
			if(countState==11) begin
				if(score10s>=temp10s) begin
					if(score1s>=temp1s) begin
						State<=UpdateGlobal; // updates global score if appropriate
						countState<=0;
						scoreAddress<=40;
						display10s<=score10s;
						display1s<=score1s;
					end
					else begin
						display10s<=temp10s; // displays old global high 10s
						display1s<=temp1s; // displays old global high 1s
						State<=WaitForGameStart;
					end
				end
				else begin
					display10s<=temp10s;
					display1s<=temp1s;
					State<=WaitForGameStart;
				end
			end
		end
		UpdateGlobal: begin
			countState<=countState+1;
			if(countState==4) begin
				ramDataIn<=score10s;
			end
			if(countState==5) begin
				readWrite<=1;
			end
			if(countState==6) begin
				readWrite<=0;
			end
			if(countState==7) begin
				scoreAddress<=scoreAddress+1;
				ramDataIn<=score1s;
			end
			if(countState==12) begin
				readWrite<=1;
			end
			if(countState==13) begin
				readWrite<=0;
			end
			if(countState==14) begin
				State<=WaitForGameStart;
			end
		end
		endcase
	end
end

endmodule