`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs.
module PC_Decoder (
	input wire [31:0] PC_in ,

	output reg  	  selector ,
	output reg [31:0] PC_out
	);

always @(*) begin
	if (PC_in >= 32'h8000_0180) begin 
		PC_out   =  PC_in - 32'h8000_0180 ;
		selector = 1'b1 ;
	end 
	else begin 
		PC_out   = PC_in ;
		selector = 1'b0 ;
	end
end
endmodule 