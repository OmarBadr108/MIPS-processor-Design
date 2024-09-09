`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs.
module Byte_Control (
	input wire [31:0] in ,
	input wire [1:0] ByteControl ,

	output reg [31:0] out 
	);

	always @(*) begin 
		case (ByteControl)
			'd0 : out = in ;  		 	 	 	      // Word
			'd1 : out = {{16{in[15]}} , in[15:0]} ;   // half word 
			'd2 : out = {{24{in[7 ]}} , in[7:0] } ;	  // Byte 

			default : out = in ;
		endcase 
	end 	
endmodule : Byte_Control