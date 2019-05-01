// $Id: $
// File name:   rcu.sv
// Created:     2/19/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: rcu
module rcu(
	   input wire clk,
	   input wire n_rst,
	   input wire start_bit_detected,
	   input wire packet_done,
	   input wire framing_error,
	   output reg sbc_enable,
	   output reg sbc_clear,
	   output reg load_buffer,
	   output reg enable_timer);
   typedef enum bit [2:0] {IDLE, START_B_RCV, RCV_PAC, STOP_B_RCV,CHK_FRAMING,STR_DATA}stateType;
   stateType state;
   stateType next_state;

   always_ff @(posedge clk, negedge n_rst)
     begin
	if(n_rst == 0)begin
	   state <= IDLE;
	   end
	else begin
	   state <= next_state;
	end
     end
   always_comb begin
      next_state = state;      //prevent latches
      sbc_enable = 0;
      sbc_clear = 0;
      load_buffer = 0;
      enable_timer = 0;

      case(state)
	IDLE:begin
	   if (start_bit_detected == 1)begin
	      next_state = START_B_RCV;
	   end
	end
	START_B_RCV:begin
	   sbc_clear = 1;
	   next_state = RCV_PAC;
	end
	RCV_PAC:begin
	   enable_timer = 1;
	   sbc_clear = 0;
	   if(packet_done == 1)begin
	      next_state = STOP_B_RCV;
	   end
	end
	
	STOP_B_RCV: begin
	   enable_timer = 0;
	   sbc_enable = 1;
	   next_state = CHK_FRAMING;
	end
	

	CHK_FRAMING: begin
	   sbc_enable = 0;
	   if(framing_error == 1) begin
	      next_state = IDLE;
	   end
	   else begin
	      next_state = STR_DATA;
	   end
	end

	STR_DATA:begin
	   load_buffer = 1;
	   next_state = IDLE;
	end

      endcase // case (state)
   end // always_comb
endmodule // rcu

	      
	   
