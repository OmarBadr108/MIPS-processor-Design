`timescale 1ns / 1ps
module control_unit (
	input wire [5:0] opcode ,
	input wire [5:0] funct ,

	output reg 		 MemtoReg ,
	output reg 		 MemWrite ,
	output reg 		 Branch ,
	output reg 		 AluSrc ,
	output reg 	 	 RegDst ,
	output reg 		 RegWrite ,
	output reg  	 jump ,
	output reg [1:0] alu_opcode 
	);
	

	
 	always @(*) begin 
 		casex(opcode)

 			//------------------------------------------------------------
			// R-type
			//------------------------------------------------------------
 			6'b000_000 : begin // R-type
 				alu_opcode=2'b10 ; // go to the R-type table 
 				RegWrite=1 ; RegDst=1 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ;
 			end


 			//------------------------------------------------------------
			// I-type
			//------------------------------------------------------------
 			6'd8 : begin // addi
 				alu_opcode=2'b00 ; // generic addition 
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ;
 			end 	

 			6'd35 : begin // lw
 				alu_opcode=2'b00 ; // generic addition 
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=1 ; MemWrite=0 ; Branch=0 ; jump=0 ;
 			end

 			6'd43 : begin // sw
 				alu_opcode=2'b00 ; // generic addition 
 				RegWrite=0 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=1 ; Branch=0 ; jump=0 ;
 			end

 			6'd4 : begin // beq
 				alu_opcode=2'b01 ; // generic subtraction 
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=1 ; jump=0 ;
 			end


 			//------------------------------------------------------------
			// J-type
			//------------------------------------------------------------
 			6'd2 : begin // j
 				alu_opcode=2'b00 ; // Don't Care  
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=1 ;
 			end

 		endcase 
 	end 
endmodule 