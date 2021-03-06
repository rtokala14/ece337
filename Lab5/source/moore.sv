// $Id: $
// File name:   moore.sv
// Created:     2/8/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: moore for 1101


module moore(
	input wire clk,
	input wire n_rst,
	input wire i,
	output reg o);


typedef	enum bit [2:0] {INITIAL, STATE_1, STATE_11, STATE_110, STATE_1101} stateType;
stateType state;
stateType next_state;

always_ff @ (posedge clk, negedge n_rst) begin
	if(n_rst == 0) begin
		state <= INITIAL;
	end
	else begin
		state <= next_state;
	end
end

always_comb begin

	next_state = state; //prevent latch
	case(state)
		INITIAL:
		begin
			if(i == 1) begin
				next_state = STATE_1;
			end
			else begin
				next_state = INITIAL;
			end
		end
		STATE_1:
		begin
			if(i == 1) begin
				next_state = STATE_11;
			end
			else begin
				next_state = STATE_1;
			end
		end
		STATE_11:
		begin
			if(i == 0) begin
				next_state = STATE_110;
			end
			else begin
				next_state = STATE_11;
			end
		end
		STATE_110:
		begin
			if(i == 1) begin
				next_state = STATE_1101;
			end
			else begin
				next_state = STATE_110;
			end
		end
		STATE_1101:
		begin
			if(i == 1) begin
				next_state = STATE_11;
			end
			else begin
				next_state = INITIAL;
			end
		end
	endcase
if(state == STATE_1101)begin
	 o = 1'b1;
end
else begin
	 o = 1'b0;
end
end

endmodule 
		