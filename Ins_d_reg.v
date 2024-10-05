`timescale 1ns / 1ps 
module INSTRUCTION_D_DELAYED #(
	parameter WIDTH_5 = 5 ,
	parameter WIDTH_32 = 32 
	)(

	input wire 		  clk , rst_n  , EN , CLR ,

	input wire [31:0] INSTRUCTION_D ,
	output reg [31:0] INSTRUCTION_D_delayed 
	);

always @(posedge clk) begin
	if (!rst_n) begin
		INSTRUCTION_D_delayed <= 'd0 ;
	end
	else begin
		
		if (EN) begin 
			INSTRUCTION_D_delayed <= INSTRUCTION_D ;
		end 

		else if (CLR) begin 
			INSTRUCTION_D_delayed <= 'd0 ;
		end 
	end
end

endmodule 