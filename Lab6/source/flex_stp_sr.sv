// $Id: $
// File name:   flex_stp_sr.sv
// Created:     2/8/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: serial to parallel


module flex_stp_sr#(NUM_BITS = 4, SHIFT_MSB = 1)(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire serial_in,
	output reg [NUM_BITS - 1: 0] parallel_out);
reg [NUM_BITS - 1: 0] next_parallelout; //declaring local var
always_ff @ (posedge clk, negedge n_rst) begin
	if (n_rst == 0) begin
		parallel_out <= '1;
	end
	else begin
		parallel_out <= next_parallelout;
	end
end 

always_comb begin
	if(shift_enable == 1) begin
		if(SHIFT_MSB == 0) begin
			next_parallelout =  {serial_in , parallel_out[NUM_BITS - 1:1]};
		end
		else begin
 			next_parallelout = {parallel_out[NUM_BITS - 2 : 0], serial_in};
		end
	end
	else begin
		next_parallelout = parallel_out;
	end
end
endmodule
			

