// $Id: $
// File name:   timer.sv
// Created:     2/18/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: timer block
`timescale 1ns / 10ps
module timer(
	     input 	 clk,
	     input 	 n_rst,
	     input 	 enable_timer,
	     input [3:0] data_size,
	     input [13:0] bit_period,
	     output 	 shift_strobe,
	     output 	 packet_done);

   //local parameter
   reg 		    local_enable1;

   reg 		    local_enable2;

   always_ff @(posedge clk, negedge n_rst) begin
      if(n_rst == 0) begin
	 local_enable1 <= 0;
	 local_enable2 <= 0;
      end

      else begin
	 local_enable1 <= enable_timer;
	 local_enable2 <= local_enable1;
      end
   end // always_ff @ (posedge clk, negedge n_rst)

   flex_counter #(14) count_10 (.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(local_enable2), .rollover_val(bit_period), .count_out(), .rollover_flag(shift_strobe));
   flex_counter #(4) count_9 (.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(shift_strobe), .rollover_val(data_size + 1'b1), .count_out(), .rollover_flag(packet_done));
endmodule 
