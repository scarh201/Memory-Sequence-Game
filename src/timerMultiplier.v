
module timerMultiplier(timeout, speedMultiplier, enable, rst, clk);
input clk, rst, enable;
input [1:0] speedMultiplier;
output timeout;
reg timeout;
reg [2:0] count;

always@(posedge clk) begin
	if(rst==0) begin
		count<=0;
		timeout<=0;
	end
	else begin
		if(enable==0) begin
			timeout<=0;
		end
		else begin
			if(count==speedMultiplier) begin
				timeout<=1;
				count<=0;
			end
			else begin
				count<=count+1;
				timeout<=0;
			end
		end
	end
end

endmodule 