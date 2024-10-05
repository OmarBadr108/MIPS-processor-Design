`timescale 1ns / 1ps 
`default_nettype none // Disable implicit nets. Reduces some types of bugs.

module exception_memory #(parameter DEPTH = 64 , WIDTH = 8) 
	(
	input wire 		           clk , rst_n , EN , CLR ,
	// write ports
	input wire  	  		   wr_en ,
	input wire [(4*WIDTH)-1:0] addr ,    // 32 to be match with pc and alu output 
	input wire [(4*WIDTH)-1:0] wr_data , // 32 bit
	input wire [3:0]   	 	   ByteControl , // 00 for word , 1 for half word , 2 for byte

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
	// Body of the Positive edge triggered memory
	//--------------------------------------------------

	always @(posedge  clk) begin
			if (CLR) begin 
				rd_data <= 'd0 ;
			end

			else if (EN) begin 
				rd_data <= {mem[addr+3], mem[addr+2], mem[addr+1] ,mem[addr]} ;
				if (wr_en) begin 
					case (ByteControl)
						4'b1111 : {mem[addr+3], mem[addr+2], mem[addr+1] ,mem[addr]}     <= wr_data ;       // word 
						4'b0011 : {mem[addr+1] ,mem[addr]} 	 	 	 	 	 	         <= wr_data[15:0] ; // half word 
						4'b0001 : {mem[addr]} 	 	 	 	 	 	                     <= wr_data[7:0]  ; // byte 
						default : {mem[addr+3], mem[addr+2], mem[addr+1] ,mem[addr]}     <= wr_data ;       // word 
					endcase 
				end 
			end 
		end
	

endmodule 