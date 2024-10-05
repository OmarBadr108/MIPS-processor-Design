`timescale 1ns / 1ps 
module Fetch_Decode_Register #(
	parameter WIDTH_5 = 5 ,
	parameter WIDTH_32 = 32 
	)(

	input wire 		  clk , rst_n  , EN , CLR ,
	
	//input wire [WIDTH_32-1:0] INSTRUCTION_F ,
	//output reg [WIDTH_32-1:0] INSTRUCTION_D ,

	input wire [WIDTH_32-1:0] PC_F ,
	output reg [WIDTH_32-1:0] PC_D ,

	input wire [WIDTH_32-1:0] PC_plus_4_F   ,
	output reg [WIDTH_32-1:0] PC_plus_4_D 

	);

always @(posedge clk) begin
	if (!rst_n) begin
		//INSTRUCTION_D <= 32'd0 ;
		PC_plus_4_D   <= 32'd0 ;
		PC_D  	 	  <= 32'd0 ;
	end
	else begin
		if (CLR) begin 
			//INSTRUCTION_D <= 32'd0 ;
			PC_plus_4_D   <= 32'd0 ;
			PC_D  	 	  <= 32'd0 ;
		end 
		else if (EN) begin 
			//INSTRUCTION_D <= INSTRUCTION_F ;
			PC_plus_4_D   <= PC_plus_4_F ;
			PC_D  	 	  <= PC_F ;
		end 
	end
end

endmodule 