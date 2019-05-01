// $Id: $
// File name:   sensor_s.sv
// Created:     1/18/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 
// this is sensor_s

module sensor_s
(
	input wire [3:0] sensors,
	output wire init_and1,
	output wire init_and2,
	output wire init_or1,
	output wire error);

	AND2X1 A1 (.Y(init_and1), .A(sensors[2]), .B(sensors[1]));
	AND2X1 A2 (.Y(init_and2), .A(sensors[3]), .B(sensors[1]));
	OR2X1 A3 (.Y(init_or1), .A(init_and1),.B(init_and2));
	OR2X1 A4 (.Y(error), .A(init_or1),.B(sensors[0]));

endmodule