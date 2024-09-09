`timescale 1ns / 1ps 
module zero_extend (
	input wire [15:0] instruction_imm ,

	output reg [31:0] zero_extend_imm 
	);

always @(*) begin
	zero_extend_imm = {16'd0 , instruction_imm} ;
end 

endmodule 