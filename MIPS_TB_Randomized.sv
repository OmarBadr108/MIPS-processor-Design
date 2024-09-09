`timescale 1ns / 1ps 




module mips_testbench_randomized ;

	//--------------------------------------------------
	// Signals declaration
	//--------------------------------------------------  
	logic 	 	 clk = 0 ,rst ;
	logic [31:0] wr_data3_mux_out ; // to prevent optimization 

	//--------------------------------------------------
	// clk generation
	//--------------------------------------------------  
	parameter CLK_PERIOD  = 20 ;
	// clk generation 
	always #(CLK_PERIOD/2) clk = !clk ;


	//--------------------------------------------------
	// DUT instantiation
	//-------------------------------------------------- 
	mips_top mips_top_inst (.*);

	

	
 	typedef enum logic [1:0] {R_TYPE, I_TYPE, J_TYPE} instr_type_e;
 	typedef enum logic [5:0] {r_type=0, j=2, beq=4, addi=8, lw=35, sw=43} opcode_e;
 	typedef enum logic [5:0] {add=32, sub=34, andd=36, orr=37, slt=42} funct_e;
 	typedef enum logic [4:0] {rs_t0=8,rs_t1,rs_t2,rs_t3,rs_t4,rs_t5,rs_t6,rs_t7=15,
 							  rs_s0=16,rs_s1,rs_s2,rs_s3,rs_s4,rs_s5,rs_s6,rs_s7,rs_t8,rs_t9=25} rs_e;
 	typedef enum logic [4:0] {rt_t0=8,rt_t1,rt_t2,rt_t3,rt_t4,rt_t5,rt_t6,rt_t7=15,
 							  rt_s0=16,rt_s1,rt_s2,rt_s3,rt_s4,rt_s5,rt_s6,rt_s7,rt_t8,rt_t9=25} rt_e;
 	typedef enum logic [4:0] {rd_t0=8,rd_t1,rd_t2,rd_t3,rd_t4,rd_t5,rd_t6,rd_t7=15,
 							  rd_s0=16,rd_s1,rd_s2,rd_s3,rd_s4,rd_s5,rd_s6,rd_s7,rd_t8,rd_t9=25} rd_e;
 	
 	typedef struct packed {
 		opcode_e opcode;
 		rs_e rs;
 		rt_e rt;
 		rd_e rd;
 		logic [4:0] shamt;
 		funct_e funct;
 	} R_TYPE_e;

 	typedef struct packed {
 		opcode_e opcode;
 		rs_e rs;
 		rt_e rt;
 		logic signed [15:0] immediate_I ;
 	} I_TYPE_e;

 	typedef struct packed {
 		opcode_e opcode;
 		logic signed  [25:0] immediate_J ;
 	} J_TYPE_e;




 	class transaction;
 		rand logic [31:0] instruction;
 		rand R_TYPE_e R_TYPE_instruction;
 		rand I_TYPE_e I_TYPE_instruction;  
 		rand J_TYPE_e J_TYPE_instruction;
 		rand instr_type_e option;

 		constraint instr_constr {
        	if     (option==R_TYPE) { instruction==R_TYPE_instruction; }
        	else if(option==I_TYPE) { instruction==I_TYPE_instruction; }
        	else if(option==J_TYPE) { instruction==J_TYPE_instruction; }
		}
 
		constraint instr_dist_constr {
        	option dist {R_TYPE:=60, I_TYPE:=40, J_TYPE:=10};
 		}

 		/*
 		constraint Jump_location {
 			immediate_J[1:0] == 0 ; //divisable by 4
        	immediate_J inside {0,1024 ;} // as instruction memory is 4096 in depth 
 		}

 		constraint Branch_location {
 			immediate_I[1:0] == 0 ; //divisable by 4
        	immediate_I inside {0,1024 ;}  // as instruction memory is 4096 in depth 
 		}
		*/
	endclass






	//--------------------------------------------------
	// Initial block 
	//--------------------------------------------------  
	initial begin
		write_instruction_file();
		reset() ;
		@(posedge clk) ; 
		$display("Here we go %t",$time);

		#(1200*CLK_PERIOD) $stop ; // 1024 transaction
	end 

	initial begin
		#1 ;
		$readmemh("mem_rand.txt", mips_top_inst.instruction_mem.mem);
	end 

	task reset ();
		begin 
			rst = 1'b0    ; 	// ASSERTED
			#(CLK_PERIOD) ;
			rst = 1'b1    ;     // DEASSERTED
		end 
	endtask 

	transaction t;
	int fd ; 
	task write_instruction_file();
 		fd=$fopen("mem_rand.txt","w");
 		// safety check
 		if (fd) begin  
 			for(int i=0;i<1024;i=i+1) begin
 				t = new();
 				assert(t.randomize());
 				$fdisplay(fd,"%h",t.instruction[7:0]);
	 			$fdisplay(fd,"%h",t.instruction[15:8]);
 				$fdisplay(fd,"%h",t.instruction[23:16]);
 				$fdisplay(fd,"%h",t.instruction[31:24]);
 				
 			end		
 		end 
 		$fclose(fd);
 		$display("End of filling the instruction memory %t",$time);
 	endtask


endmodule 