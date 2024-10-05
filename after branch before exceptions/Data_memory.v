`timescale 1ns / 1ps 
`default_nettype none // Disable implicit nets. Reduces some types of bugs.

module Data_memory #(parameter  WIDTH = 8 ,SIZE = 28*1024/4) 
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
	 // --- Memory Array --
  	reg [WIDTH-1:0] BRAM0 [0:SIZE-1];
  	reg [WIDTH-1:0] BRAM1 [0:SIZE-1];
  	reg [WIDTH-1:0] BRAM2 [0:SIZE-1];
  	reg [WIDTH-1:0] BRAM3 [0:SIZE-1];

	//--------------------------------------------------
	// initializing the memory
	//--------------------------------------------------
	integer i ;

	initial begin 
        for ( i = 0 ; i < SIZE ; i = i + 1) begin 
            BRAM0 [i] <= 'd0 ;
            BRAM1 [i] <= 'd0 ;
            BRAM2 [i] <= 'd0 ;
            BRAM3 [i] <= 'd0 ;
        end 
    end 

	//--------------------------------------------------
	// Body of the Positive edge triggered memory
	//--------------------------------------------------

	always @(posedge clk) begin

		rd_data <= {BRAM3[addr>>>2], BRAM2[addr>>>2], BRAM1[addr>>>2], BRAM0[addr>>>2]} ;
					
		if (ByteControl[0] && wr_en) BRAM0[addr>>>2] <= wr_data [7:0]  ;
  		if (ByteControl[1] && wr_en) BRAM1[addr>>>2] <= wr_data [15:8] ;
  		if (ByteControl[2] && wr_en) BRAM2[addr>>>2] <= wr_data [23:16];
  		if (ByteControl[3] && wr_en) BRAM3[addr>>>2] <= wr_data [31:24];
	
  	end 
endmodule 