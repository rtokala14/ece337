// $Id: $
// File name:   sr_9bit.sv
// Created:     2/20/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: sr_9bit

module sr_9bit(
	       input wire 	clk,
	       input wire 	n_rst,
	       input wire 	shift_strobe,
	       input wire 	serial_in,
	       output reg [7:0] packet_data,
	       output reg 	stop_bit);
   reg [8:0] 			parallel_out;
   flex_stp_sr #(.NUM_BITS(9), .SHIFT_MSB(0)) sr9 (
						   .clk(clk),
						   .n_rst(n_rst),
						   .serial_in(serial_in),
						   .shift_enable(shift_strobe),
						   .parallel_out(parallel_out));
   always_comb begin
      packet_data = parallel_out[7:0];
      stop_bit = parallel_out[8];
   end
endmodule // sr_9bit

   
