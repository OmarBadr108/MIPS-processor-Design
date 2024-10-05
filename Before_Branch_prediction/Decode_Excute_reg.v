`timescale 1ns / 1ps 
module Decode_Excute_Register #(
	parameter WIDTH_5 = 5 ,
	parameter WIDTH_32 = 32 
	)(

	input wire 		  clk , rst_n  , EN , CLR ,

	input wire 	 	 Jr_D ,
	output reg 	 	 Jr_E ,

	input wire 	 	 J_D ,
	output reg 	 	 J_E ,

	input wire 	 	 link_D ,
	output reg 	 	 link_E ,

	input wire [1:0] ByteControl_D ,
	output reg [1:0] ByteControl_E ,

	input wire 	 	 MemtoReg_D ,
	output reg 	 	 MemtoReg_E ,

	input wire 	 	 MemWrite_D ,
	output reg 	 	 MemWrite_E ,

	input wire [4:0] Alu_opcode_D ,
	output reg [4:0] Alu_opcode_E ,

	input wire 	 	 ALUSrc_D ,
	output reg 	 	 ALUSrc_E ,

	input wire 	 	 RegDst_D ,
	output reg 	 	 RegDst_E ,

	input wire 	 	 RegWrite_D ,
	output reg 	 	 RegWrite_E ,

	input wire 	 	 Arith_u_D ,
	output reg 	 	 Arith_u_E ,

	input wire [5:0] funct_D ,
	output reg [5:0] funct_E ,

	input wire [5:0] opcode_D ,
	output reg [5:0] opcode_E ,

	input wire [WIDTH_32-1:0] src_a_D ,
	output reg [WIDTH_32-1:0] src_a_E ,

	input wire [WIDTH_32-1:0] src_b_D ,
	output reg [WIDTH_32-1:0] src_b_E ,

	input wire [WIDTH_32-1:0] SignExt_D ,
	output reg [WIDTH_32-1:0] SignExt_E ,

	input wire [WIDTH_32-1:0] ZeroExt_D ,
	output reg [WIDTH_32-1:0] ZeroExt_E ,

	
	input wire [WIDTH_5-1:0] shamt_D ,
	output reg [WIDTH_5-1:0] shamt_E ,

	input wire [WIDTH_5-1:0] Rt_D ,
	output reg [WIDTH_5-1:0] Rt_E ,
	
	input wire [WIDTH_5-1:0] Rd_D ,
	output reg [WIDTH_5-1:0] Rd_E ,

	input wire [WIDTH_5-1:0] Rs_D ,
	output reg [WIDTH_5-1:0] Rs_E ,

	input wire [WIDTH_32-1:0] PC_plus_4_D ,
	output reg [WIDTH_32-1:0] PC_plus_4_E 

	);

always @(posedge clk) begin
	if (!rst_n) begin
		Jr_E  	 	  <= 'd0 ;
		J_E  	  	  <= 'd0 ;
		link_E  	  <= 'd0 ;
		ByteControl_E <= 'd0 ;
		MemtoReg_E    <= 'd0 ;
		MemWrite_E    <= 'd0 ;
		Alu_opcode_E  <= 'd0 ;
		ALUSrc_E      <= 'd0 ;
		RegDst_E   	  <= 'd0 ;
		RegWrite_E    <= 'd0 ;
		Arith_u_E  	  <= 'd0 ;
		funct_E  	  <= 'd0 ;
		opcode_E  	  <= 'd0 ;
		src_a_E  	  <= 'd0 ;
		src_b_E  	  <= 'd0 ;
		SignExt_E     <= 'd0 ;
		ZeroExt_E 	  <= 'd0 ;
		shamt_E 	  <= 'd0 ;
		Rt_E  		  <= 'd0 ;
		Rd_E 		  <= 'd0 ;
		Rs_E 	 	  <= 'd0 ;
		PC_plus_4_E   <= 'd0 ;
	end
	else begin
		
		if (EN) begin 
			Jr_E  	 	  <= Jr_D ;
			J_E  	  	  <= J_D  ;
			link_E  	  <= link_D        ;
			ByteControl_E <= ByteControl_D ;
			MemtoReg_E    <= MemtoReg_D  ;
			MemWrite_E    <= MemWrite_D  ;
			Alu_opcode_E  <= Alu_opcode_D;
			ALUSrc_E      <= ALUSrc_D    ;
			RegDst_E   	  <= RegDst_D    ;
			RegWrite_E    <= RegWrite_D  ;
			Arith_u_E  	  <= Arith_u_D   ;
			funct_E  	  <= funct_D     ;
			opcode_E  	  <= opcode_D    ;
			src_a_E  	  <= src_a_D     ;
			src_b_E  	  <= src_b_D     ;
			SignExt_E     <= SignExt_D   ;
			ZeroExt_E 	  <= ZeroExt_D   ;
			shamt_E 	  <= shamt_D     ;
			Rt_E  		  <= Rt_D 	  	 ;
			Rd_E 		  <= Rd_D        ;
			Rs_E 	 	  <= Rs_D 	  	 ;
			PC_plus_4_E   <= PC_plus_4_D ;
		end 

		else if (CLR) begin 
			Jr_E  	 	  <= 'd0 ;
			J_E  	  	  <= 'd0 ;
			link_E  	  <= 'd0 ;
			ByteControl_E <= 'd0 ;
			MemtoReg_E    <= 'd0 ;
			MemWrite_E    <= 'd0 ;
			Alu_opcode_E  <= 'd0 ;
			ALUSrc_E      <= 'd0 ;
			RegDst_E   	  <= 'd0 ;
			RegWrite_E    <= 'd0 ;
			Arith_u_E  	  <= 'd0 ;
			funct_E  	  <= 'd0 ;
			opcode_E  	  <= 'd0 ;
			src_a_E  	  <= 'd0 ;
			src_b_E  	  <= 'd0 ;
			SignExt_E     <= 'd0 ;
			ZeroExt_E 	  <= 'd0 ;
			shamt_E 	  <= 'd0 ;
			Rt_E  		  <= 'd0 ;
			Rd_E 		  <= 'd0 ;
			Rs_E 	 	  <= 'd0 ;
			PC_plus_4_E   <= 'd0 ;
		end 
	end
end

endmodule 