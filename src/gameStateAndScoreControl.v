module gameStateAndScoreControl(rst, clk, Button1_Wire, Button2_Wire, Button3_Wire, loggedInSignalInput, rngFetchSignal, rngDigit, playInput, passInput, logOutSignalOutput, decrementTime10, incrementTime10, displayState, levelNumber, speedNumber, numToFlash, noNumToFlash, score10s, score1s, timerEnable, ReConfig, speedMultiplier, timerDisplayEnable, timerWaitEnable, timeout, timeoutDisplay, timeoutWait, mux, passBeginAddress, correctLED, incorrectLED, ramDigitAddress, ramDigitWrite, readWriteSignal, ramDigit); 
input rst, clk;
input Button1_Wire, Button2_Wire, Button3_Wire; // Shaped Button Signals
input loggedInSignalInput; // (from Authorization Module) ~ after user inputs successful login signal, high pulse from this signal is sent
input [3:0] rngDigit, playInput, passInput;
input timeoutDisplay, timeoutWait, timeout;
input [5:0] passBeginAddress;
input [3:0] ramDigit;


output logOutSignalOutput; // to Auth Module ~ indicates B2 is pressed in Standby/GameOver state and the user should log out
output decrementTime10, incrementTime10; // Output signals to the Timer Scaling module
output [3:0] displayState; // Output to the Display Module ~ controls what Letters/Numbers will be displayed to the 7 seg displays
output [1:0] speedNumber, speedMultiplier; // Output (and internal value) to the 7seg Dislay Control. This value Should be displayed on the rightmost 7seg display during the "Speed" State
output [1:0] levelNumber; // Output (and internal value) to the 7seg Dislay Control. This value Should be displayed on the rightmost 7seg display during the "Level" State
output [3:0] numToFlash; // Output to the 7seg Display control. This number should be flashed onto the leftmost 7seg display
output noNumToFlash; // Output to the 7seg Display control. if this signal is high, do not display a value to the leftmost 7seg
output [3:0] score10s, score1s; // Output to Score Module and 
output timerEnable, ReConfig;
output timerDisplayEnable, timerWaitEnable; // enable signals for flashing the sequence numbers 
output rngFetchSignal;
output mux;
output correctLED, incorrectLED;
output [4:0] ramDigitAddress;
output [3:0] ramDigitWrite;
output readWriteSignal;

reg logOutSignalOutput, decrementTime10, incrementTime10, noNumToFlash, timerEnable, ReConfig, timerDisplayEnable, timerWaitEnable, rngFetchSignal, correct;
reg [1:0] speedNumber, levelNumber, speedMultiplier;
reg [2:0] sequenceLength, scoreMultiplier;
reg [4:0] ramDigitAddress;
reg [3:0] ramDigitWrite;
reg readWriteSignal;
reg [3:0] displayState, numToFlash, score10s, score1s;
reg [3:0] countState, countDigit;
reg mux, passReadWrite;
reg [3:0] passOutput;
reg [5:0] passAddress;
reg correctLED, incorrectLED;

// reg [3:0] ramDigit;

reg [4:0] State;
parameter LoggedOut=0, ReconfigTime=1, SendBackTime=2, ReconfigSpeed=3, ReconfigLevel=4, Standby=5, GameActive=6, GameOver=7, Wait1=8, Wait2=9, Wait3=10, Wait4=11, rngFetch=12, DisplayNum=13, DisplayWait=14, CheckPlayLoad=15, CheckInput=16, UpdateScore=17, PassReset=18, WritePass=19, Wait5=20, Wait6=21, Wait7=22, Wait8=23, rngWrite=24;

RAM_Pass DUT_RAM_Pass(passAddress, clk, passOutput, passReadWrite, q_RAM_Pass);

always@(posedge clk) begin
	if(rst==0) begin
		State<=LoggedOut;
		logOutSignalOutput<=0;
		decrementTime10<=0;
		incrementTime10<=0;
		timerEnable<=0;
		displayState<=0;
		speedNumber<=1;
		speedMultiplier<=3;
		levelNumber<=1;
		sequenceLength<=3;
		scoreMultiplier<=1;
		numToFlash<=0;
		noNumToFlash<=1;
		score10s<=0;
		score1s<=0;
		ReConfig<=0;
		timerDisplayEnable<=0;
		timerWaitEnable<=0;
		rngFetchSignal<=0;
		readWriteSignal<=0;
		ramDigitAddress<=0;
		ramDigitWrite<=0;
		countState<=0;
		countDigit<=1;
		correct<=0;
		mux<=0;
		passReadWrite<=0;
		incorrectLED<=0;
		correctLED<=0;
	end
	else begin
		case(State)
// LoggedOut State is where the module initializes. Pressing reset or the log out button (when LoggedIn) will take us back here
// display should be empty (1 loaded to all 7seg displays)
		LoggedOut: begin
			displayState<=0;
			speedNumber<=1;
			speedMultiplier<=3;
			levelNumber<=1;
			sequenceLength<=3;
			scoreMultiplier<=1;
			score10s<=0;
			score1s<=0;
			if(loggedInSignalInput==1) begin
				State<=ReconfigTime;
				logOutSignalOutput<=0;
			end
			else begin
				State<=LoggedOut;
			end
		end
// ReconfigTime State allows users to increment the time up or down by 10 seconds. Timer will be initialized at 09 sec. (timer can also be initialized to 99sec, the same logic will apply) 
// Pressing Button2 increments the Time by 10sec (assuming the timer is not at max, 99sec ~ if statement)
// Pressing Button1 decrements the Time by 10sec (assuming the timer is not at min, 09sec ~ if statement)
// PRessing Button3 enters the Time value and moves onto Reconfiguring the Speed of the game
// display should have "tIME" displayed to the four leftmost displays. Right two Displays should be the Timer Values
		ReconfigTime: begin
			displayState<=1;
			ReConfig<=1;
			if(Button1_Wire==1) begin
				decrementTime10<=1;
				State<=SendBackTime;
			end
			if(Button2_Wire==1) begin
				incrementTime10<=1;
				State<=SendBackTime;
			end
			if(Button3_Wire==1) begin
				State<=ReconfigSpeed;
			end
		end
// SendBackTime allows the increment and decrement signals to only pulse for one clock cycle
		SendBackTime: begin
			decrementTime10<=0;
			incrementTime10<=0;
			State<=ReconfigTime;
		end
// ReconfigSpeed controls the length of the display for each sequence. Uses an internal counter 
// Pressing Button1 Decrements the speed by 1 (out of 3 different speeds) ~ only if Speed is 2 or 3
// Pressing Button2 Increments the speed by 1 (out of 3 different speeds) ~ only if Speed is 1 or 2
// Pressing Button3 enters the Speed Value and moves onto Reconfiguring the Level of the game
// display should have "SPEED" displayed on the five leftmost displays. Rightmost Display should show the value of signal "speedNumber"
// Speed 1: 1.5sec/Flash
// Speed 2: 1.0sec/Flash
// Speed 3: 0.5sec/Flash
		ReconfigSpeed: begin
			displayState<=2;
			ReConfig<=0;
			if(Button1_Wire==1) begin
				if(speedNumber==1) begin

				end
				else begin
					speedNumber<=speedNumber - 1;
					speedMultiplier<=speedMultiplier + 1;
				end
			end
			if(Button2_Wire==1) begin
				if(speedNumber==3) begin

				end
				else begin
					speedNumber<=speedNumber + 1;
					speedMultiplier<=speedMultiplier - 1;
				end
			end
			if(Button3_Wire==1) begin
				State<=ReconfigLevel;
			end
		end
// ReconfigLevel controls the level 
// Pressing Button1 decrements the level by 1 (out of 3 different levels) ~ only if the Level is 2 or 3
// Pressing Button2 increments the level by 1 (out of 3 different levels) ~ only if the Level is 1 or 2
// Pressing Button3 enters the Level Value and moves onto Standby the Level of the game
// display should have "LEVEL" displayed on the five leftmost displays. Rightmost Display should show the value of signal "levelNumber"
// Level 1: Sequence Length: 3, Score Multiplier: 1x
// Level 2: Sequence Length: 4, Score Multiplier: 3x
// Level 3: Sequence Length: 5, Score Multiplier: 5x 
		ReconfigLevel: begin
			displayState<=3;
			if(Button1_Wire==1) begin
				if(levelNumber==1) begin

				end
				else begin
					levelNumber<=levelNumber - 1;
					sequenceLength<=sequenceLength - 1;
					scoreMultiplier<=scoreMultiplier - 2;
				end
			end
			if(Button2_Wire==1) begin
				if(levelNumber==3) begin

				end
				else begin
					levelNumber<=levelNumber + 1;
					sequenceLength<=sequenceLength + 1;
					scoreMultiplier<=scoreMultiplier + 2;
				end
			end
			if(Button3_Wire==1) begin
				State<=Standby;
			end
		end
// Standby State should be moment just before the Game Begins. User may press B3 to begin the Game
// Timer value should be displayed to the two rightmost Numbers in preparation for the Game
// Note: displayState,=4 accounts for both Standby and GameActive state
		Standby: begin
			displayState<=4;
			if(Button3_Wire==1) begin
				State<=Wait1;
				timerEnable<=1;
			end
			if(Button2_Wire==1) begin
				logOutSignalOutput<=1;
				State<=Wait3;
			end
			if(Button1_Wire==1) begin
				mux<=1;
				State<=PassReset;
				score10s<=0;
				score1s<=0;
				levelNumber<=1;
				speedNumber<=1;
				speedMultiplier<=3;
				sequenceLength<=3;
				scoreMultiplier<=1;
				ramDigitAddress<=0;
				countDigit<=1;
				passAddress<=passBeginAddress;
			end
		end
// Wait1 and Wait2 are simply buffer states to ensure no signal overlap between states
		Wait1: begin
			State<=Wait2;	
		end
		Wait2: begin
			State<=GameActive;
		end
// GameActive State indicates that the game may be played
// numToFlash should be displayed on the leftmost 7seg
// when the signal noNumToFlash is high (1), make no display show for the sequence
		GameActive: begin
			if(Button1_Wire==1) begin
				State<=rngFetch; 
				countState<=0; 
				countDigit<=1; 
				ramDigitAddress<=0; 
				correctLED<=0;
				incorrectLED<=0;
			end
			if(timeout==1) begin
				State<=GameOver;
				incorrectLED<=0;
				correctLED<=0;
			end
		end
// rngFetch + DisplayNum + DisplayWait are States responsible for flashing the sequence to the 7seg displays
// in rngFetch, the device fetches an rng value from the rngModule. For input verification, this value is then written to RAM. Once the digit has been received, the State transitions to DisplayNum
// In DisplayNum, noNumToFlash remains at 0 until there is timeoutSignal from the Timer corresponding to the Game Speed. During this time, the rngDigits will be displayed to the 7seg display
// in DisplayWait, there is no value on the leftmost display during the duration of this time. At the end of this State, the State loops back to rngFetch if there are more numbers to fetch.
// if the final digit is displayed, the Game moves onto allowing the user to input the sequence back in.
		rngFetch: begin
			if(timeout==1) begin
				State<=GameOver;
				incorrectLED<=0;
				correctLED<=0;
			end
			countState<=countState+1;
			if(countState==1) begin
				rngFetchSignal<=1;
			end
			else if(countState==2) begin
				rngFetchSignal<=0;
			end
			else if(countState==4) begin
				numToFlash<=rngDigit;
			end
			else if(countState==15) begin 
				State<=rngWrite;
				countState<=0;
			end
		end
		rngWrite: begin
				countState<=countState+1;
				if(countState==1) begin
					ramDigitWrite<=numToFlash;
					readWriteSignal<=1;
					if(countDigit==1) begin
						ramDigitAddress<=0;
					end
					else begin
						ramDigitAddress<=ramDigitAddress+1;
					end	
				end
			//	else if(countState==2) begin
			//		readWriteSignal<=1;
			//	end
				else if(countState==15) begin
					readWriteSignal<=0;
					timerDisplayEnable<=1;
					noNumToFlash<=0;
					State<=Wait5;
				end
		end
		Wait5: begin
			State<=Wait6;
		end
		Wait6: begin
			State<=DisplayNum;
		end
		DisplayNum: begin
			if(timeoutDisplay==1) begin
				State<=Wait7;
				timerDisplayEnable<=0;
				noNumToFlash<=1; /////// back to 1
				timerWaitEnable<=1;
			end
			else begin
				State<=DisplayNum;
			end
		end
		Wait7: begin
			State<=Wait8;
		end
		Wait8: begin
			State<=DisplayWait;
		end
		DisplayWait: begin // temporary pause after the sequence is flashed
			if(timeoutWait==1) begin
				timerWaitEnable<=0;
				if(countDigit==sequenceLength) begin
					State<=CheckPlayLoad;
					countDigit<=1;
					countState<=0;
					ramDigitAddress<=0;
					correct<=1;
				end
				else begin
					countState<=0;
					State<=rngFetch;
					countDigit<=countDigit+1;
				end
			end
		end
// Once the sequence has been flashed, the user must input back 
		CheckPlayLoad: begin
			if(timeout==1) begin
				State<=GameOver;
			end
			if(Button2_Wire==1) begin
				State<=CheckInput;
				countState<=0;
			end
		end
		CheckInput: begin
			countState<=countState+1;
			if(countState==1) begin
				if(countDigit==1) begin
					ramDigitAddress<=0;
				end
				else begin
					ramDigitAddress<=ramDigitAddress+1;
				end
			end
			else if(countState==13) begin
				if(playInput==ramDigit) begin

				end
				else begin
					correct<=0;
				end
			end
			else if(countState==15) begin
				if(countDigit==sequenceLength) begin
					State<=UpdateScore;
					countState<=0;
				end
				else begin
					countDigit<=countDigit+1;
					State<=CheckPlayLoad;
				end
			end

		end
		UpdateScore: begin
			countState<=countState+1;
			if(correct==0) begin
				State<=GameActive;
				incorrectLED<=1;
			end
			else begin
				correctLED<=1;
				if(countState==scoreMultiplier) begin
					State<=GameActive;
				end
				else begin
					if(score1s==9) begin
						score1s<=0;
						score10s<=score10s+1;
					end
					else begin
						score1s<=score1s+1;
					end
				end
			end
		end
// GameOver State indicates that the Game is over
		GameOver: begin
			displayState<=5;
			timerEnable<=0;
			if(Button3_Wire==1) begin
				State<=ReconfigTime;
				score10s<=0;
				score1s<=0;
				levelNumber<=1;
				speedNumber<=1;
				speedMultiplier<=3;
				sequenceLength<=3;
				scoreMultiplier<=1;
				ramDigitAddress<=0;
				
			end
			if(Button2_Wire==1) begin
				State<=Wait3;
				logOutSignalOutput<=1;
			end
			if(Button1_Wire==1) begin
				mux<=1;
				State<=PassReset;
				score10s<=0;
				score1s<=0;
				levelNumber<=1;
				speedNumber<=1;
				speedMultiplier<=3;
				sequenceLength<=3;
				scoreMultiplier<=1;
				ReConfig<=1;
				ramDigitAddress<=0;
				countDigit<=1;
				passAddress<=passBeginAddress;
			end
		end
		PassReset: begin
			if(Button1_Wire) begin
				State<=WritePass;
				passOutput<=passInput;
				countState<=0;
			end
		end
		WritePass: begin
			countState<=countState+1;
			if(countState==0) begin
				if(countDigit==1) begin
					passAddress<=passBeginAddress;
				end
				else begin
					passAddress<=passAddress+1;
				end
			end
			if(countState==5) begin
				passReadWrite<=1;
			end
			if(countState==6) begin
				passReadWrite<=0;
			end
			if(countState==7) begin
				if(countDigit==6) begin
					State<=ReconfigTime;
				end
				else begin
					State<=PassReset;
					countDigit<=countDigit+1;
				end
			end
		end
// Wait3 and Wait4 are used as buffer states to allow the user to log out without accidentally logging back in
		Wait3: begin
			State<=Wait4;	
			logOutSignalOutput<=0;
		end
		Wait4: begin
			State<=LoggedOut;
		end
		default: begin
		State<=LoggedOut;
		logOutSignalOutput<=0;
		timerEnable<=0;
		displayState<=0;
		speedNumber<=1;
		speedMultiplier<=3;
		levelNumber<=1;
		sequenceLength<=3;
		scoreMultiplier<=1;
		numToFlash<=0;
		noNumToFlash<=1;
		score10s<=0;
		score1s<=0;
		decrementTime10<=0;
		incrementTime10<=0;
		ReConfig<=0;
		timerDisplayEnable<=0;
		timerWaitEnable<=0;
		rngFetchSignal<=0;
		readWriteSignal<=0;
		ramDigitAddress<=0;
		ramDigitWrite<=0;
		countState<=0;
		countDigit<=1;
		correct<=0;
		mux<=0;
		passReadWrite<=0;
		correctLED<=0;
		incorrectLED<=0;
		end
		endcase
	end
end

endmodule
