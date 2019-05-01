// $Id: $
// File name:   flex_counter.sv
// Created:     2/1/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: flex_counter
module flex_counter
#(
	NUM_CNT_BITS = 4)

(
	input wire clk, n_rst, clear, count_enable,
	input wire [NUM_CNT_BITS-1:0] rollover_val,
	output reg [NUM_CNT_BITS-1:0] count_out,
	output reg rollover_flag
);
	reg [NUM_CNT_BITS-1:0] count_next;
	reg next_rollflag;	
	always_ff @ (posedge clk, negedge n_rst)
	begin 
		if (!n_rst) begin
			count_out <= '0;
			rollover_flag <= '0;	//next state logic
		end
		else begin
			count_out <= count_next;
			rollover_flag <= next_rollflag;  
		end
	end

always_comb
begin
   if(clear == 1) begin
	count_next = 0;
	next_rollflag = 0;
	end
   else begin
	if(count_enable == 0)begin
		count_next = count_out;
		next_rollflag = rollover_flag;
	end
	else begin
		count_next = count_out + 1;
		next_rollflag = 0;
		if(count_out == rollover_val) begin
		count_next = 1;
		end
		if(count_out == rollover_val - 1) begin
		next_rollflag = 1;
		end
	end
   end
end	  


endmodule 