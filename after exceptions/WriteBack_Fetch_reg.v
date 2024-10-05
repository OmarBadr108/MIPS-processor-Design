`timescale 1ns / 1ps 
module WriteBack_Ftech_Register #(
	parameter WIDTH_5 = 5 ,
	parameter WIDTH_32 = 32 
	)(

	input wire 		  clk , rst_n  , EN , CLR ,
	input wire [WIDTH_32-1:0] PC_W  ,

	output reg [WIDTH_32-1:0] PC_F 
	);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		PC_F <= 32'd0 ;
	end
	else begin
		if (CLR) begin 
			PC_F <= 32'd0 ;
		end 
		else if (EN) begin 
			PC_F <= PC_W ;
		end 
	end
end

endmodule 