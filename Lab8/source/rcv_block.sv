// $Id: $
// File name:   rcv_block.sv
// Created:     2/18/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: rcv_block
`timescale 1ns / 10ps

module rcv_block
(
	input wire 	  clk,
	input wire 	  n_rst,
	input wire 	  serial_in,
	input wire 	  data_read,
	input wire [3:0]  data_size,
	input wire [13:0] bit_period,
	output reg [7:0]  rx_data,
	output reg 	  data_ready,
	output reg 	  overrun_error,
	output reg 	  framing_error);

//local parameter
wire load_buffer;
wire enable_timer;
wire shift_strobe;
wire packet_done;
wire start_bit_det;
wire stop_bit;
wire sbc_clear;
wire sbc_enable;
wire [7:0] packet_data;


stop_bit_chk stopBcheck(.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(framing_error));

start_bit_det startBdet(.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .start_bit_detected(start_bit_det));

sr_9bit sr9(.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit));

   rcu rcu_block(.clk(clk), .n_rst(n_rst), .start_bit_detected(start_bit_det), .packet_done(packet_done), .framing_error(framing_error),  .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));
   

timer timer_block(.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .data_size(data_size), .bit_period(bit_period), .shift_strobe(shift_strobe), .packet_done(packet_done));

rx_data_buff RX(.clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), .packet_data(packet_data), .data_read(data_read),.rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));
endmodule 
