`timescale 1ns / 1ps 
module Ftech_Decode_Register #(
	parameter WIDTH_1 = 1 ,
	parameter WIDTH_2 = 5 ,
	parameter WIDTH_3 = 32 ,
	)(

	input wire 		  clk , rst_n  , EN , CLR ,
	
	input wire [WIDTH_3-1:0] in_1  ,
	output reg [WIDTH_3-1:0] out_1 ,

	input wire [WIDTH_3-1:0] in_2  ,
	output reg [WIDTH_3-1:0] out_2 

	);

always @(posedge clk) begin
	if (!rst_n) begin
		out_1 <= 32'd0 ;
		out_2 <= 32'd0 ;
	end
	else begin
		if (CLR) begin 
			out_1 <= 32'd0 ;
			out_2 <= 32'd0 ;
		end 
		else if (EN) begin 
			out_1 <= in_1 ;
			out_2 <= in_2 ;
		end 
	end
end

endmodule 