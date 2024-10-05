`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs.
module AHB_master (
	input wire  	  Hclk       ,
	input wire  	  Hrst_n     ,
	input wire 	  	  HREADY     ,
	input wire  	  HRESP      ,
	input wire [31:0] i_HADDR    , // ALU_RESULT_M
	input wire [31:0] i_HDATA    , // write Data M
	input wire [31:0] HRDATA     , // data in from slave that assigned to writeback mux
	input wire 	  	  MemtoReg_M ,
	input wire  	  MemWrite_M ,

	output reg [31:0] o_HADDR    ,
	output reg [31:0] HWDATA     ,
	output reg 	 	  HWRITE     ,
	output reg [2:0]  HSIZE      ,
	output reg [1:0]  HTRANS 
	);
wire transfer ;
assign transfer = MemtoReg_M | MemWrite_M ;


localparam [1:0] IDLE  		   = 'd0 ;
localparam [1:0] NONSEQUENTIAL = 'd1 ;
localparam [1:0] BUSY  		   = 'd2 ;
localparam [1:0] SEQUENTIAL    = 'd3 ; 

localparam [2:0] IDLE_STATE   = 'd0 ,
 	 	    	 ADDRESS 	  = 'd1 ,
  	  		 	 ADDRESS_DATA = 'd2 ,
   	 	 	     DATA     	  = 'd3 ,
			  	 WAIT     	  = 'd4 ; 

reg [2:0] current_state , next_state ;
reg [31:0] tmp_Address , tmp_Data ; 

	// state memory (sequential)
	always @(posedge Hclk or negedge Hrst_n) begin 
		if (!Hrst_n) begin
			current_state <= IDLE_STATE ;
		end
		else begin
			current_state <= next_state ;
		end
	end
	
	// next state logic (Moore FSM)
	always@(*)begin
		case (current_state)
		IDLE_STATE : begin
			if (transfer && HREADY) begin 
				next_state = ADDRESS ;
			end 
			else begin 
				next_state = IDLE_STATE ;
			end 
		end

		ADDRESS : begin
			if (transfer && HREADY) begin 
				next_state = ADDRESS_DATA ;
			end 
			else if (!transfer && HREADY) begin 
				next_state = DATA ;
			end
			else begin
				next_state = ADDRESS ;
			end  
		end 

		ADDRESS_DATA : begin
			if (transfer && HREADY) begin 
				next_state = ADDRESS_DATA ;
			end 
			else if (!transfer && HREADY) begin 
				next_state = DATA ;
			end
			else if (!HREADY) begin
				next_state = WAIT ;
			end 
			else begin 
				next_state = ADDRESS_DATA ;
			end 
		end

		WAIT : begin
			if (HREADY && transfer) begin 
				next_state = ADDRESS_DATA ;
			end 
			else if (HREADY && !transfer) begin
				next_state = DATA ;
			end
			else begin // not READY
				next_state = WAIT ;
			end 
		end

		DATA : begin
			if (HREADY && transfer) begin  
				next_state = ADDRESS ;
			end 
			else if (HREADY && !transfer) begin 
				next_state = IDLE_STATE ; 
			end 
			else begin 
				next_state = DATA ;
			end 
		end 

		default : begin 
	 	 	next_state = IDLE_STATE ; 
		end 
		endcase
	end

	//  next state logic (Moore FSM)
	always@(*)begin
		case (current_state)
		IDLE_STATE : begin
			o_HADDR = i_HADDR; 
			HWDATA  = 'd0;
		end

		ADDRESS : begin
			o_HADDR = i_HADDR ;
			if (HWRITE) begin 
				tmp_Data  = i_HDATA ;
			end 
			else begin 
				tmp_Data  = 'd0 ;
			end 
		end 

		ADDRESS_DATA : begin
			o_HADDR = i_HADDR ;
			HWDATA  = tmp_Data ;
			tmp_Data =  
		end

		DATA : begin
			o_HADDR = i_HADDR ;
			HWDATA  = tmp_Data ;
		end 

		WAIT : begin 
			o_HADDR = i_HADDR ;
			HWDATA  = i_HDATA ;
		end 

		default : begin 

		end 
		endcase
	end