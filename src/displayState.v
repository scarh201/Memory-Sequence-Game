module displayState(rst, clk, displayState, levelNumber, speedNumber, numToFlash, noNumToFlash,GorH, score10s, score1s,timer10s, timer1s,display10s, display1s,disp0,disp1,disp2,disp3,disp4,disp5);
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
    output [4:0] disp0,disp1,disp2,disp3,disp4,disp5;
    reg [4:0] disp0,disp1,disp2,disp3,disp4,disp5;

    always @ (displayState)
        case(displayState)
        4'b0001:   begin  ///1.Reconfig Time : TIME ##   
                disp0=5'b10111 ; //23 -> " T "    
                disp1=5'b10010 ; //18 -> " I "
                disp2=5'b10100 ; //20 -> " M "
                disp3=5'b01110 ; //14 -> " E "
                disp4=timer10s ;
                disp5=timer1s;
        end
        4'b0010:   begin  //2.ReconfigSpeed : SPEED#
                disp0=5'b10110 ; //22 -> " S "    
                disp1=5'b10101 ; //21 -> " P "
                disp2=5'b01110 ; //14 -> " E "
                disp3=5'b01110 ; //14 -> " E "
                disp4=5'b01101 ; //13 -> " D "
                disp5=speedNumber;
        end
        4'b0011:   begin  //3.ReconfigLEvel ~ LEVEL#     
                disp0=5'b10011 ; //19 -> " L "    
                disp1=5'b01110 ; //14 -> " E "
                disp2=5'b11000 ; //24 -> " V "
                disp3=5'b01110 ; //14 -> " E "
                disp4=5'b10011 ; //19 -> " L "
                disp5=levelNumber;
        end
        4'b0100:   begin  //4.Standby/Game Start ~ left most either 99 or counted

    	     //if no num =0 to displayed num to flash (RNG)
	    //LEFT:RNG RIGHT MOST-TIMER
	     if(noNumToFlash==1'b0) begin
                disp0=numToFlash; //rng
			end 
				   //if no num =0 nothing should be displayed
			else begin
                disp0=5'b11001 ; //25 -> " - "
			end
                disp1=5'b11001; //25 -> " - "
                disp2=5'b11001; //25 -> " - "
                disp3=5'b11001; //25 -> " - "
                disp4=timer10s; 
                disp5=timer1s;

	    
        end
        4'b0101:   begin //5.GameOver ~ S##H## or S##G##      
		disp0=5'b10110 ; //22 -> " S "    
                disp1=score10s ; 
                disp2=score1s ; 

	    if(GorH == 1'b1)
                disp3=5'b10000; //16 -> " G "
            else
                disp3=5'b10001; //17 -> " H "

	        disp4= display10s; 
                disp5= display1s; 
        end
        default:   begin  //0.logged out (------)
                disp0=5'b11001 ; //25 -> " - "
                disp1=5'b11001 ; //25 -> " - "
                disp2=5'b11001 ; //25 -> " - "
                disp3=5'b11001 ; //25 -> " - "
                disp4=5'b11001 ; //25 -> " - " 
                disp5=5'b11001 ; //25 -> " - "
        end
        endcase
endmodule      
