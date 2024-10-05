`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs.
module alu (
	input wire 	 	 	     clk , rst_n ,
	input wire signed [31:0] src_a       ,
	input wire signed [31:0] src_b       ,
	input wire  	  [5:0]  alu_control ,
	input wire  	  [4:0]  shamt       , // new 

	output reg 	  	  [31:0] hi , lo     ,
	output reg signed [31:0] alu_result 
	);
	
	// intermediate signals so that i can read them too 
	reg [31:0] hi_reg , lo_reg ;
	reg [31:0] unsigned_src_a , unsigned_src_b ;
	// RS --> src_a 
	// RT --> src_b
	// RD --> alu_result
	

	// hi and lo registers logic 
	always @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			hi <= 0 ;
			lo <= 0 ;

			hi_reg <= 0 ;
			lo_reg <= 0 ;
		end 
		else begin
			if (alu_control == 6'd17) begin   	   // mthi (move to hi)
				hi 	   <= src_a ;
				hi_reg <= src_a ;
			end 
			else if (alu_control == 6'd19) begin  // mtlo (move to lo)
				lo     <= src_a ;
				lo_reg <= src_a ;
			end 
		end  
	end



	always @(*) begin
		// initial value 
		alu_result = 32'd0 ;

		case (alu_control)
			
			6'd0 : alu_result = src_b <<  shamt   ; // sll
			6'd2 : alu_result = src_b >>  shamt   ; // srl
			6'd3 : alu_result = src_b >>> shamt   ; // sra
			6'd4 : alu_result = src_b <<  src_a[4:0] ; // sllv

			6'd6 : alu_result = src_b >>  src_a[4:0] ; //srlv 
			6'd7 : alu_result = src_b >>> src_a[4:0] ; //srav
			6'd8 : alu_result = src_a    	     ; // jr [RS]
			6'd9 : alu_result = src_a   	 	 ; // jalr [RS] 

			6'd16 : alu_result = hi_reg   	 		 ; // mfhi
			//6'd17 : alu_result = src_a    		 ; // mthi
			6'd18 : alu_result = lo_reg   	 		 ; // mflo
			//6'd19 : alu_result = src_a    		 ; // mtlo
		





			6'd24 : {hi , lo} = src_a   * src_b   ; // mult
			6'd25 : {hi , lo} = ($unsigned(src_a)) * ($unsigned(src_b)) ; // multu

			6'd26 : begin   	 	 	 	 	    // div
			 	lo = src_a / src_b ; 
			 	hi = src_a % src_b ;
			end 

			6'd27 : begin   	 	 	 	 	    // divu
			 	lo = ($unsigned(src_a)) / ($unsigned(src_b)) ; 
			 	hi = ($unsigned(src_a)) % ($unsigned(src_b)) ;
			end

		

			6'd32 : alu_result = src_a + src_b   ; // add  .. needs overflow handler
			6'd33 : alu_result = src_a + src_b   ; // addu 
			6'd34 : alu_result = src_a - src_b   ; // sub  .. needs overflow handler
			6'd35 : alu_result = src_a - src_b   ; // subu

			6'd36 : alu_result = src_a & src_b   ; // AND
			6'd37: alu_result = src_a  | src_b   ; // OR
			6'd38: alu_result = src_a ^ src_b    ; // XOR
			6'd39: alu_result = ~(src_a | src_b) ; // NOR

			6'd42 : alu_result = (src_a   < src_b  )? 32'd1 : 32'd0 ;
			6'd43 : begin 
					unsigned_src_a = src_a ;
					unsigned_src_b = src_b ;
					alu_result = ( src_a < src_b ) ? 32'd1 : 32'd0 ; //sltu
			        end 


			6'd45 : alu_result = src_a & src_b  ; // andi
			6'd46 : alu_result = src_a | src_b  ; // ori 
			6'd47 : alu_result = src_a ^ src_b  ; // xori

			6'd48 : alu_result = (src_a   < src_b  ) ? 32'd1 : 32'd0  ; // slti
			6'd49 : alu_result = (($unsigned(src_a)) < ($unsigned(src_b))) ? 32'd1 : 32'd0  ; // sltiu

			6'd50 : alu_result = {src_b[15:0] ,16'd0}  ; // lui

			6'd51 : alu_result = src_a * src_b  ; // 32-bit result mul

			



			default : begin 
				alu_result = 0 ;
			end 
		endcase 
	end

	 

endmodule : alu