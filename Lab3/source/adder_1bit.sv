// $Id: $
// File name:   adder_1bit.sv
// Created:     1/18/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: adder_1bit
`timescale 1ns / 100ps

module adder_1bit(
	input wire a,
	input wire b,
	input wire carry_in,
	output wire sum,
	output wire carry_out);
	
	//assign carry_in = a & b;
	assign sum = carry_in ^(a ^ b);
	assign carry_out = ((!carry_in) & b & a) | (carry_in & (b | a));
   always @(a)
     begin
	assert((a == 1'b1) || (a == 1'b0))
	else $error("Input 'a' of component is not a difital logic value");
     end
   always @(a,b,carry_in)
     begin
	#(2) assert( ( (a + b + carry_in) % 2) == sum)
	else $error("Output 's' of first 1 biti adder is not correct");
     end
endmodule 	
