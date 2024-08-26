`timescale 1ns / 1ps 
module ram_memory #(parameter DEPTH = 4 * 1024 , WIDTH = 8) (
	input wire 		           clk ,
	// write ports
	input wire  	  		   wr_en ,
	input wire [(4*WIDTH)-1:0] addr ,    // 32 to be match with pc 
	input wire [(4*WIDTH)-1:0] wr_data , // 32 bit
	
	// read port
	output reg [(4*WIDTH)-1:0] rd_data  	 // 32 bit
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
	// Body of the NEGATIVE edge triggered memory
	//--------------------------------------------------
	always @(negedge clk) begin 
		if (wr_en) begin 
			{mem[addr+3], mem[addr+2], mem[addr+1] ,mem[addr]} <= wr_data ;
		end 

		else begin
			rd_data <= {mem[addr+3], mem[addr+2], mem[addr+1] ,mem[addr]} ;
		end 
	end 

endmodule 