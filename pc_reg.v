`timescale 1ns / 1ps 
module pc_reg (
	input wire 		  clk , rst_n ,
	input wire [31:0] pc_next ,
	
	output reg [31:0] pc 
	);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		pc <= 32'd0 ;
	end
	else begin
		pc <= pc_next ;
	end
end

endmodule 