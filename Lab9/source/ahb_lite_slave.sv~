// $Id: $
// File name:   ahb_lite_slave.sv
// Created:     3/16/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: ahb_lite_slvae

module ahb_lite_slave(
		      input wire 	clk,
		      input wire 	n_rst,
		      output reg [15:0] sample_data,
		      output reg 	data_ready,
		      output reg [15:0] fir_coefficient,
		      output reg 	new_coefficient_set,
		      input wire [1:0] 	coefficient_num,
		      input wire 	modwait,
		      input wire [15:0] fir_out,
		      input wire 	err,
		      input wire 	hsel,
		      input wire [3:0] 	haddr,
		      input wire 	hsize,
		      input wire [1:0] 	htrans,
		      input wire 	hwrite,
		      input wire [15:0] hwdata,
		      output reg [15:0] hrdata,
		      output reg 	hresp);
   typedef enum 			bit [1:0] {IDLE, WRITE, READ}stateType;

   stateType state;
   stateType prev_state;
   reg [7:0] 				reg_address [0:15];
   reg [7:0] 				next_reg_address [0:15];
   reg [3:0] 				prev_haddr;
   reg prev_hsize;
   reg next_data_ready;
   always_ff @(posedge clk, negedge n_rst) begin
      if(n_rst == 0) begin
	prev_state <= IDLE; // reset the state var
	reg_address[0] <= '0; // reset the reg_address
	reg_address[1] <= '0;
	reg_address[2] <= '0;
	reg_address[3] <= '0;
	reg_address[4] <= '0;
	reg_address[5] <= '0;
	reg_address[6] <= '0;
	reg_address[7] <= '0;
	reg_address[8] <= '0;
	reg_address[9] <= '0;
	reg_address[10] <= '0;
	reg_address[11] <= '0;
	reg_address[12] <= '0;
	reg_address[13] <= '0;
	reg_address[14] <= '0;
	 reg_address[15] <= '0;
	 
	data_ready <= 1'b0;
	prev_haddr <= 4'b0; // reset the previous address 
	prev_hsize <= 1'b0;
	
      end
      else begin
	 prev_state <= state; // update the state
	 reg_address <= next_reg_address;//update the address
	 prev_haddr <= haddr;
	 data_ready <= next_data_ready;
	 prev_hsize <= hsize;
      end
   end // always_ff @ (posedge clk, negedge n_rst)
   always_comb begin
	hresp = 1'b0;
	if((hsel == 1) && (htrans == 2'b10))begin
	    if((hwrite == 1'b1) && ((haddr == 4'h4)||(haddr == 4'h6)||(haddr == 4'h8)||(haddr == 4'hA)||(haddr == 4'hC)||(haddr == 4'hE)))begin
	        state = WRITE;
	    end
	    else if ((hwrite == 1'b0) && ((haddr == 4'h0)||(haddr == 4'h2)||(haddr == 4'h4)||(haddr == 4'h6)||(haddr == 4'h8)||(haddr == 4'hA)||(haddr == 4'hC)||(haddr == 4'hE)))begin
	        state = READ;
	    end
            else begin
	        state = IDLE;
		hresp = 1'b1;      
            end
	end
	else begin
		state = IDLE;
	end // else: !if((hsel == 1) && (htrans == 2'b10))
end // always_comb

always_comb begin
	//hresp = 1'b0;
	hrdata = {reg_address[1], reg_address[0]};
	fir_coefficient = {reg_address[7],reg_address[6]};
	next_reg_address = reg_address; //prevent latch
	
	next_reg_address[2] = fir_out[7:0]; 
	next_reg_address[3] = (hsize == 1'b1) ? fir_out[15:8] : '0;
	
	sample_data[7:0] = reg_address[4]; 
	sample_data[15:8] = reg_address[5];
	new_coefficient_set = reg_address[14];
	
	next_data_ready = data_ready;

	if(modwait)begin
		next_reg_address[0][0] = 1'b1;
	end
	else begin
		next_reg_address[1] = 8'h0;  
		next_reg_address[0] = 8'h0;
	end
	if(err)begin
		next_reg_address[1][0] = 1'b1;
	end
	if(reg_address[14] == 1'b1) begin
		if (coefficient_num == 2'b00)
			begin
				fir_coefficient = {reg_address[7], reg_address[6]};
			end
		if(coefficient_num == 2'b01)
		        begin
				fir_coefficient = {reg_address[9], reg_address[8]};
			end
		if(coefficient_num == 2'b10)
		        begin
				fir_coefficient = {reg_address[11], reg_address[10]};
			end
		if(coefficient_num == 2'b11)
		        begin
				fir_coefficient = {reg_address[13], reg_address[12]};
				if(modwait)begin
					next_reg_address[14] = 8'h0;
				end
			end
	//	endcase
	end //if
			
	case(prev_state)
		//ERROR: begin
			//hresp = 1'b1;
		//end
		WRITE:begin
			if(prev_hsize)begin
				next_reg_address[prev_haddr] = hwdata[7:0];
				next_reg_address[prev_haddr + 1'b1] = hwdata[15:8];
			end
			else begin
				next_reg_address[prev_haddr] = hwdata[7:0];
			end
			//dataready ???????	
			if((modwait == 1'b0) && (prev_haddr == 4'h4)) begin 	
				next_data_ready = 1'b1;
			end

		end
		READ:begin
			hrdata[7:0] = reg_address[prev_haddr];
			hrdata[15:8]  = reg_address[prev_haddr + 1'b1];
		end
	endcase
	if((modwait == 1) && (data_ready == 1))begin
		next_data_ready = 0;
	end
end //always comb
endmodule
		
			
					  
					    
					     
			     
	       
	    
	
      
	 
	 
	 
	 
      
