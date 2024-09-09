`timescale 1ns / 1ps
`default_nettype none // Disable implicit nets. Reduces some types of bugs. 
module mips_top(
	input wire  	   clk , rst_n,
	input wire         wr_en_ins ,
	input wire  [31:0] wr_data ,

	output wire [31:0] wr_data3  // to prevent optimization 
);



//--------------------------------------------------
// Connections
//--------------------------------------------------
wire [31:0] INSTRUCTION ;
wire [31:0] pc ,pc_next ;

wire [31:0] rd_data_data_mem ;

wire [31:0] sign_imm ;

wire [31:0] rd_data1 , rd_data2 ;
wire [4:0]  wr_addr3 ;

wire  	    zero ;
wire [31:0] alu_result ;
wire [31:0] hi_reg ,lo_reg ;

wire 	    MemtoReg ;
wire 	    MemWrite ;
wire  	    Branch ;
wire 	    AluSrc ;
wire 	    RegDst ;
wire        RegWrite ;
wire 	    jump ;
wire [4:0]  alu_opcode ;

wire [5:0]  AluControl ;

wire [31:0] PC_plus_4 ;

wire [31:0] PCBranch_result ;

wire branch_control ;

wire [31:0] sign_imm_shifted ;

wire [31:0] jump_shifted ;

wire [31:0] branch_control_out ;

wire [31:0] src_b_mux_out ;
wire [31:0] zero_extend_imm ;
wire 	 	Branch_alu ;

wire [31:0] Byte_Control_out ;
wire [1:0]  ByteControl ;


// final destination of the wr_addr3 (RD)
//wire [31:0] wr_data3 ;

wire [5:0] opcode ,funct ;
wire [4:0] Rs ,Rt ,Rd ,shamt ;

assign opcode = INSTRUCTION[31:26] ;
assign Rs     = INSTRUCTION[25:21] ;
assign Rt     = INSTRUCTION[20:16] ;
assign Rd     = INSTRUCTION[15:11] ;
assign shamt  = INSTRUCTION[10:6] ;
assign funct  = INSTRUCTION[5:0] ;



//--------------------------------------------------
// Instruction Memory   		-- DONE --
//--------------------------------------------------
ram_memory #(.WIDTH(8) , .DEPTH(4096)) instruction_mem ( // 4 KB
	.clk     (clk),
	.rst_n 	 (rst_n),
	.wr_en   (wr_en_ins), // 1 
	.addr    (pc), // 32
	.wr_data (wr_data), // 32
	.ByteControl(2'b00), // 2

	.rd_data (INSTRUCTION)  // 32
	);



//--------------------------------------------------
// Program Counter   		-- DONE --
//--------------------------------------------------
pc_reg pc_reg_D (
	.clk	 (clk),
	.rst_n	 (rst_n),
	.pc_next (pc_next), // 32

	.pc      (pc)  // 32
	);


//--------------------------------------------------
// Data Memory   		-- DONE --
//--------------------------------------------------
ram_memory #(.WIDTH(8) , .DEPTH(32768)) Data_mem  ( // 32 KB
	.clk     (clk),
	.rst_n     (rst_n),
	.wr_en   (MemWrite), // 1 
	.addr    (alu_result), // 32
	.wr_data (rd_data2), // 32
	.ByteControl(ByteControl), // 2

	.rd_data (rd_data_data_mem)  // 32
	);


//--------------------------------------------------
// Sign Extension   		-- DONE --
//--------------------------------------------------
sign_extend sign_extend_D (
	.instruction_imm ({Rd ,shamt ,funct}), // 16
 
	.sign_imm		 (sign_imm)  // 32
	);


//--------------------------------------------------
// Zero Extension   		-- DONE --
//--------------------------------------------------
zero_extend zero_extend_D (
	.instruction_imm ({Rd ,shamt ,funct}), // 16
 
	.zero_extend_imm		 (zero_extend_imm)  // 32
	);

//--------------------------------------------------
// register_file   		-- DONE --
//--------------------------------------------------
register_file register_file_D (
	.clk      (clk), 
	.rst_n 	  (rst_n), 
	.wr_en3   (RegWrite), // 1
	.rd_addr1 (Rs), // 5
	.rd_addr2 (Rt), // 5
	.wr_addr3 (wr_addr3), // 5
	.wr_data3 (wr_data3), // 32

	.rd_data1 (rd_data1), // 32
	.rd_data2 (rd_data2)  // 32

	);


//--------------------------------------------------
// ALU  		-- DONE -- 
//--------------------------------------------------
alu alu_D (
	.clk         (clk),
	.rst_n 	     (rst_n),
	.src_a       (rd_data1),      // 32
	.src_b       (src_b_mux_out), // 32
	.alu_control (AluControl),    // 6
	.shamt       (shamt),         // 5
	.opcode      (opcode),        // 6
	.Rt          (Rt), 	 	 	  // 5

	.hi 	     (hi_reg),        // 32
	.lo 	 	 (lo_reg),        // 32
	.zero        (zero),  	      // 1 
	.Branch_alu  (Branch_alu),    // 1
	.alu_result  (alu_result)     // 32
	);



//--------------------------------------------------
// Control Unit   		-- DONE --
//--------------------------------------------------
wire Jr ;
wire link ;
wire Arith_u ;

control_unit control_unit_D (
	.opcode     (opcode), // 6
	.funct      (funct), // 6
 
	.MemtoReg   (MemtoReg), // 1
	.MemWrite   (MemWrite), // 1
	.Branch     (Branch), // 1
	.AluSrc     (AluSrc), // 1 
	.RegDst     (RegDst), // 1 
	.RegWrite   (RegWrite), // 1
	.jump       (jump), // 1
	.Jr	  	    (Jr), // 1
	.link 	 	(link), // 1
	.Arith_u    (Arith_u), // 1
	.ByteControl(ByteControl), // 2
	.alu_opcode (alu_opcode)  // 5
	);


//--------------------------------------------------
// ALU Control   		-- DONE --
//--------------------------------------------------

alu_control alu_control_D (
	.alu_opcode (alu_opcode) , // 5
	.funct      (funct) , // 6

	.AluControl (AluControl)     // 6
	);


//--------------------------------------------------
// PC_plus_4   		-- DONE --
//--------------------------------------------------
PC_plus_4 PC_plus_4_D (
	.in  (pc), // 32

	.out (PC_plus_4)  // 32
	);

//--------------------------------------------------
// PC_branch   		-- DONE -- 
//--------------------------------------------------
PC_branch PC_branch_D (
	.in_1 (sign_imm_shifted), // 32
	.in_2 (PC_plus_4), // 32

	.out  (PCBranch_result)  // 32
	);


//--------------------------------------------------
// Branch Control (AND_GATE)   		-- DONE -- 
//--------------------------------------------------
AND_GATE AND_GATE_D (
	.branch_flag    (Branch), // 1 
	.zero_flag      (Branch_alu), // 1

	.branch_control (branch_control)  // 1
	);

//--------------------------------------------------
// shift_left_2 for PC Branch
//--------------------------------------------------
shift_left_2 shift_left_2_branch_D (
	.in (sign_imm) , // 32
	
	.out(sign_imm_shifted)	 // 32
	);

//--------------------------------------------------
// shift_left_2 for jump    		-- DONE --
//--------------------------------------------------
shift_left_2 shift_left_2_jump_D (
	.in ({6'd0, Rs, Rt, Rd, shamt, funct}) , // 32
	
	.out(jump_shifted)	 // 32
	);

//--------------------------------------------------
// Byte_Control     		-- DONE --
//--------------------------------------------------
Byte_Control Byte_Control_D (
	.in(rd_data_data_mem),
	.ByteControl(ByteControl),

	.out(Byte_Control_out)
	);


//--------------------------------------------------
// PC Control Mux    		-- DONE --
//--------------------------------------------------
gen_mux #(32,3) pc_control_mux (
	.data_in ({32'd0,32'd0,32'd0, rd_data1 , 32'd0 , {pc[31:28],jump_shifted[27:0]}  ,PCBranch_result , PC_plus_4 }),
	.ctrl_sel({Jr ,jump , branch_control}), // 000 and 001 and 010 and 100 is used 
	.data_out(pc_next)
	); 


//--------------------------------------------------
// Result Mux    -- DONE -- 
//--------------------------------------------------
gen_mux #(32,2) result_mux (
	.data_in ({32'd0 , PC_plus_4 , Byte_Control_out , alu_result}),
	.ctrl_sel({link , MemtoReg}),
	.data_out(wr_data3)
	); 

//--------------------------------------------------
// Rt vs Rd Mux    -- DONE --
//--------------------------------------------------
wire [4:0] Rt_Rd_mux_out ;

gen_mux #(5,1) Rt_Rd_mux (
	.data_in ({Rd,Rt}),
	.ctrl_sel(RegDst),
	.data_out(Rt_Rd_mux_out)
	); 

//--------------------------------------------------
// src_b Mux   		-- DONE --
//--------------------------------------------------
gen_mux #(32,2) src_b_mux (
	.data_in ({zero_extend_imm , 32'd0 ,sign_imm , rd_data2}),
	.ctrl_sel({Arith_u , AluSrc}),
	.data_out(src_b_mux_out)
	); 

//--------------------------------------------------
// $ra Mux
//--------------------------------------------------

gen_mux #(5,1) return_addr_mux (
	.data_in ({5'd31 , Rt_Rd_mux_out}),
	.ctrl_sel(link),
	.data_out(wr_addr3)
	); 

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