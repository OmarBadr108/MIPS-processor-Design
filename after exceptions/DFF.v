`timescale 1ns / 1ps 
module DFF #(parameter WIDTH_32 = 32 )(
	input wire 		  clk , rst_n  , EN ,

	input wire [WIDTH_32-1:0] IN ,
	output reg [WIDTH_32-1:0] OUT 
	);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		OUT <= 'd0 ;
	end
	else if (EN) begin
		OUT <= IN ;
	end
end

endmodule 