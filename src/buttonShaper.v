module buttonShaper (Bin, Bout, clk, rst);
	input Bin;
	output Bout;
	input clk, rst;
	reg Bout;
	parameter INIT = 0, PULSE = 1, WAIT = 2;
	reg [1:0] State, NextState;
	
	always@(State, Bin) begin
			case (State)
				WAIT: begin
					Bout=1'b0;
					if (Bin==1'b1)
					NextState = INIT;
					else
					NextState = WAIT;
					end
				INIT: begin
					Bout=1'b0;
					if (Bin==1'b0)
					NextState = PULSE;
					else
					NextState = INIT;
					end
				PULSE: begin
					Bout=1'b1;
					NextState = WAIT;
					end
				default: begin
					Bout=1'b0;
					NextState=INIT;
					end
			endcase
	end
	always@(posedge clk) begin
		if (rst==1'b0)
			State <= INIT;
		else
			State <= NextState;
	end
endmodule
