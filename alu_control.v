`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs.
module alu_control (
	input wire [4:0] alu_opcode ,
	input wire [5:0] funct ,
	
	output reg [5:0] AluControl
	);

	//------------------------------------------------------------
	// AluControl logic
	//------------------------------------------------------------

	always @ (*) begin 
		// intial value 
		AluControl = 0 ;

		casex ({alu_opcode, funct}) // 5 + 6 = 11 bits
			11'b00000_xxxxxx : AluControl = 6'd32 ; // ADD 
			11'b00001_xxxxxx : AluControl = 6'd34 ; // SUB

			
			{5'b00010,6'd0} : AluControl = 6'd0 ; // sll or nop
			
			{5'b00010,6'd2} : AluControl = 6'd2 ; // srl
			{5'b00010,6'd3} : AluControl = 6'd3 ; // sra
			{5'b00010,6'd4} : AluControl = 6'd4 ; // sllv

			{5'b00010,6'd6} : AluControl = 6'd6 ; // srlv
			{5'b00010,6'd7} : AluControl = 6'd7 ; // srav
			{5'b00010,6'd8} : AluControl = 6'd8 ; // jr
			{5'b00010,6'd9} : AluControl = 6'd9 ; // jalr

			{5'b00010,6'd16} : begin 
								AluControl   = 6'd16 ; // mfhi
						    end

			{5'b00010,6'd17} : begin 
								AluControl   = 6'd17 ; // mthi
							end 

			{5'b00010,6'd18} : begin 
								AluControl   = 6'd18 ; // mflo
							end 

			{5'b00010,6'd19} : begin 
								AluControl   = 6'd19 ; // mtlo
							end 
							
			{5'b00010,6'd24} : AluControl = 6'd24 ; // mult
			{5'b00010,6'd25} : AluControl = 6'd25 ; // multu
			{5'b00010,6'd26} : AluControl = 6'd26 ; // div
			{5'b00010,6'd27} : AluControl = 6'd27 ; // divu

			{5'b00010,6'd32} : AluControl = 6'd32 ; // add
			{5'b00010,6'd33} : AluControl = 6'd33 ; // addu 
			{5'b00010,6'd34} : AluControl = 6'd34 ; // sub
			{5'b00010,6'd35} : AluControl = 6'd35 ; // subu 
			{5'b00010,6'd36} : AluControl = 6'd36 ; // and
			{5'b00010,6'd37} : AluControl = 6'd37 ; // or
			{5'b00010,6'd38} : AluControl = 6'd38 ; // xor
			{5'b00010,6'd39} : AluControl = 6'd39 ; // nor

			{5'b00010,6'd42} : AluControl = 6'd42 ; // slt
			{5'b00010,6'd43} : AluControl = 6'd43 ; // sltu
			


			{5'b00011,6'bxxx_xxx} : AluControl = 6'd44 ; // Branch family
			
			{5'b00100,6'bxxx_xxx} : AluControl = 6'd45 ; // andi
			{5'b00101,6'bxxx_xxx} : AluControl = 6'd46 ; // ori
			{5'b00110,6'bxxx_xxx} : AluControl = 6'd47 ; // xori

			{5'b00111,6'bxxx_xxx} : AluControl = 6'd48 ; // slti
			{5'b01000,6'bxxx_xxx} : AluControl = 6'd49 ; // sltiu

			{5'b01001,6'bxxx_xxx} : AluControl = 6'd50 ; // lui

			{5'b01010,6'bxxx_xxx} : AluControl = 6'd51 ; // 32-bit result mul

 			default : begin 
 						AluControl   = 6'd32 ; // ADD by Default
 					end 
 		endcase 
 	end 

endmodule 