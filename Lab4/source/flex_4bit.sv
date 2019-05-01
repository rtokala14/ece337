// $Id: $
// File name:   flex_4bit.sv
// Created:     2/1/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: .
module flex_4bit(
	input wire clk, n_rst, clear, count_enable,
	input wire [3:0] rollover_val,
	output reg [3:0] count_out,
	output reg rollover_flag
);

flex_counter #(4) flex4 (.clk(clk), .n_rst(n_rst), .clear(clear), .count_enable(count_enable ),.rollover_val(rollover_val),.count_out(count_out), .rollover_flag(rollover_flag) );

endmodule 