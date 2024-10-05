`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs. 
module mips_top(
	input wire  	   clk , rst_n,
	input wire         wr_en_ins ,
	input wire  	   Interrupt ,
	input wire  [31:0] wr_data ,

	output wire [4:0] wr_data3  // to prevent optimization 
);


wire [31:0] wr_data3_new ;

assign wr_data3 =  wr_data3_new[4:0] ;



//--------------------------------------------------
// Decode Stage Connections
//--------------------------------------------------
wire [31:0] INSTRUCTION_D ;

wire [31:0] rd_data1 , rd_data2 ;
wire [4:0]  wr_addr3 ;


wire [31:0] hi_reg ,lo_reg ;

wire [5:0]  AluControl ;


wire [31:0] PCBranch_result_D ;

wire branch_control_D ;

wire [31:0] sign_imm_shifted ;

wire [31:0] jump_shifted_D ;

wire [31:0] Byte_Control_out_W ;


wire [4:0] shamt_D ;



//--------------------------------------------------
// Hazard Unit      --- DONE ---		
//--------------------------------------------------

wire Branch_D ;
wire 	   ForwardA_D ;
wire       ForwardB_D ;
wire [1:0] ForwardA_E ;
wire [1:0] ForwardB_E ;
wire [1:0] ForwardRs_D ;

wire Flush_E ;
wire Stall_D ;
wire Stall_F ;



//--------------------------------------------------
// Ftech_Decode_Register     --- DONE ---		
//--------------------------------------------------
wire [31:0] PC_F , PC_W ;
wire [31:0] INSTRUCTION_F ;
wire [31:0] PC_plus_4_F   ;



//--------------------------------------------------
// Decode_Excute_Register      --- DONE ---    		
//--------------------------------------------------

wire [31:0] PC_plus_4_D, PC_plus_4_E;
wire        Jr_D, Jr_E;
wire        J_D, J_E ;
wire        link_D, link_E;
wire [3:0]  ByteControl_D, ByteControl_E;
wire        MemtoReg_D, MemtoReg_E;
wire        MemWrite_D, MemWrite_E;
wire [4:0]  Alu_opcode_D, Alu_opcode_E;
wire        AluSrc_D ;
wire  	    ALUSrc_E;
wire        RegDst_D, RegDst_E;
wire        RegWrite_D, RegWrite_E;
wire        Arith_u_D, Arith_u_E;
wire [5:0]  funct_D, funct_E;
wire [5:0]  opcode_D, opcode_E;
wire [31:0] src_a_D, src_a_E;
wire [31:0] src_b_D, src_b_E;
wire [31:0] SignExt_D, SignExt_E;
wire [31:0] ZeroExt_D, ZeroExt_E;
wire [4:0]  shamt_E ;
wire [4:0]  Rt_D, Rt_E;
wire [4:0]  Rd_D, Rd_E;
wire [4:0]  Rs_D, Rs_E;
 


//--------------------------------------------------
// Excute Stage Connections     --- DONE ---
//--------------------------------------------------
wire        Jr_M;
wire        J_M;
wire        link_M;
wire [3:0]  ByteControl_M;
wire        MemtoReg_M;
wire        RegWrite_M;
wire [31:0] ALU_result_M;
wire [31:0] WriteData_M;
wire [4:0]  WriteReg_M;
wire [31:0] PC_plus_4_M;
wire [31:0] ALU_result_E ;
wire  	    MemWrite_M ; 




//--------------------------------------------------
// Memory Stage Connections     --- DONE ---
//--------------------------------------------------
wire        Jr_W;
wire        J_W;
wire        link_W;
wire [3:0]  ByteControl_W;
wire        MemtoReg_W;
wire        RegWrite_W;
wire [31:0] ALU_result_W;
wire [31:0] ReadData_W;
wire [4:0]  WriteReg_W;
wire [31:0] PC_plus_4_W;
wire [31:0] ReadData_M ;


//--------------------------------------------------
// ALU  		-- DONE -- 
//--------------------------------------------------
wire [31:0] src_a , src_b ;


//--------------------------------------------------
// src_b Mux  Excution stage 	[Right before ALU]	-- DONE --
//--------------------------------------------------
wire [31:0] src_b_muxout_muxin ;


//--------------------------------------------------
// Rt vs Rd Mux    -- DONE --
//--------------------------------------------------
wire [4:0] WriteReg_E ;

//wire Stall_D , Stall_F ;

//--------------------------------------------------
// Jump    -- DONE --
//--------------------------------------------------

wire [31:0] jump_addr_D ;

wire [31:0] Jr_mux_out_W ;

wire LwStall_Jr_D ,JrStall_D ;

wire enable ;


//--------------------------------------------------
// Exceptions    -- DONE --
//--------------------------------------------------
wire break_point_D ;
wire break_point_E ;
wire break_point ;
assign break_point = break_point_E | break_point_D ;
wire overflow_E ;
wire syscall_D ;
wire undef_D ;
wire [31:0] EPC ;
wire [31:0] Cause_mux_out_reg_in ;
wire [31:0] Cause ;
wire [2:0]  int_cause ;
wire  	    coprocessor_D ;
wire  	    coprocessor_E ;
wire  	    coprocessor_M ;
wire  	    coprocessor_W ;
wire [31:0] CO_D ;
wire [31:0] CO_E ;
wire [31:0] CO_M ;
wire [31:0] CO_W ;

wire [31:0] PC_NEXT_W ;
wire  	  	Exception ;
assign Exception = (Interrupt | undef_D | syscall_D | overflow_E | break_point) ;

assign opcode_D = INSTRUCTION_D[31:26] ;
assign Rs_D     = INSTRUCTION_D[25:21] ;
assign Rt_D     = INSTRUCTION_D[20:16] ;
assign Rd_D     = INSTRUCTION_D[15:11] ;
assign shamt_D  = INSTRUCTION_D[10:6]  ;
assign funct_D  = INSTRUCTION_D[5:0]   ;

// Branch Predictor signals 
wire [31:0] Branch_predictor_target ;
wire  	    Misprediction_for_taken ;
wire  	    Misprediction_for_not_taken ;
wire  		Branch_Predictor_sel ;
wire [31:0] prediction_mux_out_W ;
wire [31:0] PC_D ;
wire [31:0] PCBranch_result_E ;

wire Misprediction_for_taken_Delayed ;
wire Misprediction_for_not_taken_Delayed ;
wire Double_Branch_stall ;



wire [31:0] PC_Decoder_F ;
wire [31:0] INSTRUCTION_D_EX ;
wire [31:0] INSTRUCTION_D_INS ;
wire selector ;
//--------------------------------------------------
// Hazard Unit      --- DONE ---		
//--------------------------------------------------

Hazarad_Unit Hazarad_Unit_DUT (
	.Rs_D        (Rs_D),        // 5
	.Rt_D        (Rt_D),        // 5
	.Rs_E        (Rs_E),        // 5
	.Rt_E        (Rt_E),        // 5
	.WriteReg_W  (WriteReg_W),  // 5
	.WriteReg_M  (WriteReg_M),  // 5
	.WriteReg_E  (WriteReg_E),  // 5
	.RegWrite_W  (RegWrite_W),  // 1
	.MemtoReg_M  (MemtoReg_M),  // 1
	.RegWrite_M  (RegWrite_M),  // 1
	.MemtoReg_E  (MemtoReg_E),  // 1
	.RegWrite_E  (RegWrite_E),  // 1
	.Branch_D    (Branch_D),    // 1
	.Jr_D  	 	 (Jr_D),  	 	// 1

	.JrStall     (JrStall_D),   // 1
	.LwStall_Jr  (LwStall_Jr_D),// 1
	.ForwardA_D  (ForwardA_D),  // 1
	.ForwardB_D  (ForwardB_D),  // 1
	.ForwardA_E  (ForwardA_E),  // 2
	.ForwardB_E  (ForwardB_E),  // 2
	.ForwardRs_D (ForwardRs_D), // 2
	.Flush_E     (Flush_E),     // 1
	.Stall_D     (Stall_D),     // 1
	.Stall_F     (Stall_F)      // 1
);


//--------------------------------------------------
// Jr_Hazard Mux
//--------------------------------------------------
wire Jr_stall_mux_out ;

gen_mux #(1,2) Jr_Hazard (
	.data_in ({1'b0 ,Jr_M ,Jr_E , Jr_D}),
	.ctrl_sel({LwStall_Jr_D , JrStall_D}),
	.data_out(Jr_stall_mux_out)
	); 



//--------------------------------------------------
// Ftech_Decode_Register     --- DONE ---		
//--------------------------------------------------

Fetch_Decode_Register Fetch_Decode_Register_DUT (
	.clk  (clk),
	.rst_n (rst_n) ,
	.EN   (!Stall_D),
	.CLR  ((branch_control_D | J_D | Jr_stall_mux_out | Misprediction_for_taken_Delayed | Misprediction_for_not_taken_Delayed)),
	//.INSTRUCTION_F (INSTRUCTION_F),
	.PC_plus_4_F  (PC_plus_4_F),
	.PC_F(PC_F), // 32
	.PC_D (PC_D) ,

	//.INSTRUCTION_D(INSTRUCTION_D),
	.PC_plus_4_D(PC_plus_4_D)
	);


//--------------------------------------------------
// Decode_Excute_Register      --- DONE ---    		
//--------------------------------------------------

Decode_Excute_Register Decode_Excute_Register_DUT (
	.clk  (clk),
	.rst_n (rst_n) ,
	.EN   (1'b1), // 1
	.CLR  (Flush_E), // 1
	.PC_plus_4_D  (PC_plus_4_D), // 32
	.PC_plus_4_E  (PC_plus_4_E), // 32
	.Jr_D         (Jr_D), // 1
	.Jr_E         (Jr_E), // 1
	.J_D          (J_D), //1
	.J_E          (J_E), //1
	.link_D       (link_D), //1 
	.link_E       (link_E), // 1
	.ByteControl_D(ByteControl_D), // 4
	.ByteControl_E(ByteControl_E),
	.MemtoReg_D   (MemtoReg_D), //1 
	.MemtoReg_E   (MemtoReg_E),
	.MemWrite_D   (MemWrite_D), //1
	.MemWrite_E   (MemWrite_E),
	.Alu_opcode_D (Alu_opcode_D), //5
	.Alu_opcode_E (Alu_opcode_E),
	.ALUSrc_D     (AluSrc_D), //1
	.ALUSrc_E     (ALUSrc_E),
	.RegDst_D     (RegDst_D), // 1
	.RegDst_E     (RegDst_E),
	.RegWrite_D   (RegWrite_D), // 1
	.RegWrite_E   (RegWrite_E),
	.Arith_u_D    (Arith_u_D), // 1
	.Arith_u_E    (Arith_u_E),
	.funct_D      (funct_D), // 6
	.funct_E      (funct_E),
	.opcode_D     (opcode_D), // 6
	.opcode_E     (opcode_E),
	.src_a_D      (src_a_D),  // 32
	.src_a_E      (src_a_E),
	.src_b_D      (src_b_D), //32
	.src_b_E      (src_b_E),
	.SignExt_D    (SignExt_D), // 32
	.SignExt_E    (SignExt_E),
	.ZeroExt_D    (ZeroExt_D),//32
	.ZeroExt_E    (ZeroExt_E),
	.coprocessor_D    (coprocessor_D),
	.coprocessor_E    (coprocessor_E),
	.CO_D             (CO_D),
	.CO_E             (CO_E),
	.PCBranch_result_D (PCBranch_result_D),
	.PCBranch_result_E (PCBranch_result_E), //32
	.shamt_D  	  (shamt_D), // 5
	.shamt_E  	  (shamt_E),
	.Rt_D         (Rt_D),//5
	.Rt_E         (Rt_E),
	.Rd_D         (Rd_D),//5
	.Rd_E         (Rd_E),
	.Rs_D         (Rs_D),//5
	.Rs_E         (Rs_E)
	);


//--------------------------------------------------
// Excute Stage Connections     --- DONE ---
//--------------------------------------------------

Excute_Memory_Register Excute_Memory_Register_DUT (
	.clk           (clk),           // 1
	.rst_n         (rst_n),         // 1
	.EN            (1'b1),          // 1
	.CLR           (1'b0),          // 1

	.Jr_E          (Jr_E),          // 1
	.Jr_M          (Jr_M),          // 1

	.J_E           (J_E),           // 1
	.J_M           (J_M),           // 1

	.link_E        (link_E),        // 1
	.link_M        (link_M),        // 1

	.ByteControl_E (ByteControl_E), // 4
	.ByteControl_M (ByteControl_M), // 4

	.CO_E         (CO_E),
	.CO_M         (CO_M),	

	.coprocessor_E(coprocessor_E),
	.coprocessor_M(coprocessor_M),

	.MemtoReg_E    (MemtoReg_E),    // 1
	.MemtoReg_M    (MemtoReg_M),    // 1

	.MemWrite_E    (MemWrite_E),    // 1
	.MemWrite_M    (MemWrite_M),    // 1

	.RegWrite_E    (RegWrite_E),    // 1
	.RegWrite_M    (RegWrite_M),    // 1

	.ALU_result_E  (ALU_result_E),  // 32
	.ALU_result_M  (ALU_result_M),  // 32

	.WriteData_E   (src_b_muxout_muxin),   // 32
	.WriteData_M   (WriteData_M),   // 32

	.WriteReg_E    (WriteReg_E),    // 5
	.WriteReg_M    (WriteReg_M),    // 5

	.PC_plus_4_E   (PC_plus_4_E),   // 32
	.PC_plus_4_M   (PC_plus_4_M)    // 32
);

//--------------------------------------------------
// Memory Stage Connections     --- DONE ---
//--------------------------------------------------

Memory_WriteBack_Register Memory_WriteBack_Register_DUT (
	.clk           (clk),           // 1
	.rst_n         (rst_n),         // 1
	.EN            (1'b1),          // 1
	.CLR           (1'b0),          // 1

	.Jr_M          (Jr_M),          // 1
	.Jr_W          (Jr_W),          // 1

	.J_M           (J_M),           // 1
	.J_W           (J_W),           // 1

	.link_M        (link_M),        // 1
	.link_W        (link_W),        // 1

	.CO_M         (CO_M), 	   	    // 32
	.CO_W         (CO_W),

	.coprocessor_M(coprocessor_M),  // 1
	.coprocessor_W(coprocessor_W),

	.ByteControl_M (ByteControl_M), // 4
	.ByteControl_W (ByteControl_W), // 4

	.MemtoReg_M    (MemtoReg_M),    // 1
	.MemtoReg_W    (MemtoReg_W),    // 1

	.RegWrite_M    (RegWrite_M),    // 1
	.RegWrite_W    (RegWrite_W),    // 1

	.ALU_result_M  (ALU_result_M),  // 32
	.ALU_result_W  (ALU_result_W),  // 32

	//.ReadData_M    (ReadData_M),    // 32
	//.ReadData_W    (ReadData_W),    // 32

	.WriteReg_M    (WriteReg_M),    // 5
	.WriteReg_W    (WriteReg_W),    // 5

	.PC_plus_4_M   (PC_plus_4_M),   // 32
	.PC_plus_4_W   (PC_plus_4_W)    // 32
);



//--------------------------------------------------
// Write back Stage Connections     --- DONE ---
//--------------------------------------------------
WriteBack_Ftech_Register WriteBack_Ftech_Register_DUT (
	.clk    (clk),        // 1
	.rst_n  (rst_n),      // 1
	.EN     ((!Stall_F) | Double_Branch_stall),         // 1
	.CLR    (1'b0),        // 1
	.PC_W   (PC_NEXT_W),   // PC_next    // 32
	.PC_F   (PC_F)        // 32
);


//--------------------------------------------------
// Branch Predictor     --- DONE ---
//--------------------------------------------------

Branch_Predictor Branch_Predictor_DUT (
	.clk    	 	  		 	 (clk),  // 1
	.rst_n    	 	  		 	 (rst_n),// 1
	.branch_taken_D   	 	 	 (branch_control_D),     // 1
	.PCBranch_result_D      	 (PCBranch_result_D),     // 32
	.PC_D    	 	 	 	 	 (PC_D),     // 32
	.Branch_D   	 	 	 	 (Branch_D),     // 1   
	.PC_F   	 	 	 	     (PC_F),     // 32
	.Stall_D                      (Stall_D),  // 1

	.Branch_predictor_target	 	 	 (Branch_predictor_target),	 // 32
	.Misprediction_for_taken 	 	 	 (Misprediction_for_taken), 	 // 1
	.Misprediction_for_not_taken  	 	 (Misprediction_for_not_taken), 	 // 1
	.Misprediction_for_taken_Delayed 	 (Misprediction_for_taken_Delayed), 	 // 1
	.Misprediction_for_not_taken_Delayed (Misprediction_for_not_taken_Delayed), 	 // 1
	.Branch_Predictor_sel         		 (Branch_Predictor_sel), 	 // 1
	.Double_Branch_stall 	 	  	 	 (Double_Branch_stall)       //1
);


//--------------------------------------------------
// Generic Mux
//--------------------------------------------------

gen_mux #(32,3) Prediction_mux (
	.data_in ({32'd0,32'd0,32'd0, PC_plus_4_E ,32'd0, PCBranch_result_E , Branch_predictor_target , PC_W}),
	.ctrl_sel({Misprediction_for_not_taken_Delayed , Misprediction_for_taken_Delayed , Branch_Predictor_sel}),
	.data_out(prediction_mux_out_W)
	);

//--------------------------------------------------
// Instruction Memory   		-- DONE --
//--------------------------------------------------
ins_memory #(.WIDTH(8) , .DEPTH(512) , .ADD_WIDTH(9)) instruction_mem ( // 4 KB
	.clk     (clk),
	.rst_n 	 (rst_n),
	.EN 	 (!(Stall_D)),
	.CLR 	 ((branch_control_D | J_D | Jr_stall_mux_out)),
	.wr_en   (wr_en_ins), // 1 
	.addr    (PC_Decoder_F[8:0]),  	  // 32
	.wr_data (wr_data), 	 	  // 32
	.ByteControl(4'b1111),  	  // 4

	.rd_data (INSTRUCTION_D_INS)  // 32
	);

//--------------------------------------------------
// PC_plus_4   		-- DONE --
//--------------------------------------------------
PC_plus_4 PC_plus_4_DUT (
	.in  (PC_F), // 32

	.out (PC_plus_4_F)  // 32
	);


//--------------------------------------------------
// Sign Extension   		-- DONE --
//--------------------------------------------------
sign_extend sign_extend_D (
	.instruction_imm ({Rd_D ,shamt_D ,funct_D}), // 16
 
	.sign_imm		 (SignExt_D)  // 32
	);


//--------------------------------------------------
// Zero Extension   		-- DONE --
//--------------------------------------------------
zero_extend zero_extend_D (
	.instruction_imm ({Rd_D ,shamt_D ,funct_D}), // 16
 
	.zero_extend_imm		 (ZeroExt_D)  // 32
	);

//--------------------------------------------------
// register_file   		-- DONE --
//--------------------------------------------------
register_file register_file_D (
	.clk      (clk), 
	.rst_n 	  (rst_n), 
	.wr_en3   (RegWrite_W), // 1
	.rd_addr1 (Rs_D), // 5
	.rd_addr2 (Rt_D), // 5
	.wr_addr3 (wr_addr3), // 5
	.wr_data3 (wr_data3_new), // 32

	.rd_data1 (rd_data1), // 32
	.rd_data2 (rd_data2)  // 32

	);

//--------------------------------------------------
// Control Unit   		-- DONE --
//--------------------------------------------------
control_unit control_unit_D (
	.opcode     (opcode_D), // 6
	.funct      (funct_D), // 6
 
	.MemtoReg   (MemtoReg_D), // 1
	.MemWrite   (MemWrite_D), // 1
	.Branch     (Branch_D), // 1
	.AluSrc     (AluSrc_D), // 1 
	.RegDst     (RegDst_D), // 1 
	.RegWrite   (RegWrite_D), // 1
	.jump       (J_D), // 1
	.Jr	  	    (Jr_D), // 1
	.link 	 	(link_D), // 1
	.Arith_u    (Arith_u_D), // 1
	.coprocessor   (coprocessor_D), //1
	.undef_D       (undef_D),  		//1
	.syscall_D     (syscall_D),  	//1
	.break_point_D (break_point_D), //1

	.ByteControl(ByteControl_D),  	// 4
	.alu_opcode (Alu_opcode_D)   	// 5
	);

//--------------------------------------------------
// Branch Control unit  		
//--------------------------------------------------
 Branch_Control Branch_Control_DUT (
 	.Rt             (Rt_D), // 5
 	.Branch         (Branch_D), // 1
 	.src_a          (src_a_D), // 32 
 	.src_b          (src_b_D), // 32
 	.opcode         (opcode_D), // 6
 	.enable         (!Stall_D), // 1
 	
 	.Branch_Control (branch_control_D) // 1
 	); 

//--------------------------------------------------
// PC_branch   		-- DONE -- 
//--------------------------------------------------
PC_branch PC_branch_D (
	.in_1 (sign_imm_shifted), // 32
	.in_2 (PC_plus_4_D), // 32

	.out  (PCBranch_result_D)  // 32
	);


//--------------------------------------------------
// shift_left_2 for PC Branch       -- DONE -- 
//--------------------------------------------------
shift_left_2 shift_left_2_branch_D (
	.in (SignExt_D) , // 32
	
	.out(sign_imm_shifted)	 // 32
	);

//--------------------------------------------------
// shift_left_2 for jump    		-- DONE --
//--------------------------------------------------
shift_left_2 shift_left_2_jump_D (
	.in ({6'd0, Rs_D, Rt_D, Rd_D, shamt_D, funct_D}) , // 32
	
	.out(jump_shifted_D)	 // 32
	);











//--------------------------------------------------
// ALU Control   		-- DONE --
//--------------------------------------------------
alu_control alu_control_D (
	.alu_opcode (Alu_opcode_E) , // 5
	.funct      (funct_E) , // 6

	.AluControl (AluControl)     // 6
	);

//--------------------------------------------------
// ALU  		-- DONE -- 
//--------------------------------------------------

alu alu_D (
	.clk         (clk),
	.rst_n 	     (rst_n),
	.src_a       (src_a),           // 32
	.src_b       (src_b),           // 32
	.alu_control (AluControl),      // 6
	.shamt       (shamt_E),         // 5

	.overflow_E    (overflow_E),    // 1
	.break_point_E (break_point_E), // 1
	.hi 	       (hi_reg),        // 32
	.lo 	 	   (lo_reg),        // 32
	.alu_result    (ALU_result_E)   // 32
	);

//--------------------------------------------------
// forward to Excute Stage Mux src_a  -- DONE --
//--------------------------------------------------
gen_mux #(32,2) Src_aE (
	.data_in ({32'd0 ,ALU_result_M ,wr_data3_new , src_a_E}),
	.ctrl_sel(ForwardA_E),
	.data_out(src_a)
	); 

//--------------------------------------------------
// forward to Excute Stage Mux src_b  -- DONE -- 
//--------------------------------------------------
gen_mux #(32,2) Src_bE (
	.data_in ({32'd0 , ALU_result_M ,wr_data3_new ,src_b_E}),
	.ctrl_sel(ForwardB_E),
	.data_out(src_b_muxout_muxin)
	); 

//--------------------------------------------------
// src_b Mux  Excution stage 	[Right before ALU]	-- DONE --
//--------------------------------------------------

gen_mux #(32,2) src_b_mux (
	.data_in ({ZeroExt_E , 32'd0 ,SignExt_E , src_b_muxout_muxin}),
	.ctrl_sel({Arith_u_E , ALUSrc_E}),
	.data_out(src_b)
	); 






//--------------------------------------------------
// Rt vs Rd Mux    -- DONE --
//--------------------------------------------------

gen_mux #(5,1) Rt_Rd_mux (
	.data_in ({Rd_E,Rt_E}),
	.ctrl_sel(RegDst_E),
	.data_out(WriteReg_E)
	); 

//--------------------------------------------------
// Data Memory   		-- DONE --
//--------------------------------------------------
Data_memory #(.WIDTH(8) , .SIZE(32*1024/4)) Data_mem  ( // 32 KB
	.clk     (clk),
	.rst_n   (rst_n),
	.EN 	 (1'b1),
	.CLR 	 (1'b0),
	.wr_en   (MemWrite_M), // 1 
	.addr    (ALU_result_M), // 32
	.wr_data (WriteData_M), // 32
	.ByteControl(ByteControl_M), // 4

	.rd_data (ReadData_W)  // 32
	);




//--------------------------------------------------
// Exceptions  		-- DONE --
//--------------------------------------------------

DFF EPC_DFF (
	.clk  	(clk),
	.rst_n  (rst_n),
	.EN  	(Exception),
	.IN  	(PC_F),

	.OUT  	(EPC)
	);

DFF Cause_DFF (
	.clk  	(clk),
	.rst_n  (rst_n),
	.EN  	(Exception),
	.IN  	(Cause_mux_out_reg_in),

	.OUT  	(Cause)
	);


Decoder Decoder_DUT (
	.undef_D      (undef_D),
	.syscall_D    (syscall_D),
	.overflow_E   (overflow_E),
	.break_point  (break_point),
	.interrupt    (Interrupt),

	.int_cause    (int_cause)

	);

gen_mux #(32,3) cause_mux (
	.data_in ({32'h0000_0000 ,32'h0000_0000 , 32'h0000_0000 , 32'h0000_0030 , 32'h0000_0028 , 32'h0000_0024 , 32'h0000_0020 , 32'h0000_0000}),
	.ctrl_sel(int_cause),
	.data_out(Cause_mux_out_reg_in)
	); 

gen_mux #(32,1) co_processor_mux (
	.data_in ({EPC , Cause}),
	.ctrl_sel(Rd_D[1]),
	.data_out(CO_D)
	); 


exception_memory #(.WIDTH(8) , .DEPTH(64)) exception_memory_DUT ( // 4 KB
	.clk     (clk),
	.rst_n 	 (rst_n),
	.EN 	 (!(Stall_D)),
	.CLR 	 ((branch_control_D | J_D | Jr_stall_mux_out)),
	.wr_en   (wr_en_ins), // 1 
	.addr    (PC_Decoder_F), // 32
	.wr_data (wr_data), // 32
	.ByteControl(4'b1111), // 4

	.rd_data (INSTRUCTION_D_EX)  // 32
	);

PC_Decoder PC_Decoder_DUT (
	.PC_in    (PC_F),
	
	.selector (selector),
	.PC_out  (PC_Decoder_F)
	);

gen_mux #(32,1) INSTRICTION_D_mux (
	.data_in ({INSTRUCTION_D_EX , INSTRUCTION_D_INS}),
	.ctrl_sel(selector),
	.data_out(INSTRUCTION_D)
	); 
	
//--------------------------------------------------
// Byte_Control     		-- DONE --
//--------------------------------------------------
Byte_Control Byte_Control_D (
	.in(ReadData_W),
	.ByteControl(ByteControl_W),

	.out(Byte_Control_out_W)
	);


//--------------------------------------------------
// Result Mux    -- DONE -- 
//--------------------------------------------------
gen_mux #(32,3) result_mux (
	.data_in ({32'd0 ,32'd0 ,32'd0 , CO_W , 32'd0 , PC_plus_4_W, Byte_Control_out_W , ALU_result_W}),
	.ctrl_sel({coprocessor_W , link_W , MemtoReg_W}),
	.data_out(wr_data3_new) // Result_W
	); 




//--------------------------------------------------
// Jump Mux
//--------------------------------------------------


gen_mux #(32,2) Jr_mux (
	.data_in ({32'd0 , ALU_result_M , wr_data3_new , rd_data1}),
	.ctrl_sel(ForwardRs_D),
	.data_out(Jr_mux_out_W)
	); 



//--------------------------------------------------
// PC Control Mux    		-- DONE --
//--------------------------------------------------
assign jump_addr_D = {PC_F[31:28],jump_shifted_D[27:0]} ;

gen_mux #(32,3) pc_control_mux (
	.data_in ({32'd0,32'd0,32'd0, Jr_mux_out_W , 32'd0 , jump_addr_D  ,PCBranch_result_D , PC_plus_4_F }),
	.ctrl_sel({Jr_D ,J_D , branch_control_D}), // 000 and 001 and 010 and 100 is used 
	.data_out(PC_W)
	); 




//--------------------------------------------------
// $ra Mux  -- DONE --
//--------------------------------------------------

gen_mux #(5,1) return_addr_mux (
	.data_in ({5'd31 , WriteReg_W}),
	.ctrl_sel(link_W),
	.data_out(wr_addr3)
	); 




//--------------------------------------------------
// Src_aD Mux   -- DONE --
//--------------------------------------------------
gen_mux #(32,1) Src_aD (
	.data_in ({ALU_result_M,rd_data1}),
	.ctrl_sel(ForwardA_D),
	.data_out(src_a_D)
	); 

//--------------------------------------------------
// Src_bD Mux   -- DONE --
//--------------------------------------------------
gen_mux #(32,1) Src_bD (
	.data_in ({ALU_result_M,rd_data2}),
	.ctrl_sel(ForwardB_D),
	.data_out(src_b_D)
	); 


//--------------------------------------------------
// PC_NEXT_W MUX  -- DONE --
//--------------------------------------------------

gen_mux #(32,1) Pc_next_mux_D (
	.data_in ({32'd450 , prediction_mux_out_W}),
	.ctrl_sel(Exception),
	.data_out(PC_NEXT_W)
	); 




initial begin
		$readmemh("mem.txt", instruction_mem.mem);
end 




/*
//--------------------------------------------------
// Generic Mux
//--------------------------------------------------

gen_mux #(32,1) branch_control_mux (
	.data_in ({in1,in0}),
	.ctrl_sel(),
	.data_out()
	); 

*/

endmodule : mips_top