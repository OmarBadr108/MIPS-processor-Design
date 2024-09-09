`timescale 1ns / 1ps 
module special_register (
	input wire 		  clk , rst_n , wr_en ,
	input wire [31:0] in ,
	
	output reg [31:0] out 
	);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out <= 32'd0 ;
	end
	else begin
		if(wr_en) out <= in ;
	end
end

endmodule 