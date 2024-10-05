module Branch_Predictor (
	input wire 	  	  clk , rst_n ,
	input wire 	 	  branch_taken_D , // Branch_Src
	input wire [31:0] PCBranch_result_D , // write target
	input wire [31:0] PC_D , // write address
	input wire  	  Branch_D ,
	input wire [31:0] PC_F ,

	output wire [31:0] Branch_predictor_target , // will always contain that the branch address 
	output reg  	   Misprediction_for_taken_Delayed ,
	output reg 	       Misprediction_for_taken ,
	output reg  	   Misprediction_for_not_taken_Delayed ,
	output reg  	   Misprediction_for_not_taken ,
	output wire 	   Branch_Predictor_sel ,
	output reg 	 	   Double_Branch_stall 
	);	


	reg [1:0] current_state ,next_state ;

	wire [23:0] write_tag , write_tag_out;
	assign write_tag = PC_D [31:8] ;

	wire [5:0]  write_index ;
	assign write_index = PC_D [7:2] ;

	wire [5:0]  read_index ;
	assign read_index = PC_F [7:2] ;	

	wire [23:0] read_tag ;
	assign read_tag = PC_F [31:8] ;
	
	// Branch_Target_Buffer
	reg  [58:0] Branch_Target_Buffer[0:63] ;
	wire [58:0] buffer_out ;
	reg 	    valid ;
	wire        valid_out;
	wire  	    Comparator_out ;
	integer i ;

	// combinational read operation
	assign buffer_out = Branch_Target_Buffer[read_index] ;

	// sequential write operation 
	always @(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin 
			for ( i = 0 ; i < 64 ; i = i +1) Branch_Target_Buffer [i] <= 'd0 ;
			valid <= 0 ;
		end 
		else begin
			if(Branch_D) begin // enable 
				Branch_Target_Buffer[write_index] <= {next_state, valid , write_tag ,PCBranch_result_D} ;// = {    2     ,   1   ,    24     , 32 }
				valid <= 1 ;
			end 
		end
	end 



	//-----------------------------------------------------------------
	// FSM
	//-----------------------------------------------------------------
	reg TAKEN ; // the only output of the FSM

	localparam STRONGLY_NOT_TAKEN = 2'd0 ;
	localparam WEAKLY_NOT_TAKEN   = 2'd1 ;
	localparam WEAKLY_TAKEN  	  = 2'd2 ;
	localparam STRONGLY_TAKEN     = 2'd3 ;

	

	// state memory (sequential)
	always @(posedge clk or negedge rst_n) begin // asynchronous active high reset 
		if (!rst_n) begin
			current_state <= WEAKLY_NOT_TAKEN ;
		end
		else begin
			if (Branch_D) begin 
				current_state <= buffer_out[58:57] ;
			end 
		end
	end
	
	//  next state logic (Moore FSM)
	always@(*)begin

		case (current_state)

		STRONGLY_NOT_TAKEN : begin
			if (branch_taken_D) begin 
				next_state = WEAKLY_NOT_TAKEN ;
				
				Misprediction_for_taken = 1'b1 ;
				Misprediction_for_not_taken = 1'b0 ;
			end 
			else begin 
				next_state = STRONGLY_NOT_TAKEN ;

				Misprediction_for_taken = 1'b0 ;
				Misprediction_for_not_taken = 1'b0 ;
			end 
		end

		WEAKLY_NOT_TAKEN : begin
			if (branch_taken_D) begin 
				next_state = WEAKLY_TAKEN ;

				Misprediction_for_taken = 1'b1 ;
				Misprediction_for_not_taken = 1'b0 ;
			end 
			else begin 
				next_state = STRONGLY_NOT_TAKEN ;

				Misprediction_for_taken = 1'b0 ;
				Misprediction_for_not_taken = 1'b0 ;
			end 
		end 

		WEAKLY_TAKEN : begin
			if (branch_taken_D) begin 
				next_state = STRONGLY_TAKEN ;

				Misprediction_for_taken = 1'b0 ;
				Misprediction_for_not_taken = 1'b0 ;
			end 
			else begin 
			 	next_state = WEAKLY_NOT_TAKEN ;

			 	Misprediction_for_taken = 1'b0 ;
				Misprediction_for_not_taken = 1'b1 ;
			end 
		end 

		STRONGLY_TAKEN : begin
			if (branch_taken_D) begin 
				next_state = STRONGLY_TAKEN ;

				Misprediction_for_taken = 1'b0 ;
				Misprediction_for_not_taken = 1'b0 ;
			end 
			else begin 
				next_state = WEAKLY_TAKEN ;

				Misprediction_for_taken = 1'b0 ;
				Misprediction_for_not_taken = 1'b1 ;
			end 
		end 
		endcase
	end

	//  next state logic (Moore FSM)
	always@(*)begin
		case (current_state)
			STRONGLY_NOT_TAKEN : TAKEN = 1'b0 ;
			WEAKLY_NOT_TAKEN   : TAKEN = 1'b0 ;
			WEAKLY_TAKEN  	   : TAKEN = 1'b1 ;
			STRONGLY_TAKEN     : TAKEN = 1'b1 ;
		endcase
	end

	//-----------------------------------------------------------------
	// OUTPUTS
	//-----------------------------------------------------------------
	assign valid_out     = buffer_out[56] ;
	assign write_tag_out = buffer_out[55:32];

	assign Branch_Predictor_sel = ( TAKEN & valid_out & Comparator_out) ;
	assign Branch_predictor_target = buffer_out[31:0] ;

	assign Comparator_out = (write_tag_out == read_tag ) ?  1 : 0 ;


	//-----------------------------------------------------------------
	// Pulse shifting for misprediction for taken 
	//-----------------------------------------------------------------
	
	always @(posedge clk) begin 
		Misprediction_for_taken_Delayed <= Misprediction_for_taken ;

		Misprediction_for_not_taken_Delayed <= Misprediction_for_not_taken ;
	end 





endmodule 