`timescale 1ns / 1ps 
module Memory_WriteBack_Register #(
	parameter WIDTH_5 = 5 ,
	parameter WIDTH_32 = 32 
	)(

	input wire 		  clk , rst_n  , EN , CLR ,

	input wire 	 	 Jr_M ,
	output reg 	 	 Jr_W ,

	input wire 	 	 J_M ,
	output reg 	 	 J_W ,

	input wire 	 	 link_M ,
	output reg 	 	 link_W ,

	input wire [3:0] ByteControl_M ,
	output reg [3:0] ByteControl_W ,

	input wire 	 	 MemtoReg_M ,
	output reg 	 	 MemtoReg_W ,

	input wire 	 	 RegWrite_M ,
	output reg 	 	 RegWrite_W ,

	input wire 	 	 coprocessor_M ,
	output reg 	 	 coprocessor_W ,

	input wire [31:0] CO_M ,
	output reg [31:0] CO_W , 

	
	input wire [WIDTH_32-1:0] ALU_result_M ,
	output reg [WIDTH_32-1:0] ALU_result_W ,

	//input wire [WIDTH_32-1:0] ReadData_M ,
	//output reg [WIDTH_32-1:0] ReadData_W ,

	input wire [WIDTH_5-1:0] WriteReg_M ,
	output reg [WIDTH_5-1:0] WriteReg_W ,


	input wire [WIDTH_32-1:0] PC_plus_4_M ,
	output reg [WIDTH_32-1:0] PC_plus_4_W 

	);

always @(posedge clk) begin
	if (!rst_n) begin
		Jr_W  	 	  <= 'd0 ;
		J_W  	  	  <= 'd0 ;
		link_W  	  <= 'd0 ;
		ByteControl_W <= 'd0 ;
		MemtoReg_W    <= 'd0 ;
		RegWrite_W    <= 'd0 ;
		ALU_result_W  <= 'd0 ;
		//ReadData_W    <= 'd0 ;
		WriteReg_W    <= 'd0 ;
		PC_plus_4_W   <= 'd0 ;
		coprocessor_W <= 'd0 ;
		CO_W 		  <= 'd0 ;
	end
	else begin
		if (CLR) begin 
			Jr_W  	 	  <= 'd0 ;
			J_W  	  	  <= 'd0 ;
			link_W  	  <= 'd0 ;
			ByteControl_W <= 'd0 ;
			MemtoReg_W    <= 'd0 ;
			RegWrite_W    <= 'd0 ;
			ALU_result_W  <= 'd0 ;
			//ReadData_W    <= 'd0 ;
			WriteReg_W    <= 'd0 ;
			PC_plus_4_W   <= 'd0 ;
			coprocessor_W <= 'd0 ;
			CO_W 		  <= 'd0 ;
		end 
		else if (EN) begin 
			Jr_W  	 	  <= Jr_M ;
			J_W  	  	  <= J_M ;
			link_W  	  <= link_M ;
			ByteControl_W <= ByteControl_M ;
			MemtoReg_W    <= MemtoReg_M ;
			RegWrite_W    <= RegWrite_M ;
			ALU_result_W  <= ALU_result_M ;
			//ReadData_W    <= ReadData_M ;
			WriteReg_W    <= WriteReg_M ;
			PC_plus_4_W   <= PC_plus_4_M ;
			coprocessor_W <= coprocessor_M ;
			CO_W 		  <= CO_M ;
		end 
	end
end

endmodule 