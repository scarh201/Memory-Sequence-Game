module countTo500(timeout500, enable, rst, clk);
	input clk, rst, enable;
	output timeout500;
	reg timeout500;
	reg [8:0] count;

always@(posedge clk) begin
	if(rst==0) begin
		count<=0;
		timeout500<=0;
	end
	else begin
		if(enable==0) begin
			timeout500<=0;
		end
		else begin
			if(count==500) begin
				timeout500<=1;
				count<=0;
			end
			else begin
				count<=count+1;
				timeout500<=0;
			end
		end
	end
end
endmodule