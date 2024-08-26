`timescale 1ns / 1ps
module alu (
	input wire signed [31:0] src_a ,
	input wire signed [31:0] src_b ,
	input wire  	  [2:0]  alu_control ,

	output wire  		     zero ,
	output reg signed [31:0] alu_result
	);

	always @(*) begin
		case (alu_control)
			3'b000 : alu_result = src_a & src_b    ;
			3'b001 : alu_result = src_a | src_b    ;
			3'b010 : alu_result = src_a + src_b    ;
			3'b100 : alu_result = src_a & (~src_b) ;
			3'b101 : alu_result = src_a | (~src_b) ;
			3'b110 : alu_result = src_a - src_b    ;
			3'b111 : alu_result = (src_a < src_b)? 32'd1 : 32'd0 ;

			default : alu_result = src_a ;
		endcase // alu_control
	end

	assign zero = ~|alu_result ;

endmodule : alu