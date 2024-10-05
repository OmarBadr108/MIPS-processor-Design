`timescale 1ns / 1ps
module AND_GATE (
	input  wire branch_flag , zero_flag ,
	output wire	branch_control 
	);
	assign branch_control = branch_flag & zero_flag ;
endmodule 