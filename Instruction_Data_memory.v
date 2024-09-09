`timescale 1ns / 1ps 
`default_nettype none // Disable implicit nets. Reduces some types of bugs.

module ram_memory #(parameter DEPTH = 512 , WIDTH = 8) 
	(
	input wire 		           clk , rst_n ,
	// write ports
	input wire  	  		   wr_en ,
	input wire [(4*WIDTH)-1:0] addr ,    // 32 to be match with pc and alu output 
	input wire [(4*WIDTH)-1:0] wr_data , // 32 bit
	input wire [1:0]   	 	   ByteControl , // 00 for word , 1 for half word , 2 for byte

	// read port
	output wire [(4*WIDTH)-1:0] rd_data  	 // 32 bit
	);
	//--------------------------------------------------
	// memory creation (little endian i.e the LSB is of index 0)
	//--------------------------------------------------
	reg [WIDTH-1:0] mem [0:DEPTH-1] ;

	//--------------------------------------------------
	// initializing the memory
	//--------------------------------------------------
	integer i ;
	initial begin 
		for ( i = 0 ; i < DEPTH ; i = i +1)
			mem [i] <= 'd0 ;
	end 

	//--------------------------------------------------
	// Body of the Positive edge triggered memory
	//--------------------------------------------------

	assign rd_data = {mem[addr+3], mem[addr+2], mem[addr+1] ,mem[addr]} ;

	always @(posedge  clk or negedge rst_n) begin
		
		if (!rst_n) begin 
			for ( i = 0 ; i < DEPTH ; i = i +1)
			mem [i] <= 'd0 ;
		end 
		else begin 
			if (wr_en) begin 
				case (ByteControl)
					'd0 : {mem[addr+3], mem[addr+2], mem[addr+1] ,mem[addr]}     <= wr_data ;       // word 
					'd1 : {mem[addr+1] ,mem[addr]} 	 	 	 	 	 	         <= wr_data[15:0] ; // half word 
					'd2 : {mem[addr]} 	 	 	 	 	 	                     <= wr_data[7:0]  ; // byte 
					default : {mem[addr+3], mem[addr+2], mem[addr+1] ,mem[addr]} <= wr_data ;       // word 
				endcase 
			end 
		end 
	end 

endmodule 