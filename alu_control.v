`timescale 1ns / 1ps
module alu_control (
	input wire [1:0] alu_opcode ,
	input wire [5:0] funct ,

	output reg [2:0] AluControl
	);

	//------------------------------------------------------------
	// AluControl logic
	//------------------------------------------------------------

	always @ (*) begin 
		casex ({alu_opcode, funct[3:0]}) // 2 + 4 = 6 bits
			6'b00_xxxx : AluControl = 3'b010 ; // ADD 
			6'b01_xxxx : AluControl = 3'b110 ; // SUB
			6'b10_0000 : AluControl = 3'b010 ; // ADD also 
			6'b10_0010 : AluControl = 3'b110 ; // SUB also
			6'b10_0100 : AluControl = 3'b000 ; // AND
			6'b10_0101 : AluControl = 3'b001 ; // OR
			6'b10_1010 : AluControl = 3'b111 ; // SLT
			// to be added inshallah 
			//6'b10_ 	   : AluControl = 3'b100 ; // A & !B
			//6'b10_ 	   : AluControl = 3'b101 ; // A | !B
 			default : AluControl = 3'b101 ; // ADD by Default
 		endcase 
 	end 
endmodule 