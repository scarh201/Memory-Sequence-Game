module rngLFSR(rst, clk, rngDigit, rngFetchSignal);
	input rngFetchSignal, rst, clk;
	output [3:0] rngDigit;

	reg [15:0] rngInternal;
	reg [3:0] rngDigit;
	wire feedback = rngInternal[15];
	
	always@(posedge clk) begin
		if(rst==0) begin
			rngDigit<=4'b0000;
			rngInternal<=16'b1111111111111111;
		end
		else begin
			rngInternal[0]<=feedback;
			rngInternal[1]<=rngInternal[0];
			rngInternal[2]<=rngInternal[1] ^ feedback;
			rngInternal[3]<=rngInternal[2] ^ feedback;
			rngInternal[4]<=rngInternal[3];
			rngInternal[5]<=rngInternal[4] ^ feedback;			
			rngInternal[6]<=rngInternal[5];
			rngInternal[7]<=rngInternal[6];
			rngInternal[8]<=rngInternal[7];
			rngInternal[9]<=rngInternal[8];
			rngInternal[10]<=rngInternal[9];
			rngInternal[11]<=rngInternal[10];
			rngInternal[12]<=rngInternal[11];
			rngInternal[13]<=rngInternal[12];
			rngInternal[14]<=rngInternal[13];
			rngInternal[15]<=rngInternal[14];
			if(rngFetchSignal==1) begin
				rngDigit<={rngInternal[14], rngInternal[11], rngInternal[7], rngInternal[2]};
			end
		end
	end
endmodule

	