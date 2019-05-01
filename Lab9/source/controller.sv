// $Id: $
// File name:   controller.sv
// Created:     2/24/2019
// Author:      ZhiFei Chen
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: controller for Lab7
module controller
(
	input wire 	 clk,
	input wire 	 n_rst,
	input wire 	 dr,
	input wire 	 lc,
	input wire 	 overflow,
	output reg 	 cnt_up,
	output reg 	 clear,
	output reg [2:0] op,
	output reg [3:0] src1, 
	output reg [3:0] src2,
	output reg [3:0] dest,
	output reg 	 err,
	output wire 	 modwait);

//local params
	reg MODWAIT;
	reg next_MODWAIT;
	assign modwait = MODWAIT;
	typedef enum bit [4:0] {IDLE, LOAD_COEFF0, LOADED0, LOAD_COEFF1, LOADED1,LOAD_COEFF2, LOADED2, LOAD_COEFF3,
				STORE, ZERO, SORT1, SORT2, SORT3, SORT4, MUL1, MUL2, MUL3, MUL4, ADD1, ADD2, SUB1, SUB2, EIDLE}stateType;
	stateType state;
	stateType next_state;

always_ff @(posedge clk, negedge n_rst) begin
	if(n_rst == 0) begin
		state <= IDLE;
		MODWAIT <= 0;
	end
	else begin
		state <= next_state;
		MODWAIT <= next_MODWAIT;
	end
end

always_comb begin
	next_state = IDLE;
	next_MODWAIT = 1;
	case(state)
		IDLE: begin
			if (lc == 1) begin
				next_state = LOAD_COEFF0;
			end
			else if(dr == 1) begin
				next_state = STORE;
			end
			else begin
				next_state = IDLE;
				next_MODWAIT = 0;
			end
		end
		LOAD_COEFF0: begin
			next_state = LOADED0;
			next_MODWAIT = 0;
		end
		LOADED0: begin
			if (lc == 1) begin
				next_state = LOAD_COEFF1;
			//	next_MODWAIT = 0;
			end
			else begin
				next_state = LOADED0;
				next_MODWAIT = 0;
			end
		end
		
		LOAD_COEFF1: begin
			next_state = LOADED1;
			next_MODWAIT = 0;
		end
		LOADED1: begin
			if (lc == 1) begin
				next_state = LOAD_COEFF2;
				//next_MODWAIT = 0;
			end
			else begin
				next_state = LOADED1;
				next_MODWAIT = 0;
			end
		end
		
		LOAD_COEFF2: begin
			next_state = LOADED2;
			next_MODWAIT = 0;
		end
		LOADED2: begin
			if (lc == 1) begin
				next_state = LOAD_COEFF3;
			   //next_MODWAIT = 0;
			end
			else begin
				next_state = LOADED2;
				next_MODWAIT = 0;
			end
		end

		LOAD_COEFF3: begin
			next_state = IDLE;
			next_MODWAIT = 0;
		end
		STORE: begin
			if (dr == 1) begin
				next_state = ZERO;
				//next_MODWAIT = 0;
			end
			else begin
				next_state = EIDLE;
				next_MODWAIT = 0;
			end
		end
		ZERO: begin
				next_state = SORT1;
			end

			SORT1: begin
				next_state = SORT2;
			end
			SORT2: begin
				next_state = SORT3;
			end
			SORT3: begin 
				next_state = SORT4;
			end
			
			SORT4: begin 
				next_state = MUL1;
			end
			
			MUL1: begin
				next_state = ADD1;
			end
			
			ADD1: begin
				next_state = MUL2;
				if (overflow == 1) begin
					next_state = EIDLE;
					next_MODWAIT = 0;
				end
			end

			MUL2: begin 
				next_state = SUB1;
			end
			
			SUB1: begin
				next_state = MUL3;
				if (overflow == 1) begin
					next_state = EIDLE;
					next_MODWAIT = 0;
				end
			end
			
			MUL3: begin
				next_state = ADD2;
			end

			ADD2: begin
				next_state = MUL4;
				if (overflow == 1) begin
					next_state = EIDLE;
					next_MODWAIT = 0;
				end
			end

			MUL4: begin
				next_state = SUB2;
			end

			SUB2: begin
				if (overflow == 1) begin
					next_state = EIDLE;
					next_MODWAIT = 0;
				end
				else begin
					next_state = IDLE;
					next_MODWAIT = 0;
				end	
			end
			EIDLE: begin
				if (dr == 1)
					next_state = STORE;
				else if (lc == 1)
					next_state = LOAD_COEFF1;
				else begin
					next_state = EIDLE;
					next_MODWAIT = 0;
				end
			end
		endcase
	end
always_comb begin
	//prevent latches
   cnt_up = 0;
   err = 0;
   clear = 0;
   dest = 4'b0000;
   src1 = 4'b0000;
   src2 = 4'b0000;
   op = 3'b000;
   //

   case(state) 
      IDLE: begin
	 cnt_up = 0;
	 err = 0;
	 dest = 4'b0000;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b000;
      end
     LOAD_COEFF0: begin
	 cnt_up = 0;
	 err = 0;
	 clear = 1;	
	 dest = 4'b0110;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b011;
     end
     LOADED0: begin
	 cnt_up = 0;
	err = 0;
	 dest = 4'b0000;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b000;
     end
     LOAD_COEFF1: begin
         cnt_up = 0;
	 err = 0;
	 clear = 0;
	 dest = 4'b0111;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b011;
     end
     LOADED1: begin
	 cnt_up = 0;
	 err = 0;
	clear = 0;
	 dest = 4'b0000;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b000;
     end
     LOAD_COEFF2: begin
         cnt_up = 0;
	 err = 0;
	clear = 0;
	
	 dest = 4'b1000;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b011;
     end
     LOADED2: begin
	 cnt_up = 0;
	 err = 0;
	clear = 0;
	
	 dest = 4'b0000;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b000;
     end
     LOAD_COEFF3: begin
         cnt_up = 0;
	 err = 0;
	 clear = 0 ;
	 dest = 4'b1001;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b011;
     end/*
     LOADED3: begin
	 cnt_up = 0;
	 err = 0;
	 dest = 4'b0000;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b000;
     end*/
     STORE: begin
	cnt_up = 0;
	clear = 0;
	dest = 4'b0101;
	src1 = 4'b0000;
	src2 = 4'b0000;
	op = 3'b010;
     end
     ZERO: begin
	cnt_up = 1;
	clear = 0;
	err = 0;
	dest = 4'b0000;

	src1 = 4'b0000;
	src2 = 4'b0000;
	op = 3'b101;
     end
     SORT1: begin
	cnt_up = 0;
	clear = 0;
	dest = 4'b0001;
	src1 = 4'b0010;
	src2 = 4'b0000;
	op = 3'b001;
     end
    SORT2: begin
	cnt_up = 0;
	clear = 0;
	dest = 4'b0010;
	src1 = 4'b0011;
	src2 = 4'b0000;
	op = 3'b001;
     end
    SORT3: begin
	cnt_up = 0;
	clear = 0;
	dest = 4'b0011;
	src1 = 4'b0100;
	src2 = 4'b0000;
	op = 3'b001;
    end
    SORT4: begin
	cnt_up = 0;
	clear = 0;
	dest = 4'b0100;
	src1 = 4'b0101;
	src2 = 4'b0000;
	op = 3'b001;
    end
    MUL1:begin
       cnt_up = 0;
       clear = 0;
       err = 0;
       dest = 4'b1010;
       src1 = 4'b0001;
       src2 = 4'b0110;
       op = 3'b110;
    end
    ADD1:begin
       cnt_up = 0;
       clear = 0;
       err = 0;
       dest = 4'b0000;
       src1 = 4'b0000;
       src2 = 4'b1010;
       op = 3'b100;
    end
    MUL2:begin
       cnt_up = 0;
       clear = 0;
       err = 0;
       dest = 4'b1010;
       src1 = 4'b0010;
       src2 = 4'b0111;
       op = 3'b110;
    end
    SUB1:begin
       cnt_up = 0;
       clear = 0;
       err = 0;
       dest = 4'b0000;
       src1 = 4'b0000;
       src2 = 4'b1010;
       op = 3'b101;
    end
    MUL3:begin
       cnt_up = 0;
       clear = 0;
       err = 0;
       dest = 4'b1010;
       src1 = 4'b0011;
       src2 = 4'b1000;
       op = 3'b110;
    end
    ADD2:begin
       cnt_up = 0;
       clear = 0;
       err = 0;
       dest = 4'b0000;
       src1 = 4'b0000;
       src2 = 4'b1010;
       op = 3'b100;
    end
    MUL4:begin
       cnt_up = 0;
       clear = 0;
       err = 0;
       dest = 4'b1010;
       src1 = 4'b0100;
       src2 = 4'b1001;
       op = 3'b110;
    end
    SUB2:begin
       cnt_up = 0;
       clear = 0;
       err = 0;
       dest = 4'b0000;
       src1 = 4'b0000;
       src2 = 4'b1010;
       op = 3'b101;
    end
    EIDLE: begin
	 cnt_up = 0;
	 err = 1;
         clear = 0;
       
	 dest = 4'b0000;
	 src1 = 4'b0000;
	 src2 = 4'b0000;
	 op = 3'b000;
    end
   endcase // case (state)
end // always_comb
endmodule // controller

    
     

	
	
     
       

 
   
				
	
	

	 
		   
