`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs.
module Byte_Control (
	input wire [31:0] in ,
	input wire [3:0] ByteControl ,

	output reg [31:0] out 
	);

	always @(*) begin 
		case (ByteControl)
			4'b1111 : out = in ;  		 	 	 	      // Word
			4'b0011 : out = {{16{1'b0}} , in[15:0]} ;   // half word 
			4'b0001 : out = {{24{1'b0}} , in[7:0] } ;	  // Byte 

			default : out = in ;
		endcase 
	end 	
endmodule : Byte_Control