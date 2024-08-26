module mips_top_inst(
	input wire clk , rst, wr_en_ins ,
	input wire [31:0] wr_data ,

	output reg [31:0] wr_data3_mux_out  // to prevent optimization 
);


wire [31:0] INSTRUCTION ;

assign op    = INSTRUCTION[31:26] ;
assign Rs    = INSTRUCTION[25:21] ;
assign Rt    = INSTRUCTION[20:16] ;
assign Rd    = INSTRUCTION[15:11] ;
assign shamt = INSTRUCTION[10:6] ;
assign fun   = INSTRUCTION[5:0] ;



//--------------------------------------------------
// Instruction Memory   		-- DONE --
//--------------------------------------------------
ram_memory instruction_mem (
	.clk     (clk),
	.wr_en   (wr_en_ins), // 1 
	.addr    (pc), // 32
	.wr_data (wr_data), // 32

	.rd_data (INSTRUCTION)  // 32
	);



//--------------------------------------------------
// Program Counter   		-- DONE --
//--------------------------------------------------
wire [31:0] pc ,pc_next ;

pc_reg pc_reg_D (
	.clk	 (clk),
	.rst	 (rst),
	.pc_next (pc_next), // 32

	.pc      (pc)  // 32
	);


//--------------------------------------------------
// Data Memory   		-- DONE --
//--------------------------------------------------
wire [31:0] rd_data_data_mem ;

ram_memory Data_mem (
	.clk     (clk),
	.wr_en   (MemWrite), // 1 
	.addr    (alu_result), // 32
	.wr_data (rd_data2), // 32

	.rd_data (rd_data_data_mem)  // 32
	);


//--------------------------------------------------
// Sign Extension
//--------------------------------------------------
wire [15:0] instruction_imm ;
wire [31:0] sign_imm ;

sign_extend sign_extend_D (
	.instruction_imm (), // 16
 
	.sign_imm		 (sign_imm)  // 32
	);


//--------------------------------------------------
// register_file   		-- DONE --
//--------------------------------------------------
wire [31:0] wr_data3_mux_out ;
wire [31:0] rd_data1 , rd_data2 ;
wire [4:0] wr_addr3 ;

register_file register_file_D (
	.clk      (clk), 
	.rst 	  (rst), 
	.wr_en3   (RegWrite), // 1
	.rd_addr1 (Rs), // 5
	.rd_addr2 (Rt), // 5
	.wr_addr3 (wr_addr3), // 5
	.wr_data3 (wr_data3_mux_out), // 32

	.rd_data1 (rd_data1), // 32
	.rd_data2 (rd_data2)  // 32

	);


//--------------------------------------------------
// ALU  		-- DONE -- 
//--------------------------------------------------
wire zero ;
wire [31:0] alu_result ;

alu alu_D (
	.src_a       (rd_data1), // 32
	.src_b       (src_b), // 32
	.alu_control (src_b_mux_out), // 3

	.zero        (zero), // 1 
	.alu_result  (alu_result)  // 32
	);



//--------------------------------------------------
// Control Unit   		-- DONE --
//--------------------------------------------------
wire [5:0] opcode ,funct ;

wire 	   MemtoReg ;
wire 	   MemWrite ;
wire  	   Branch ;
wire 	   AluSrc ;
wire 	   RegDst ;
wire       RegWrite ;
wire 	   jump ;
wire [1:0] alu_opcode ;


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
	.alu_opcode (alu_opcode)  // 2
	);


//--------------------------------------------------
// ALU Control
//--------------------------------------------------
alu_control alu_control_D (
	.alu_opcode () , // 2
	.funct      () , // 6

	.AluControl ()  // 3
	);


//--------------------------------------------------
// PC_plus_4   		-- DONE --
//--------------------------------------------------
wire [31:0] PC_plus_4 ;

PC_plus_4 PC_plus_4_D (
	.in  (pc), // 32

	.out (PC_plus_4)  // 32
	);

//--------------------------------------------------
// PC_branch
//--------------------------------------------------
PC_branch PC_branch_D (
	.in_1 (), // 32
	.in_2 (), // 32

	.out  ()  // 32
	);


//--------------------------------------------------
// Branch Control (AND_GATE)   		-- DONE -- 
//--------------------------------------------------
wire branch_control ;

AND_GATE AND_GATE_D (
	.branch_flag    (Branch), // 1 
	.zero_flag      (zero), // 1

	.branch_control (branch_control)  // 1
	);

//--------------------------------------------------
// shift_left_2 
//--------------------------------------------------
shift_left_2 shift_left_2_D (
	.in () , // 32
	
	.out()	 // 32
	);

//--------------------------------------------------
// Generic Mux
//--------------------------------------------------
wire [31:0] branch_control_out ;

gen_mux #(32,1) branch_control_mux (
	.data_in ({in1,PC_plus_4}),
	.ctrl_sel(branch_control),
	.data_out(branch_control_out)
	); 



//--------------------------------------------------
// Generic Mux
//--------------------------------------------------

gen_mux #(32,1) jump_control_mux (
	.data_in ({in1,branch_control_out}),
	.ctrl_sel(),
	.data_out(pc_next)
	); 


//--------------------------------------------------
// Result Mux    -- DONE -- 
//--------------------------------------------------
gen_mux #(32,1) result_mux (
	.data_in ({rd_data_data_mem,alu_result}),
	.ctrl_sel(MemtoReg),
	.data_out(wr_data3_mux_out)
	); 

//--------------------------------------------------
// Rt vs Rd Mux    -- DONE --
//--------------------------------------------------

gen_mux #(5,1) branch_control_mux (
	.data_in ({Rd,Rt}),
	.ctrl_sel(RegDst),
	.data_out(wr_addr3)
	); 

//--------------------------------------------------
// src_b Mux   		-- DONE --
//--------------------------------------------------
wire [31:0] src_b_mux_out ;
gen_mux #(32,1) branch_control_mux (
	.data_in ({sign_imm,rd_data2}),
	.ctrl_sel(AluSrc),
	.data_out(src_b_mux_out)
	); 

































//--------------------------------------------------
// Generic Mux
//--------------------------------------------------

gen_mux #(32,1) branch_control_mux (
	.data_in ({in1,in0}),
	.ctrl_sel(),
	.data_out()
	); 


/* example 
gen_mux #(5,3) scl_stall_cycles_mux (
            .data_in  ( { scl_stall_cycles ,  scl_stall_cycles ,  scl_stall_cycles , daa_stall_cycles , scl_stall_cycles , scl_stall_cycles , scl_stall_cycles} ),
            .ctrl_sel (sdr_scl_stall_cycles_sel)         ,
            .data_out (sdr_scl_stall_cycles_mux_out) )   ;
*/
