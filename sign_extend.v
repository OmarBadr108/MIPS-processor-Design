`timescale 1ns / 1ps 
module sign_extend (
	input wire [15:0] instruction_imm ,

	output reg [31:0] sign_imm 
	);

always @(*) begin
	sign_imm = {{16{instruction_imm [15]}} , instruction_imm} ;
end 

endmodule 