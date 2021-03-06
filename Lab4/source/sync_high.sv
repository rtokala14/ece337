// $Id: $
// File name:   sync_high.sv
// Created:     1/27/2019ls

// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: verify sync_high for lab1
module sync_high(
	input wire clk,
	input wire n_rst,
	input wire async_in,
	output reg sync_out);

reg sync_out1;
always_ff @(posedge clk, negedge n_rst)
begin
	if(n_rst==0)
	  sync_out1 <= 1'b1;
	else
	  sync_out1 <= async_in;
end

always_ff @(posedge clk, negedge n_rst)
begin
	if(n_rst==0)
	  sync_out <= 1'b1;
	else
	  sync_out <= sync_out1;
end
endmodule
	