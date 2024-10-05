module Branch_Control (
	input wire   	  Branch ,
	input wire [5:0]  opcode ,
	input wire [4:0]  Rt ,
	input wire [31:0] src_a ,
	input wire [31:0] src_b ,
	input wire  	  enable ,

	output reg Branch_Control
);

	always @(*) begin 
		if (enable) begin 
			if (Branch) begin 
				case (opcode)
				
					6'd4 : begin // beq 
							if(src_a == src_b) Branch_Control = 1 ;
							else   	  	 	   Branch_Control = 0 ;
					end

					6'd5 : begin // bne 
							if(src_a != src_b) Branch_Control = 1 ;
							else   	  	 	   Branch_Control = 0 ;
					end

					6'd6 : begin // blez 
							if(src_a[31] /* negative*/ || (~|src_a) /* src_a == 0*/)  Branch_Control = 1 ;	 
							else  Branch_Control = 0 ;
						
					end 

					6'd7 : begin // bgtz 
							if(!src_a[31] /* positive*/ && (|src_a) /* src_a != 0*/)  Branch_Control = 1 ;
							else Branch_Control = 0 ;
					end

					6'd1 : begin // bltz and bgez
							// if rt = 0 >>>>> bltz
							if (Rt == 5'd0) begin 
								if(src_a[31])  Branch_Control = 1 ;	 
								else   	 	   Branch_Control = 0 ;	
							end 

							// if rt = 1 >>>>> bgez
							else if (Rt == 5'd1) begin 
								if(!src_a[31] || (~|src_a) /* src_a == 0*/) Branch_Control = 1 ;
								else Branch_Control = 0 ; 
							end

							// neither >>>>> bgez
							else  Branch_Control = 0 ;
					end
					default : Branch_Control = 0 ;
				endcase

			end 
			else begin 
				Branch_Control = 0 ;
			end
		end 
		else begin 
			Branch_Control = 0 ;
		end 
	end

endmodule  