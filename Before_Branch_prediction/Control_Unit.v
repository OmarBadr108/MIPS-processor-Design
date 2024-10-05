`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs.
module control_unit (
	input wire [5:0] opcode ,
	input wire [5:0] funct  , // no need

	output reg 		 MemtoReg    , 
	output reg 		 MemWrite    ,
	output reg 		 Branch      ,
	output reg 		 AluSrc      ,
	output reg 	 	 RegDst      ,
	output reg 		 RegWrite    ,
	output reg  	 jump    	 ,
	output reg  	 Jr          ,
	output reg 	 	 link        ,
	output reg 	     Arith_u     ,
	output reg [1:0] ByteControl ,
	output reg [4:0] alu_opcode 
	);
	
	// for ByteControl 
	parameter [1:0] Wd  = 'd0 ,
			 	 	Hw  = 'd1 ,
			 	 	By  = 'd2 ;
	
 	always @(*) begin 
 		casex(opcode)

 			//------------------------------------------------------------
			// R-type
			//------------------------------------------------------------
 			6'b000_000 : begin // R-type
 				alu_opcode=5'b000_10 ; // go to the R-type table 
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=1 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch = 0 ; jump = 0 ; Arith_u =0 ;
 				if (funct == 6'd8) begin // jr
 					Jr   = 1 ;
 					link = 0 ;
 				end 
 				else if (funct == 6'd9) begin // jalr
 					Jr   = 1 ;
 					link = 1 ;
 				end 
 				else begin 
 					Jr   = 0 ;
 					link = 0 ;
 				end  
 			end


 			//------------------------------------------------------------
			// I-type
			//------------------------------------------------------------
 			6'd8 : begin // addi
 				alu_opcode=5'b000_00 ; // generic addition 
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ; Arith_u =0 ;
 			end 	

 			6'd9 : begin // addiu
 				alu_opcode=5'b000_00 ; // generic addition 
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ; Arith_u =0 ;
 			end 



 			6'd35 : begin // lw
 				alu_opcode=5'b000_00 ; // generic addition
 				ByteControl = Wd ; 
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=1 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end

 			6'd32 : begin // lb
 				alu_opcode=5'b000_00 ; // generic addition
 				ByteControl = By; 
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=1 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end

 			6'd33 : begin // lh
 				alu_opcode=5'b000_00 ; // generic addition
 				ByteControl = Hw ; 
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=1 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end

 			6'd36 : begin // lbu
 				alu_opcode=5'b000_00 ; // generic addition
 				ByteControl = By; 
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=1 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =1 ;
 			end

 			6'd37 : begin // lhu
 				alu_opcode=5'b000_00 ; // generic addition
 				ByteControl = Hw ; 
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=1 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =1 ;
 			end



 			6'd43 : begin // sw
 				alu_opcode=5'b000_00 ; // generic addition
 				ByteControl = Wd ; 
 				RegWrite=0 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=1 ; Branch=0 ; jump=0 ; Jr = 0 ; link =0 ;Arith_u =0 ;
 			end

 			6'd40 : begin // sb
 				alu_opcode=5'b000_00 ; // generic addition
 				ByteControl = By ; 
 				RegWrite=0 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=1 ; Branch=0 ; jump=0 ; Jr = 0 ; link =0 ;Arith_u =0 ;
 			end

 			6'd41 : begin // sh
 				alu_opcode=5'b000_00 ; // generic addition
 				ByteControl = Hw ; 
 				RegWrite=0 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=1 ; Branch=0 ; jump=0 ; Jr = 0 ; link =0 ;Arith_u =0 ;
 			end

 			6'd4 : begin // beq
 				alu_opcode=5'b000_11 ; // Branch family
 				ByteControl = Wd ;
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=1 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end

 			6'd5 : begin // bne
 				alu_opcode=5'b000_11 ; // Branch family 
 				ByteControl = Wd ;
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=1 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end

 			6'd6 : begin // blez
 				alu_opcode=5'b000_11 ; // Branch family 
 				ByteControl = Wd ;
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=1 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end

 			6'd7 : begin // bgtz
 				alu_opcode=5'b000_11 ; // Branch family
 				ByteControl = Wd ;
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=1 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end

 			6'd1 : begin // bltz and bgez
 				alu_opcode=5'b000_11 ; // Branch family 
 				ByteControl = Wd ;
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=1 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;	
 			end



 			6'd12 : begin // andi
 				alu_opcode=5'b001_00 ; // immdiate logical 
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ; Arith_u =1 ;
 			end

 			6'd13 : begin // ori
 				alu_opcode=5'b001_01 ; // immdiate logical 
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ; Arith_u =1 ;
 			end 
 			
 			6'd14 : begin // xori
 				alu_opcode=5'b001_10 ; // immdiate logical 
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ; Arith_u =1 ;
 			end





	 		6'd10 : begin // slti
 				alu_opcode=5'b001_11 ; // 7 
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ; Arith_u =0 ;
 			end	

 			6'd11 : begin // sltiu
 				alu_opcode=5'b010_00 ; // 8
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ; Arith_u =0 ;
 			end


 			6'd15 : begin // lui
 				alu_opcode=5'b010_01 ; // 9 
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=1 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end



 			6'd28 : begin // mul
 				alu_opcode=5'b010_10 ; // 10
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=1 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;link =0 ; Arith_u =0 ;
 			end


 			//------------------------------------------------------------
			// J-type
			//------------------------------------------------------------
 			6'd2 : begin // j
 				alu_opcode=5'b000_00 ; // Don't Care 
 				ByteControl = Wd ; 
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=1 ; Jr = 0 ;link =0 ;Arith_u =0 ;
 			end

 			6'd3 : begin // jal
 				alu_opcode=5'b000_00 ; // Don't Care  
 				ByteControl = Wd ;
 				RegWrite=1 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=1 ; Jr = 0 ;link =1 ;Arith_u =0 ;
 			end



 			default : begin // all zerozz
 				alu_opcode=5'b000_00 ; // go to the R-type table 
 				ByteControl = Wd ;
 				RegWrite=0 ; RegDst=0 ; AluSrc=0 ; MemtoReg=0 ; MemWrite=0 ; Branch=0 ; jump=0 ; Jr = 0 ;Arith_u =0 ;link =0 ;
 			end 

 		endcase 
 	end 
endmodule 