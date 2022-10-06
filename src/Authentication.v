//ECE 5440
//Authentication
//This module is used to verify and authenticate the user's password and the password is stored in a ROM.
module Authentication(PasswordEnter, PasswordDigit, LoggedIn, LoggedOut, Passed, Addr, LogoutSignal, mux, clk, rst);
    input PasswordEnter;
    input[3:0] PasswordDigit;
    input clk, rst, LogoutSignal, mux;  // mux is used to switch between ROM and RAM
    output[5:0] Addr;  // Current Address of RAM or ROM
    output Passed, LoggedIn, LoggedOut;
    reg Passed, LoggedIn, LoggedOut;
    reg [3:0] d1, d2, d3, d4;  // Digits for UserID
    reg[5:0] Addr, AddrBegin;  // Beginning of a player's address
    wire[3:0] q_ROM, q_RAM_Pass, q_ROM_Pass;  // Output of ROMs and RAM
    reg[3:0] counter;  // Counter
    reg sofarsogood; //sofarsogood
    reg wr; //Read Write for RAM
    reg[3:0] q;  // Result of ROM/RAM Password Digit at specific Addr
    parameter INIT = 0, DIGIT1 = 1, DIGIT2 = 2, DIGIT3 = 3, DIGIT4 = 4, C1 = 5, C2 = 6, C3 = 7, C4 = 8, SUCCESS1 = 18;
    parameter W1 = 9, W2 = 10, W3 = 11, PASS1 = 12, PASS2 = 13, PASS3 = 14, PASS4 = 15, PASS5 = 16, PASS6 = 17, VALIDATE = 19, SUCCESS2 = 20,  WAIT4 = 21;
    reg[4:0] State;
    ROM_UserID DUT_ROM_UserID(Addr, clk, q_ROM);
    ROM_Pass DUT_ROM_Pass(Addr, clk, q_ROM_Pass);
    RAM_Pass DUT_RAM_Pass(Addr, clk, 4'b0000, wr, q_RAM_Pass);
    always @(posedge clk) begin

	    if(rst == 1'b0)
		begin
		    wr <= 0;
                    sofarsogood <= 1'b1;
                    LoggedIn <= 1'b0;
                    LoggedOut <= 1'b1;
                    Passed <= 1'b0;
                    AddrBegin <= 5'b00000;
                    Addr <= 5'b00000;
                    counter <= 2'b00;
                    State <= INIT;
		end
	    else begin
		    if (mux)
		      q <= q_RAM_Pass;
		    else
		      q <= q_ROM_Pass;
		    
		    case(State)
                        INIT: begin
                          wr <= 0;
                          sofarsogood <= 1'b1;
                          LoggedIn <= 1'b0;
                          LoggedOut <= 1'b1;
                          Passed <= 1'b0;
                          AddrBegin <= 5'b00000;
                          Addr <= 5'b00000;
                          counter <= 2'b00;
                          State <= DIGIT1;
                        end
			DIGIT1:begin
			  if (PasswordEnter == 1) begin
			    d1 <= PasswordDigit;
			    State <= DIGIT2;
			  end
			  else
			    State <= DIGIT1;
			end
			DIGIT2:begin
			  if (PasswordEnter == 1) begin
			    d2 <= PasswordDigit;
			    State <= DIGIT3;
			  end
			  else
			    State <= DIGIT2;
			end
			DIGIT3:begin
			  if (PasswordEnter == 1) begin
			    d3 <= PasswordDigit;
			    State <= DIGIT4;
			  end
			  else
			    State <= DIGIT3;
			end
			DIGIT4:begin
			  if (PasswordEnter == 1) begin
			    d4 <= PasswordDigit;
			    State <= C1;
			  end
			  else
			    State <= 4;
			end
			C1:begin
                          counter <= 0;
                          if (AddrBegin > 40)
                            State <= INIT;
			  else if (d1 == q_ROM) begin
			    Addr <= Addr + 1;
			    State <= W1;
			  end
			  else begin
			    AddrBegin <= AddrBegin + 8;
			    State <= WAIT4;
			  end
			end
			C2:begin
                          counter <= 0;
			  if (d2 == q_ROM) begin
			    Addr <= Addr + 1;
			    State <= W2;
			  end
			  else begin
			    AddrBegin <= AddrBegin + 8;
			    State <= WAIT4;
			  end
			end
			C3:begin
                          counter <= 0;
			  if (d3 == q_ROM) begin
			    Addr <= Addr + 1;
			    State <= W3;
			  end
			  else begin
			    AddrBegin <= AddrBegin + 8;
			    State <= WAIT4;
			  end
			end
			C4:begin
                          counter <= 0;
			  if (d4 == q_ROM) begin
			    State <= SUCCESS1;
			  end
			  else begin
			    AddrBegin <= AddrBegin + 8;
			    State <= WAIT4;
			  end
			end
			SUCCESS1:begin
			  counter <= 0;
			  Addr <= AddrBegin;
			  State <= PASS1;
			end
			PASS1:begin
			  if (PasswordEnter == 1) begin
			    if (PasswordDigit != q)
			      sofarsogood <= 0;
			    Addr <= Addr + 1;
			    State <= PASS2;
			  end
			end
			PASS2:begin
			  if (PasswordEnter == 1) begin
			    if (PasswordDigit != q)
			      sofarsogood <= 0;
			    Addr <= Addr + 1;
			    State <= PASS3;
			  end
			end
			PASS3:begin
			  if (PasswordEnter == 1) begin
			    if (PasswordDigit != q)
			      sofarsogood <= 0;
			    Addr <= Addr + 1;
			    State <= PASS4;
			  end
			end
			PASS4:begin
			  if (PasswordEnter == 1) begin
			    if (PasswordDigit != q)
			      sofarsogood <= 0;
			    Addr <= Addr + 1;
			    State <= PASS5;
			  end
			end
			PASS5:begin
			  if (PasswordEnter == 1) begin
			    if (PasswordDigit != q)
			      sofarsogood <= 0;
			    Addr <= Addr + 1;
			    State <= PASS6;
			  end
			end
			PASS6:begin
			  if (PasswordEnter == 1) begin
			    if (PasswordDigit != q)
			      sofarsogood <= 0;
			    Addr <= Addr + 1;
			    State <= VALIDATE;
			  end
			end
			VALIDATE:begin
			  if (sofarsogood == 1)
			    State <= SUCCESS2;
			  else
			    State <= INIT;
			end
			SUCCESS2:begin
			  Addr <= AddrBegin;
			  LoggedIn <= 1'b1;
			  LoggedOut <= 1'b0;
			  Passed <= 1'b1;
			  if (LogoutSignal == 1)
			    State <= INIT;
			end
			W1:begin
			    counter = counter + 1;
			    if (counter > 3)
			      State <= C2;
			    else
			      State <= W1;
			end
			W2:begin
			    counter = counter + 1;
			    if (counter > 3)
			      State <= C3;
			    else
			      State <= W2;
			end
			W3:begin
			    counter = counter + 1;
			    if (counter > 3)
			      State <= C4;
			    else
			      State <= W3;
			end
			WAIT4:begin
			    counter = counter + 1;
			    Addr <= AddrBegin;
			    if (counter > 3) begin
			      State <= C1;
			    end
			    else
			      State <= WAIT4;
			end
			default:begin
		              sofarsogood <= 1'b1;
		              LoggedIn <= 1'b0;
		              LoggedOut <= 1'b1;
		              Passed <= 1'b0;
		              AddrBegin <= 5'b00000;
		              Addr <= 5'b00000;
		              wr <= 1'b0;
		              counter <= 2'b00;
		              State <= INIT;
			end
		    endcase
	    end
    end
endmodule