module Hazarad_Unit (
	input wire [4:0] Rs_D , Rt_D ,
	input wire [4:0] Rs_E , Rt_E ,
	input wire [4:0] WriteReg_W ,
	input wire [4:0] WriteReg_M ,
	input wire [4:0] WriteReg_E ,
	input wire       RegWrite_W ,
	input wire       MemtoReg_M , RegWrite_M ,
	input wire       MemtoReg_E , RegWrite_E ,
	input wire 		 Branch_D ,
	input wire 	 	 Jr_D ,
	output wire      JrStall ,
	output wire  	 LwStall_Jr ,

	output wire  	 ForwardA_D ,
	output wire   	 ForwardB_D ,
	output reg [1:0] ForwardA_E ,
	output reg [1:0] ForwardB_E ,
	output reg [1:0] ForwardRs_D ,
	output wire 	 Flush_E ,
	output wire 	 Stall_D ,
	output wire		 Stall_F
	);

	wire  LwStall , BranchStall  ;



	assign JrStall    =  (Jr_D) && ((Rs_D != 0) && (Rs_D == WriteReg_E) && (RegWrite_E)) ;
	//assign LwStall_Jr = ((Rs_D != 0) && (Rs_D == WriteReg_M) && (MemtoReg_M)) ;

	// in case of lw in say s0 then jr s0 >> it's required to stall 2 cycles on in --Excute-- and one in --Memory-- then forward the result from the Writeback stage
	assign LwStall_Jr = (Rs_D != 0) && ((Rs_D == WriteReg_M) || (Rs_D == WriteReg_E)) && (MemtoReg_M || MemtoReg_E) ;


	assign ForwardA_D = ((Rs_D != 0) && (Rs_D == WriteReg_M) && (RegWrite_M)) ;
	assign ForwardB_D = ((Rt_D != 0) && (Rt_D == WriteReg_M) && (RegWrite_M)) ;


	assign BranchStall = (Branch_D && RegWrite_E && (WriteReg_E == Rs_D || WriteReg_E == Rt_D)) 
	    	 	  	  || (Branch_D && MemtoReg_M && (WriteReg_M == Rs_D || WriteReg_M == Rt_D)) ;

	assign LwStall = ((Rs_D == Rt_E) || (Rt_D == Rt_E)) && MemtoReg_E ;

	assign Stall_F = LwStall | BranchStall | JrStall | LwStall_Jr ;
	assign Stall_D = LwStall | BranchStall | JrStall | LwStall_Jr ;
	assign Flush_E = LwStall | BranchStall | JrStall | LwStall_Jr ;

	


	always @(*) begin 
		if ((Rs_E != 0) && (Rs_E == WriteReg_M) && (RegWrite_M)) begin
			ForwardA_E = 'd2 ;
		end  

		else if ((Rs_E != 0) && (Rs_E == WriteReg_W) && (RegWrite_W)) begin
			ForwardA_E = 'd1 ;
		end 

		else begin 
			ForwardA_E = 'd0 ;
		end 
	end

	always @(*) begin 
		if ((Rt_E != 0) && (Rt_E == WriteReg_M) && (RegWrite_M)) begin
			ForwardB_E = 'd2 ;
		end  

		else if ((Rt_E != 0) && (Rt_E == WriteReg_W) && (RegWrite_W)) begin
			ForwardB_E = 'd1 ;
		end 

		else begin 
			ForwardB_E = 'd0 ;
		end 
	end

	always @(*) begin 
		if ((Rs_D != 0) && (Rs_D == WriteReg_M) && (RegWrite_M)) begin
			ForwardRs_D = 'd2 ; // forward ALUResult_M
		end  

		else if ((Rs_D != 0) && (Rs_D == WriteReg_W) && (RegWrite_W)) begin
			ForwardRs_D = 'd1 ; // forward Result_W
		end 

		else begin 
			ForwardRs_D = 'd0 ; // Directly get Rs from the regfile
		end 
	end


endmodule 