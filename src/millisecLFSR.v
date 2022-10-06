module millisecLFSR(timeout, enable, rst, clk);
input clk, rst, enable;
output timeout;
reg timeout;
reg [15:0] LFSR;

always@(posedge clk) begin
	if(rst==0) begin
		LFSR<=16'b1111111111111111;
		timeout<=0;
	end
	else begin
		if(enable==1) begin
			if(LFSR==16'b1101101101101100) begin
				LFSR<=16'b1111111111111111;
				timeout<=1;
			end
			else begin
				LFSR[0]<=LFSR[15];
				LFSR[1]<=LFSR[0];
				LFSR[2]<=LFSR[1] ^ LFSR[15];
				LFSR[3]<=LFSR[2] ^ LFSR[15];
				LFSR[4]<=LFSR[3];
				LFSR[5]<=LFSR[4] ^ LFSR[15];
				LFSR[6]<=LFSR[5];
				LFSR[7]<=LFSR[6];
				LFSR[8]<=LFSR[7];
				LFSR[9]<=LFSR[8];
				LFSR[10]<=LFSR[9];
				LFSR[11]<=LFSR[10];
				LFSR[12]<=LFSR[11];
				LFSR[13]<=LFSR[12];
				LFSR[14]<=LFSR[13];
				LFSR[15]<=LFSR[14];
				timeout<=0;
			end
		end
	end
end

endmodule