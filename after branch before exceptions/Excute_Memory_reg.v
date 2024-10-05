`timescale 1ns / 1ps 
module Excute_Memory_Register #(
	parameter WIDTH_5 = 5 ,
	parameter WIDTH_32 = 32 
	)(

	input wire 		  clk , rst_n  , EN , CLR ,

	input wire 	 	 Jr_E ,
	output reg 	 	 Jr_M ,

	input wire 	 	 J_E ,
	output reg 	 	 J_M ,

	input wire 	 	 link_E ,
	output reg 	 	 link_M ,

	input wire [3:0] ByteControl_E ,
	output reg [3:0] ByteControl_M ,

	input wire 	 	 MemtoReg_E ,
	output reg 	 	 MemtoReg_M ,
	

	input wire 	 	 MemWrite_E ,
	output reg 	 	 MemWrite_M ,

	input wire 	 	 RegWrite_E ,
	output reg 	 	 RegWrite_M ,

	
	input wire [WIDTH_32-1:0] ALU_result_E ,
	output reg [WIDTH_32-1:0] ALU_result_M ,

	input wire [WIDTH_32-1:0] WriteData_E ,
	output reg [WIDTH_32-1:0] WriteData_M ,

	input wire [WIDTH_5-1:0] WriteReg_E ,
	output reg [WIDTH_5-1:0] WriteReg_M ,


	input wire [WIDTH_32-1:0] PC_plus_4_E ,
	output reg [WIDTH_32-1:0] PC_plus_4_M 

	);

always @(posedge clk) begin
	if (!rst_n) begin
		Jr_M  	 	  <= 'd0 ;
		J_M  	  	  <= 'd0 ;
		link_M  	  <= 'd0 ;
		ByteControl_M <= 'd0 ;
		MemtoReg_M    <= 'd0 ;
		RegWrite_M    <= 'd0 ;
		MemWrite_M    <= 'd0 ;
		ALU_result_M  <= 'd0 ;
		WriteData_M   <= 'd0 ;
		WriteReg_M    <= 'd0 ;
		PC_plus_4_M   <= 'd0 ;
		
	end
	else begin
		if (CLR) begin 
			Jr_M  	 	  <= 'd0 ;
			J_M  	  	  <= 'd0 ;
			link_M  	  <= 'd0 ;
			ByteControl_M <= 'd0 ;
			MemtoReg_M    <= 'd0 ;
			RegWrite_M    <= 'd0 ;
			MemWrite_M    <= 'd0 ;
			ALU_result_M  <= 'd0 ;
			WriteData_M   <= 'd0 ;
			WriteReg_M    <= 'd0 ;
			PC_plus_4_M   <= 'd0 ;
		end 
		else if (EN) begin 
			Jr_M  	 	  <= Jr_E	  	   ;
			J_M  	  	  <= J_E 	  	   ;
			link_M  	  <= link_E  	   ;
			ByteControl_M <= ByteControl_E ;
			MemtoReg_M    <= MemtoReg_E    ;
			RegWrite_M    <= RegWrite_E    ;
			MemWrite_M    <= MemWrite_E ;
			ALU_result_M  <= ALU_result_E  ;
			WriteData_M   <= WriteData_E   ;
			WriteReg_M    <= WriteReg_E 	 	   ;
			PC_plus_4_M   <= PC_plus_4_E   ;
		end 
	end
end

endmodule 