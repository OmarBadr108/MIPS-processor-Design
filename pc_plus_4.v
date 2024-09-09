`timescale 1ns / 1ps
module PC_plus_4 (
	input wire [31:0] in ,
	output wire [31:0] out 
	);

	assign out = in + 'd4 ;
endmodule 