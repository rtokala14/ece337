// $Id: $
// File name:   magnitude.sv
// Created:     2/27/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: mag


module magnitude(
		 input wire [16:0]  in,
		 output wire [15:0] out);
 /*  
if (in[16] == 0) begin
      assign out = in[15:0];
end
   
else begin
   assign out = ~in[15:0] + 1;
  end
  */
   assign out = (in[16] ==0) ? in[15:0] : ~in[15:0] + 1;
   
endmodule // magnitude
