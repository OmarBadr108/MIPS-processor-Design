`timescale 1ns / 1ps 
module mips_testbench ;

	//--------------------------------------------------
	// Signals declaration
	//--------------------------------------------------  
	logic 	 	 clk = 0 ,rst_n ;
	logic  	     wr_en_ins ;
	logic [31:0] wr_data ;
	logic [4:0] wr_data3 ; // to prevent optimization 
	logic  		  Interrupt ;

	logic [31:0] INSTRUCTION_TB ;
	assign INSTRUCTION_TB = mips_top_inst.INSTRUCTION_F ;

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

	//--------------------------------------------------
	// Randomization Class 
	//--------------------------------------------------  

	`define REGFILE mips_top_inst.register_file_D.regfile  // 32 bit 
	`define DATA_MEM mips_top_inst.Data_mem.mem 		   // 8 bits 

	class transaction;
 		rand logic [5:0]  OP_CODE , FUNCT ;
 		rand logic [4:0]  RD , RT , RS , SHAMT ;
 		rand logic signed [15:0] IMM_16 ;
 		rand logic signed [25:0] IMM_26 ;
 		logic  	 	      PC_PLUS_4 ;
 		logic [31:0]      INSTRUCTION_C ;

 		
 		 
		constraint opcode_c {
        	OP_CODE dist {0:=50, [1:43]:= 50};
        	OP_CODE inside {[0:15],28,[32:33],[35:37],[40:43]};
 		}

 		//--------------------------------------------------
		// R-Type Constraints 
		//--------------------------------------------------
		constraint funct_c {
        	FUNCT inside {0,[2:9],[16:19],[24:27],[32:39],[42:43]};
 		}
/* 
 		constraint Jump_location_Jr_Jalr {
 			if (OP_CODE == 0 && (FUNCT == 'd8 || FUNCT == 'd9)) {
        		`REGFILE[RS] inside {0,4093 ;} // as instruction memory is 4096 in depth 
        	}
 		}

 		constraint Division_by_zero {
 			if (OP_CODE == 0 && (FUNCT == 'd26 || FUNCT == 'd27)) {
        		`REGFILE[RT] != 'd0 ;  
        	}
 		}
*/
 		//--------------------------------------------------
		// I-Type Constraints 
		//-------------------------------------------------- 
		 /*
 		constraint Branch_location {
 			if (OP_CODE inside {[1:7]}) {
        		({{16{IMM_16 [15]}} , IMM_16} << 2) inside {-200 ,200 } ; // as instruction memory is 4096 in depth (-3)
 			}
 		}	
		
		constraint memory_offset {
			if (OP_CODE inside {[32:43]}){ 
				({{16{IMM_16 [15]}} , IMM_16} << 2) inside {-200,200 } ;// as Data memory is 32 KB in depth (-3)
			}
		}

		//--------------------------------------------------
		// J-Type Constraints 
		//--------------------------------------------------  
		constraint Jump_location_J_Jal {
 			if (OP_CODE == 'd2 || OP_CODE == 'd3) {
        		IMM_26 inside {-200, 200}; // as instruction memory is 4096 in depth and this imm_26 will be multiplied by 4 
        	}
 		}
*/
	endclass 

	//--------------------------------------------------
	// Initial block 
	//--------------------------------------------------  
	initial begin
		Interrupt = 1'b0 ;
		reset() ;
		@(posedge clk) ; 
		$display("Starting Simulation %t",$time);
		#(500000*CLK_PERIOD)  ;
		$stop ;
	end 





	//--------------------------------------------------
	// Form LUT instruction memory 
	//-------------------------------------------------- 
	initial begin
		wait (rst_n) ;
		//write_instruction_file();
		#1 ;
		$display("Reading instructions %t",$time) ;
		$readmemh("mem.txt", mips_top_inst.instruction_mem.mem);
	end 

	//--------------------------------------------------
	// Form BRAM instruction memory 
	//-------------------------------------------------- 

/*

integer file;
reg [7:0] word; // An 8-bit register to store each byte read from the file
integer i;      // Address index
integer mem_select; // Variable to cycle through BRAM0 to BRAM3

initial begin
	wait (rst_n) ;
	#1 ;
  i = 0;            // Initialize address index
  mem_select = 0;    // Initialize memory select counter
  
  // Open the memory file
  file = $fopen("mem.txt", "r");
  if (file == 0) begin
    $display("Error: Could not open file.");
    $finish;
  end

  // Loop through the file until end-of-file (EOF) is reached
  while (!$feof(file)) begin
    // Read an 8-bit value from the file using fscanf (expect hexadecimal format)
    if ($fscanf(file, "%h\n", word) != 1) begin
      $display("Error: Failed to read byte at address %0d", i);
      $finish;
    end
    $display("Catch up word = %h  mem select = %h time :%0t",word ,mem_select , $time);
    // Round-robin assignment to the BRAMs
    case (mem_select)
      'd0: mips_top_inst.instruction_mem.BRAM0[i] = word;  // Assign the byte to BRAM0
      'd1: mips_top_inst.instruction_mem.BRAM1[i] = word;  // Assign the byte to BRAM1
      'd2: mips_top_inst.instruction_mem.BRAM2[i] = word;  // Assign the byte to BRAM2
      'd3: mips_top_inst.instruction_mem.BRAM3[i] = word;  // Assign the byte to BRAM3
    endcase

    // Update the mem_select counter (0 -> 1 -> 2 -> 3 -> 0 ...)
    mem_select = mem_select + 1;

    // Increment the address index only after one complete 32-bit word has been filled
    if (mem_select == 4) begin
      mem_select = 0; // Reset mem_select to 0 after completing a full word
      i = i + 1;      // Move to the next address after filling all 4 BRAMs
    end
  end

  // Close the file
  $fclose(file);
end
*/


































	//--------------------------------------------------
	// Signals and macros for TASKS 
	//-------------------------------------------------- 

	logic [5:0]  op_code_tb_delayed , func_tb_delayed ;
	logic [31:0] sign_imm_shifted_delayed ;
	logic [31:0] sign_imm_delayed ;	   // not shifted 
	logic [31:0] PC_plus_4_delayed ;
	logic [31:0] pc_delayed ;

	// for R type
	logic [5:0]  op_code_tb , func_tb ;
	logic [4:0]  RS_tb , RT_tb , RD_tb ;
	logic [4:0]  shamt_tb  ;
	// for I type
	logic [15:0] Imm_16 ;
	// for J type
	logic [25:0] Imm_26 ;

	logic [31:0] lo_reg  , hi_reg ;
	logic [31:0] lo_reg_delayed  , hi_reg_delayed;
 	
 	assign lo_reg = mips_top_inst.lo_reg ;
 	assign hi_reg = mips_top_inst.hi_reg ;

	assign op_code_tb = INSTRUCTION_TB[31:26] ;
	assign RS_tb      = INSTRUCTION_TB[25:21] ;
	assign RT_tb      = INSTRUCTION_TB[20:16] ;
	assign RD_tb      = INSTRUCTION_TB[15:11] ;
	assign shamt_tb   = INSTRUCTION_TB[10:6]  ;
	assign func_tb    = INSTRUCTION_TB[5:0]   ;
	assign Imm_16  	  = INSTRUCTION_TB[15:0]  ;
	assign Imm_26     = INSTRUCTION_TB[25:0]  ;


	// delaying signals one clk cycle so i can check on them on the follwing clk cycle
	// note :
	// no need to delay any signal that is passed as an arguments to tasks is it passed at this clk cycle and the task waits a clock so no need to delay Rs and Rt ...
	// they are already the old version , i hope u get it 
	//--------------------------------------------------
	// Delaying block 
	//--------------------------------------------------  
	always@(posedge clk) begin 
		op_code_tb_delayed <= op_code_tb ;
		func_tb_delayed    <= func_tb    ;

		// for branch and jump
		sign_imm_shifted_delayed <= mips_top_inst.sign_imm_shifted ;
		PC_plus_4_delayed 	     <= mips_top_inst.PC_plus_4_F;
		pc_delayed 	 	 	 	 <= mips_top_inst.PC_F ;
		sign_imm_delayed         <= mips_top_inst.SignExt_D;

		// special registers 
		lo_reg_delayed <= lo_reg ;
		hi_reg_delayed <= hi_reg ;
	end 
/*
	//--------------------------------------------------
	// Self_checking block 
	//--------------------------------------------------  
	always @ (negedge clk) begin 
		// fetching Instruction after deasserting the reset
		wait(rst_n == 1) ;
		// checking the instruction type 
		case (op_code_tb)
			6'b000_000 :  begin 
				check_R_type_Instruction(RS_tb , RT_tb , RD_tb , shamt_tb , func_tb) ;
			end

			6'd2 :  begin 
				check_J_type_Instruction(Imm_26) ;
			end

			6'd3 :  begin 
				check_J_type_Instruction(Imm_26) ;
			end
			// the rest of them are I type 
			default :  begin 
				check_I_type_Instruction(RS_tb , RT_tb , Imm_16) ;
			end
		endcase 
	end 
*/
	

	//--------------------------------------------------
	// TASKS 
	//-------------------------------------------------- 

	transaction t;
	int fd ; 
	task write_instruction_file();
 		fd=$fopen("mem_rand.txt","w");
 		// safety check
 		if (fd) begin  
 			for(int i=0;i<9999;i=i+1) begin
 				t = new();
 				assert(t.randomize());

 				if (t.OP_CODE == 'd0) t.INSTRUCTION_C = {t.OP_CODE , t.RS , t.RT , t.RD , t.SHAMT , t.FUNCT}; // R-TYPE
 					
 	
 				else if (t.OP_CODE == 2 || t.OP_CODE == 3) t.INSTRUCTION_C = {t.OP_CODE, t.IMM_26} ;    // J-TYPE
 					
 		 
 				else t.INSTRUCTION_C = {t.OP_CODE , t.RS , t.RT, t.IMM_16} ;  	 	 	 	 	      // I-TYPE
 					

 				$fdisplay(fd,"%h",t.INSTRUCTION_C[7:0]);
	 			$fdisplay(fd,"%h",t.INSTRUCTION_C[15:8]);
 				$fdisplay(fd,"%h",t.INSTRUCTION_C[23:16]);
 				$fdisplay(fd,"%h",t.INSTRUCTION_C[31:24]);
 				
 			end		
 		end 
 		$fclose(fd);
 		$display("End of filling the instruction memory %t",$time);
 	endtask

	task reset ();
		begin 
			rst_n = 1'b0    ; 	// ASSERTED
			#(CLK_PERIOD/2);
			#(CLK_PERIOD/4);
			#(CLK_PERIOD);
			rst_n = 1'b1    ;     // DEASSERTED
		end 
	endtask 





	//--------------------------------------------------
	// Assertion Directives checking 
	//--------------------------------------------------

	task check_R_type_Instruction (input logic [4:0] RS , RT , RD , shamt ,
											   [5:0] func );

		logic signed [31:0] src_a_signed ;
		logic signed [31:0] src_b_signed ;
		logic 	 	 [4:0]  shamt_tmp ;
		begin
			#(CLK_PERIOD);

			case (func_tb_delayed)

				6'd0 : begin // sll
					assert (`REGFILE[RD] == ( `REGFILE[RT] << shamt))
						 $display("[R-type] [sll] correct ! , %0t",$time);
					else $display("[R-type] [sll] WRONG ! , %0t"  ,$time);
				end

				6'd2 : begin // srl
					assert (`REGFILE[RD] == ( `REGFILE[RT] >> shamt))
						 $display("[R-type] [srl] correct ! , %0t",$time);
					else $display("[R-type] [srl] WRONG ! , %0t"  ,$time);
				end

				6'd3 : begin // sra
					src_a_signed = `REGFILE[RT] ;
					src_a_signed = src_a_signed >>> shamt ;
					assert (`REGFILE[RD] ==  src_a_signed)
						 $display("[R-type] [sra] correct ! , %0t",$time);
					else $display("[R-type] [sra] WRONG ! ,`REGFILE[RD] = %h , src_a_signed = %h ,shamt = %d, ( src_a_signed >>> shamt) = %h , %0t"  ,
														   `REGFILE[RD]      , src_a_signed      , shamt    , ( src_a_signed >>> shamt)      ,$time);
				end

				6'd4 : begin // sllv
					assert (`REGFILE[RD] == ( `REGFILE[RT] << `REGFILE[RS][4:0] ))
						 $display("[R-type] [sllv] correct ! , %0t",$time);
					else $display("[R-type] [sllv] WRONG ! , %0t"  ,$time);
				end

				6'd6 : begin // srlv
					assert (`REGFILE[RD] == ( `REGFILE[RT] >> (`REGFILE[RS][4:0])))
						 $display("[R-type] [srlv] correct ! , %0t",$time);
					else $display("[R-type] [srlv] WRONG ! , %0t" ,$time);
				end

				6'd7 : begin // srav
					shamt_tmp = (`REGFILE[RS][4:0]) ;
					src_a_signed = `REGFILE[RT] ;
					src_a_signed = src_a_signed >>> shamt_tmp ;
					assert (`REGFILE[RD] ==  src_a_signed )
						 $display("[R-type] [srav] correct ! , %0t",$time);
					else $display("[R-type] [srav] WRONG ! , %0t"  ,$time);
				end

				6'd8 : begin // jr
					assert (`REGFILE[RS] == mips_top_inst.PC_F )
						 $display("[R-type] [jr] correct ! , %0t",$time);
					else $display("[R-type] [jr] WRONG ! , %0t"  ,$time);
				end

				6'd9 : begin // jalr
					assert ((`REGFILE[RS] == mips_top_inst.PC_F) && (PC_plus_4_delayed == `REGFILE[31]) )
						 $display("[R-type] [jalr] correct ! , %0t",$time);
					else $display("[R-type] [jalr] WRONG ! , %0t"  ,$time);
				end






				6'd16 : begin // mfhi
					assert (hi_reg_delayed == `REGFILE[RD])
						 $display("[R-type] [mfhi] correct ! , %0t",$time);
					else $display("[R-type] [mfhi] WRONG ! , %0t"  ,$time);
				end

				6'd17 : begin // mthi
					assert (hi_reg == `REGFILE[RS])
						 $display("[R-type] [mthi] correct ! , %0t",$time);
					else $display("[R-type] [mthi] WRONG ! , %0t"  ,$time);
				end

				6'd18 : begin // mflo
					assert (lo_reg_delayed == `REGFILE[RD])
						 $display("[R-type] [mflo] correct ! , %0t",$time);
					else $display("[R-type] [mflo] WRONG ! , %0t"  ,$time);
				end

				6'd19 : begin // mtlo
					assert (lo_reg == `REGFILE[RS])
						 $display("[R-type] [mtlo] correct ! , %0t",$time);
					else $display("[R-type] [mtlo] WRONG ! , %0t"  ,$time);
				end




				6'd24 : begin // mult
					src_a_signed = `REGFILE[RS] ;
					src_b_signed = `REGFILE[RT] ;
					assert (src_a_signed * src_b_signed == {hi_reg , lo_reg })
						 $display("[R-type] [mult] correct ! , %0t" ,$time);
					else $display("[R-type] [mult] WRONG !   , %0t" ,$time);
				end 

				6'd25 : begin // multu

					assert (`REGFILE[RT] * `REGFILE[RS] == {hi_reg , lo_reg })
						 $display("[R-type] [multu] correct ! , %0t" ,$time);
					else $display("[R-type] [multu] WRONG !   , %0t" ,$time);
				end
				
				6'd26 : begin // div
					src_a_signed = `REGFILE[RS] ;
					src_b_signed = `REGFILE[RT] ;
					assert ((src_a_signed / src_b_signed == lo_reg) && (src_a_signed % src_b_signed == hi_reg))
						 $display("[R-type] [div] correct ! , %0t" ,$time);
					else $display("[R-type] [div] WRONG !   , %0t" ,$time);
				end 

				6'd27 : begin // divu
					assert ((`REGFILE[RS] / `REGFILE[RT] == lo_reg) && (`REGFILE[RS] % `REGFILE[RT] == hi_reg))
						 $display("[R-type] [divu] correct ! , %0t" ,$time);
					else $display("[R-type] [divu] WRONG !   , %0t" ,$time);
				end 




				6'd32 : begin // add
					assert (`REGFILE[RD] == `REGFILE[RS] + `REGFILE[RT])
						 $display("[R-type] [Add] correct ! , %0t" ,$time);
					else $display("[R-type] [Add] WRONG !   , %0t" ,$time);
				end 

				6'd33 : begin // addu
					assert (`REGFILE[RD] == `REGFILE[RS] + `REGFILE[RT])
						 $display("[R-type] [Addu] correct ! , %0t" ,$time);
					else $display("[R-type] [Addu] WRONG !   , %0t" ,$time);
				end 

				6'd34 : begin // Sub
					assert (`REGFILE[RD] == `REGFILE[RS] - `REGFILE[RT])
						 $display("[R-type] [Sub] correct ! , %0t",$time);
					else $display("[R-type] [Sub] WRONG ! , %0t"  ,$time);
				end

				6'd35 : begin // Subu
					assert (`REGFILE[RD] == `REGFILE[RS] - `REGFILE[RT])
						 $display("[R-type] [Subu] correct ! , %0t",$time);
					else $display("[R-type] [Subu] WRONG ! , %0t"  ,$time);
				end

				6'd36 : begin // AND
					assert (`REGFILE[RD] == (`REGFILE[RS] & `REGFILE[RT]))
						 $display("[R-type] [AND] correct ! , %0t",$time);
					else $display("[R-type] [AND] WRONG ! , %0t"  ,$time);
				end 

				6'd37 : begin // OR
					assert (`REGFILE[RD] == (`REGFILE[RS] | `REGFILE[RT]))
						 $display("[R-type] [OR] correct ! , %0t",$time);
					else $display("[R-type] [OR] WRONG ! , %0t"  ,$time);
				end 

				6'd38 : begin // XOR
					assert (`REGFILE[RD] == (`REGFILE[RS] ^ `REGFILE[RT]))
						 $display("[R-type] [XOR] correct ! , %0t",$time);
					else $display("[R-type] [XOR] WRONG ! , %0t"  ,$time);
				end 

				6'd39 : begin // NOR
					assert (`REGFILE[RD] == (`REGFILE[RS] | (~`REGFILE[RT])))
						 $display("[R-type] [NOR] correct ! , %0t",$time);
					else $display("[R-type] [NOR] WRONG ! , %0t"  ,$time);
				end 

				6'd42 : begin // slt  signed 
					src_a_signed = `REGFILE[RS] ;
					src_b_signed = `REGFILE[RT] ;

					assert (((`REGFILE[RD] == 'd1 ) && (src_a_signed  < src_b_signed)) || ((`REGFILE[RD] == 'd0 ) && (src_a_signed  >= src_b_signed)))
						$display("[R-type] [slt] correct ! , %0t",$time);

					else $display("[R-type] [slt] WRONG ! , %0t"  ,$time);
				end 

				6'd43 : begin // sltu
					assert (((`REGFILE[RD] == 'd1 ) && (`REGFILE[RS]  < `REGFILE[RT])) || ((`REGFILE[RD] == 'd0 ) && (`REGFILE[RS]  >= `REGFILE[RT])))
						$display("[R-type] [sltu] correct ! , %0t",$time);
					else $display("[R-type] [sltu] WRONG ! , %0t"  ,$time);
				end 


				default : $display("[R-type] NOT Supported ! , %0t"  ,$time);

			endcase 
		end
	endtask





	task check_J_type_Instruction (input logic [25:0] Imm_26_task);
		begin
			#(CLK_PERIOD);

			case (op_code_tb_delayed)
				6'd2 : begin // J  
					assert (mips_top_inst.PC_F== {mips_top_inst.PC_F[31:28],Imm_26_task,2'b00})
						 $display("[J-type] [J] correct ! , %0t",$time);
					else $display("[J-type] [J] WRONG ! , %0t"  ,$time);
				end 

				6'd3 : begin // Jal  
					assert ((mips_top_inst.PC_F == {mips_top_inst.PC_F[31:28],Imm_26_task,2'b00}) && 
						(PC_plus_4_delayed == `REGFILE[31])  ) // $ra

						 $display("[J-type] [Jal] correct ! , %0t",$time);
					else $display("[J-type] [Jal] WRONG !   , %0t",$time);
				end

			endcase 
			
		end
	endtask


	
	task check_I_type_Instruction (input logic [4:0] RS , RT ,
											   [15:0] Imm_16_task);
		logic        [31:0] Imm_16_task_extended ;
		logic 	 	 [31:0] Imm_16_task_zero_extended ;
		logic signed [31:0] src_a_signed ;
		logic signed [31:0] src_b_signed ;

 		// sign extension to the 16-bit immediate value 
			Imm_16_task_extended = {{16{Imm_16_task [15]}} , Imm_16_task} ;

		// zero extension to the 16-bit immediate value 
			Imm_16_task_zero_extended = {{16{1'b0}} , Imm_16_task} ;

		begin
			#(CLK_PERIOD) ;

			case (op_code_tb_delayed)
				6'd8 : begin // addi  
					assert ((`REGFILE[RT] == `REGFILE[RS] + Imm_16_task_extended) || (`REGFILE[RT] == `REGFILE[RS]) ) // the second case for x=x-1
						$display("[I-type] [Addi] or x=x-1 correct ! , %0t",$time);  
					else
						$display("[I-type] [Addi] WRONG ! RT = %d RS = %d ,REGFILE[RS] = %h  , REGFILE[RT] = %h , %0t"  ,
						RT , RS ,`REGFILE[RS] ,`REGFILE[RT] , $time);
				end 

				6'd9 : begin // addiu  
					assert (`REGFILE[RT] == `REGFILE[RS] + Imm_16_task_extended || (`REGFILE[RT] == `REGFILE[RS]) ) // the second case for x=x-1
						 $display("[I-type] [Addiu] correct ! , %0t",$time);
					else
						$display("[I-type] [Addiu] WRONG ! RT = %d RS = %d ,REGFILE[RS] = %h  , REGFILE[RT] = %h , %0t"  ,
						RT , RS ,`REGFILE[RS] ,`REGFILE[RT] , $time);
				end

				6'd10 : begin // slti  // the signals are unsigend by default so i need to store them in a signed containers
					src_a_signed = `REGFILE[RS] ;
					src_b_signed = Imm_16_task_extended ;

					assert (((src_a_signed < src_b_signed) && (`REGFILE[RT] == 'd1 )) || ((src_a_signed >= src_b_signed) && (`REGFILE[RT] == 'd0 ))) 
						 $display("[I-type] [Slti] correct ! , %0t",$time);
					else
						$display("[I-type] [Slti] WRONG ! RT = %d RS = %d ,REGFILE[RS] = %h  , REGFILE[RT] = %h , %0t"  ,
						RT , RS ,`REGFILE[RS] ,`REGFILE[RT] , $time);
				end 

				6'd11 : begin // sltiu 
					assert ((`REGFILE[RS] < Imm_16_task_extended) && (`REGFILE[RT] == 'd1 ) ) 
						 $display("[I-type] [Sltiu] correct ! , %0t",$time);
					else
						$display("[I-type] [Sltiu] WRONG ! RT = %d RS = %d ,REGFILE[RS] = %h  , REGFILE[RT] = %h , %0t"  ,
						RT , RS ,`REGFILE[RS] ,`REGFILE[RT] , $time);
				end 

				6'd12 : begin // andi  
					assert ((`REGFILE[RT] == `REGFILE[RS] & Imm_16_task_zero_extended ) || (`REGFILE[RT] == `REGFILE[RS]) ) 
						 $display("[I-type] [Andi] correct ! , %0t",$time);
					else
						$display("[I-type] [Andi] WRONG ! RT = %d RS = %d ,REGFILE[RS] = %h  , REGFILE[RT] = %h  , imm = %h , %0t"  ,
						RT , RS ,`REGFILE[RS] ,`REGFILE[RT] , Imm_16_task_zero_extended, $time);
				end 

				6'd13 : begin // ori  
					assert ((`REGFILE[RT] == `REGFILE[RS] | Imm_16_task_zero_extended) || (`REGFILE[RT] == `REGFILE[RS])) 
						 $display("[I-type] [Ori] correct ! , %0t",$time);
					else
						$display("[I-type] [Ori] WRONG ! RT = %d RS = %d ,REGFILE[RS] = %h  , REGFILE[RT] = %h , %0t"  ,
						RT , RS ,`REGFILE[RS] ,`REGFILE[RT] , $time);
				end 

				6'd14 : begin // xori  
					assert ((`REGFILE[RT] == `REGFILE[RS] ^ Imm_16_task_zero_extended)|| (`REGFILE[RT] == `REGFILE[RS])) 
						 $display("[I-type] [Xori] correct ! , %0t",$time);
					else
						$display("[I-type] [Xori] WRONG ! RT = %d RS = %d ,REGFILE[RS] = %h  , REGFILE[RT] = %h , %0t"  ,
						RT , RS ,`REGFILE[RS] ,`REGFILE[RT] , $time);
				end 

				6'd15 : begin // lui  
					
					assert (`REGFILE[RT] == { Imm_16_task , 16'd0 })
						 $display("[I-type] [lui] correct ! , %0t" ,$time);
					else $display("[I-type] [lui] WRONG !  .. RT = %d , REGFILE[RT] = %h ,Imm_16_task = %h , %0t" ,RT ,`REGFILE[RT], Imm_16_task ,$time);
				end

				6'd4 : begin // beq
					if (`REGFILE[RT] == `REGFILE[RS]) begin 
						assert (mips_top_inst.PC_F== sign_imm_shifted_delayed + PC_plus_4_delayed) begin 
							$display("[I-type] [Beq] Branched successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [Beq] Branched WRONG ! , %0t",$time);
						end 
					end 

					else begin 
						assert (mips_top_inst.PC_F==  PC_plus_4_delayed) begin 
							$display("[I-type] [Beq] not equal so didn't branch .. successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [Beq] not equal but there is an error .. WRONG ! , %0t",$time);
						end

					end 
				end

				6'd5 : begin // bne
					if (`REGFILE[RT] != `REGFILE[RS]) begin 
						assert (mips_top_inst.PC_F== sign_imm_shifted_delayed + PC_plus_4_delayed) begin 
							$display("[I-type] [Bne] Branched successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [Bne] Branched WRONG ! , %0t",$time);
						end 
					end 

					else begin 
						assert (mips_top_inst.PC_F==  PC_plus_4_delayed) begin 
							$display("[I-type] [Bne] not not equal so didn't branch .. successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [Bne] not not equal but there is an error .. WRONG ! , %0t",$time);
						end

					end 
				end

				6'd6 : begin // blez
					if (`REGFILE[RS] <= 0 ) begin 
						assert(mips_top_inst.PC_F== sign_imm_shifted_delayed + PC_plus_4_delayed) begin 
							$display("[I-type] [blez] Branched successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [blez] Branched WRONG ! , %0t",$time);
						end 
					end 

					else begin 
						assert(mips_top_inst.PC_F==  PC_plus_4_delayed) begin 
							$display("[I-type] [blez] more than zero so didn't branch .. successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [blez] less that zero but there is an error .. WRONG ! , %0t",$time);
						end
					end 
				end

				6'd7 : begin // bgtz
					if (`REGFILE[RS] > 0 ) begin 
						assert(mips_top_inst.PC_F== sign_imm_shifted_delayed + PC_plus_4_delayed) begin 
							$display("[I-type] [bgtz] Branched successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [bgtz] Branched WRONG ! , %0t",$time);
						end 
					end 

					else begin 
						assert(mips_top_inst.PC_F==  PC_plus_4_delayed) begin 
							$display("[I-type] [bgtz] condition is not satisfid so didn't branch .. successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [bgtz] condition is satisfid so there is an error .. WRONG ! , %0t",$time);
						end
					end 
				end

				6'd1 : begin // bltz and bgez
					if (RT == 'd0) begin // bltz
						if (`REGFILE[RS] < 0 ) begin 
							assert(mips_top_inst.PC_F== sign_imm_shifted_delayed + PC_plus_4_delayed) begin 
								$display("[I-type] [bltz] Branched successfully ! , %0t",$time);
							end 
							else begin 
								$display("[I-type] [bltz] Branched WRONG ! , %0t",$time);
							end 
						end 

						else begin 
							if (mips_top_inst.PC_F==  PC_plus_4_delayed) begin 
								$display("[I-type] [bltz] condition is not satisfid so didn't branch .. successfully ! , %0t",$time);
							end 
							else begin 
								$display("[I-type] [bltz] condition is satisfid but there is an error .. WRONG ! , %0t",$time);
							end
						end 
					end 
					else if (RT == 'd1) begin // bgez
						
						assert((`REGFILE[RS] >= 0) && (mips_top_inst.PC_F== sign_imm_shifted_delayed + PC_plus_4_delayed) || (mips_top_inst.PC_F==  PC_plus_4_delayed) && (`REGFILE[RS] < 0) ) begin 
								$display("[I-type] [bgez] Branched successfully ! , %0t",$time);
						end 
						else begin 
							$display("[I-type] [bgez] Branched WRONG ! , %0t",$time);
						end 
						
					end 
					else begin 
						$display("[I-type] Invalid command ! , %0t",$time);
					end
				end
/*

				6'd43 : begin // sw  
					// analyze the statemnt carefully 
					// `REGFILE access 32 bit word while `DATA_MEM access 8 bit word
					// so 4 words have to be concatenated to compare
					assert(`REGFILE[RT] == {`DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 3 ]  ,
										 `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 2 ]  ,
										 `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 1 ]  ,
										 `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])     ]     })
						 $display("[I-type] [sw] correct ! , %0t" ,$time);
					else $display("[I-type] [sw] WRONG !  .. RT = %d , REGFILE[RT] = %h ,RS = %d , DATA_MEM[REGFILE[RS]] = %h , Imm_16_task_extended = %d   %0t"  ,
						 RT ,`REGFILE[RT], RS ,{`DATA_MEM[`REGFILE[RS]+3] , `DATA_MEM[`REGFILE[RS]+2] , `DATA_MEM[`REGFILE[RS]+1], `DATA_MEM[`REGFILE[RS]] } ,Imm_16_task_extended ,$time);
				end

				6'd40 : begin // sb  
					//store one byte only
					assert(`REGFILE[RT] [7:0] == {`DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])]})
						 $display("[I-type] [sb] correct ! , %0t" ,$time);
					else $display("[I-type] [sb] WRONG !  .. RT = %d , REGFILE[RT] = %h ,RS = %d , DATA_MEM[REGFILE[RS]] = %h , Imm_16_task_extended = %d   %0t"  ,
						 RT ,`REGFILE[RT], RS ,{`DATA_MEM[`REGFILE[RS]+3] , `DATA_MEM[`REGFILE[RS]+2] , `DATA_MEM[`REGFILE[RS]+1], `DATA_MEM[`REGFILE[RS]] } ,Imm_16_task_extended ,$time);
				end

				6'd41 : begin // sh  
					//store one byte only
					assert(`REGFILE[RT] [15:0] == {`DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])]  , 
							 	 	 	 	 	`DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 1 ]  })
						 $display("[I-type] [sh] correct ! , %0t" ,$time);
					else $display("[I-type] [sh] WRONG !  .. RT = %d , REGFILE[RT] = %h ,RS = %d , DATA_MEM[REGFILE[RS]] = %h , Imm_16_task_extended = %d   %0t"  ,
						 RT ,`REGFILE[RT], RS ,{`DATA_MEM[`REGFILE[RS]+3] , `DATA_MEM[`REGFILE[RS]+2] , `DATA_MEM[`REGFILE[RS]+1], `DATA_MEM[`REGFILE[RS]] } ,Imm_16_task_extended ,$time);
				end



				6'd35 : begin // lw  
					// Same as above
					assert(`REGFILE[RT] == {`DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 3 ]  ,
										 `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 2 ]  ,
										 `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 1 ]  ,
										 `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])     ]     })
						 $display("[I-type] [lw] correct ! , %0t" ,$time);
					else $display("[I-type] [lw] WRONG !  .. RT = %d , REGFILE[RT] = %h ,RS = %d , DATA_MEM[REGFILE[RS]] = %h , Imm_16_task_extended = %d   %0t"  ,
						 RT ,`REGFILE[RT], RS ,{`DATA_MEM[`REGFILE[RS]+3] , `DATA_MEM[`REGFILE[RS]+2] , `DATA_MEM[`REGFILE[RS]+1], `DATA_MEM[`REGFILE[RS]] } ,Imm_16_task_extended ,$time);
				end

				6'd32 : begin // lb 
				
					assert(`REGFILE[RT] == {24'd0   , `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])]} || 
						`REGFILE[RT] == {{24{1'b1}} , `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])]}     )
						 $display("[I-type] [lb] correct ! , %0t" ,$time);
					else $display("[I-type] [lb] WRONG !  .. RT = %d , REGFILE[RT] = %h ,RS = %d , DATA_MEM[REGFILE[RS]] = %h , Imm_16_task_extended = %d   %0t"  ,
						 RT ,`REGFILE[RT], RS ,{`DATA_MEM[`REGFILE[RS]+3] , `DATA_MEM[`REGFILE[RS]+2] , `DATA_MEM[`REGFILE[RS]+1], `DATA_MEM[`REGFILE[RS]] } ,Imm_16_task_extended ,$time);
				end

				6'd33 : begin // lh 
				
					assert(`REGFILE[RT] == {16'd0   , `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 1 ] ,`DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])]} ||

						`REGFILE[RT] == {{16{1'b1}} , `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS]) + 1 ] ,`DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])]}     )
						 $display("[I-type] [lh] correct ! , %0t" ,$time);
					else $display("[I-type] [lh] WRONG !  .. RT = %d , REGFILE[RT] = %h ,RS = %d , DATA_MEM[REGFILE[RS]] = %h , Imm_16_task_extended = %d   %0t"  ,
						 RT ,`REGFILE[RT], RS ,{`DATA_MEM[`REGFILE[RS]+3] , `DATA_MEM[`REGFILE[RS]+2] , `DATA_MEM[`REGFILE[RS]+1], `DATA_MEM[`REGFILE[RS]] } ,Imm_16_task_extended ,$time);
				end

				6'd36 : begin // lbu 
					assert(`REGFILE[RT] == {24'd0   , `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])]})
						 $display("[I-type] [lbu] correct ! , %0t" ,$time);
					else $display("[I-type] [lbu] WRONG !  .. RT = %d , REGFILE[RT] = %h ,RS = %d , DATA_MEM[REGFILE[RS]] = %h , Imm_16_task_extended = %d   %0t"  ,
						 RT ,`REGFILE[RT], RS ,{`DATA_MEM[`REGFILE[RS]+3] , `DATA_MEM[`REGFILE[RS]+2] , `DATA_MEM[`REGFILE[RS]+1], `DATA_MEM[`REGFILE[RS]] } ,Imm_16_task_extended ,$time);
				end

				6'd37 : begin // lhu 
					assert(`REGFILE[RT] == {16'd0   , `DATA_MEM[ Imm_16_task_extended +(`REGFILE[RS])]})
						 $display("[I-type] [lhu] correct ! , %0t" ,$time);
					else $display("[I-type] [lhu] WRONG !  .. RT = %d , REGFILE[RT] = %h ,RS = %d , DATA_MEM[REGFILE[RS]] = %h , Imm_16_task_extended = %d   %0t"  ,
						 RT ,`REGFILE[RT], RS ,{`DATA_MEM[`REGFILE[RS]+3] , `DATA_MEM[`REGFILE[RS]+2] , `DATA_MEM[`REGFILE[RS]+1], `DATA_MEM[`REGFILE[RS]] } ,Imm_16_task_extended ,$time);
				end

				//6'd28 : begin // 32-bit result multiply   
				//	if (`REGFILE[RD] == `REGFILE[RT] * `REGFILE[RS]) 
				//		 $display("[I-type] [Mul] correct ! , %0t",$time);
				//	else
				//		$display("[I-type] [Mul] WRONG , result may have exceeded 32-bit ! RT = %d RS = %d ,REGFILE[RS] = %h  , REGFILE[RT] = %h , %0t"  ,
				//		RT , RS ,`REGFILE[RS] ,`REGFILE[RT] , $time);
				//end
*/
				

				default : begin 
					$display("[I-Type] Not supported with opcode = %d ,%0t",op_code_tb, $time);
				end 

			endcase
		end
	endtask




	//----------------------------------- Functional Coverage -----------------------------------------//
	//------------------------------------ FIRST GROUP R-type -----------------------------------------//
	covergroup Instructions @(posedge clk);
		R_TYPE : coverpoint func_tb 
		iff ((op_code_tb  == 'd0) &&  rst_n)
		{
	
			bins bltz_bgez = {1};
			bins beq       = {4};
			bins bne       = {5};
			bins blez      = {6};
			bins bgtz  	   = {7};
			bins addi      = {8};
			bins addiu     = {9};
			bins slti      = {10};
			bins sltiu     = {11};
			bins andi      = {12};
			bins ori       = {13};
			bins xori      = {14};
			bins lui  	   = {15};
			bins mul  	   = {28};
			bins lb  	   = {32};
			bins lh   	   = {33};
			bins lw  	   = {35};
			bins lbu 	   = {36};
			bins lhu  	   = {37};
			bins sb  	   = {40};
			bins sh  	   = {41};
			bins sw  	   = {43};
			
		}

		I_TYPE : coverpoint op_code_tb iff (rst_n)
		{
			bins sll   = {0};
			bins srl   = {2};
			bins sra   = {3};
			bins sllv  = {4};
			bins srlv  = {6};
			bins srav  = {7};
			bins jr    = {8};
			bins jalr  = {9};
			bins mfhi  = {16};
			bins mthi  = {17};
			bins mflo  = {18};
			bins mtlo  = {19};
			bins mult  = {24};
			bins multu = {25};
			bins div   = {26};
			bins divu  = {27};
			bins add   = {32};
			bins addu  = {33};
			bins sub   = {34};
			bins subu  = {35};
			bins and_  = {36};
			bins or_   = {37};
			bins xor_  = {38};
			bins nor_  = {39};
			bins slt   = {42};
			bins stlu  = {43};
		
		}
		
		J_TYPE : coverpoint op_code_tb iff (rst_n)
		{
			bins j    = {2};
			bins jal  = {3};
		}

	endgroup
		Instructions  Instructions_instance = new();



	//--------------------------------------------------
	// R-Type ASSERTIONS
	//--------------------------------------------------
	property Add_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        ((mips_top_inst.opcode_D == 'd0) && (mips_top_inst.funct_D == 'd32)) |->  
    	##3 (mips_top_inst.ALU_result_W == $past(mips_top_inst.src_a /* excute */,2) +  $past(mips_top_inst.src_b /* excute */,2));									 
    endproperty

	assert property (Add_property) $display("[ADD] Correct %0t",$time);
  	else $error("[ADD] instruction error: inputs or outputs do not match , %0t",$time);


  	property Sub_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        ((mips_top_inst.opcode_D == 'd0) && (mips_top_inst.funct_D == 'd34)) |->  
    	##3 (mips_top_inst.ALU_result_W == $past(mips_top_inst.src_a /* excute */,2) -  $past(mips_top_inst.src_b /* excute */,2));									 
    endproperty

	assert property (Sub_property) $display("[SUB] Correct  %0t",$time);
  	else $error("[SUB] instruction error: inputs or outputs do not match , %0t",$time);

  	property AND_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        ((mips_top_inst.opcode_D == 'd0) && (mips_top_inst.funct_D == 'd36)) |->  
    	##3 (mips_top_inst.ALU_result_W == ($past(mips_top_inst.src_a /* excute */,2) &  $past(mips_top_inst.src_b /* excute */,2)));									 
    endproperty

	assert property (AND_property) $display("[AND] Correct  %0t",$time);
  	else $error("[AND] instruction error: inputs or outputs do not match , %0t",$time);

  	property OR_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        ((mips_top_inst.opcode_D == 'd0) && (mips_top_inst.funct_D == 'd37)) |->  
    	##3 (mips_top_inst.ALU_result_W == ($past(mips_top_inst.src_a /* excute */,2) |  $past(mips_top_inst.src_b /* excute */,2)));									 
    endproperty

	assert property (OR_property) $display("[OR] Correct  %0t",$time);
  	else $error("[OR] instruction error: inputs or outputs do not match , %0t",$time);

  	property sll_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        ((mips_top_inst.opcode_D == 'd0) && (mips_top_inst.funct_D == 'd0)) |->  
    	##3 (mips_top_inst.ALU_result_W == ($past(mips_top_inst.src_a /* excute */,2)) <<  ($past(mips_top_inst.src_b /* excute */,2))   );									 
    endproperty

	assert property (sll_property) $display("[SLL] Correct  %0t",$time);
  	else $error("[SLL] instruction error: inputs or outputs do not match , %0t",$time);

	//--------------------------------------------------
	// J-Type ASSERTIONS
	//--------------------------------------------------

	property J_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        (mips_top_inst.opcode_D == 'd2) |=>  
    	$past(mips_top_inst.jump_addr_D , 1) == mips_top_inst.PC_F ;									 
    endproperty

    assert property (J_property) $display("[J] Correct %0t",$time);
  	else $error("[J] instruction error: inputs or outputs do not match , %0t",$time);

  	property Jal_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        (mips_top_inst.opcode_D == 'd3) |=>  
    	$past(mips_top_inst.jump_addr_D , 1 ) == mips_top_inst.PC_F ;									  
    endproperty

    assert property (Jal_property) $display("[Jal] Correct %0t",$time);
  	else $error("[Jal] instruction error: inputs or outputs do not match , %0t",$time);

  	property Jr_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        (mips_top_inst.opcode_D == 'd0) && (mips_top_inst.funct_D == 'd8) |->  
    	##1 ($past(mips_top_inst.rd_data1 , 1 ) == mips_top_inst.PC_F );									  
    endproperty

    assert property (Jr_property) $display("[Jr] Correct %0t",$time);
  	else $error("[Jr] instruction error: inputs or outputs do not match , %0t",$time);
/*

	//--------------------------------------------------
	// I-Type ASSERTIONS
	//--------------------------------------------------
	property Addi_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        (mips_top_inst.opcode_D == 'd8) |->  
    	##3 (mips_top_inst.ALU_result_W == $past(mips_top_inst.src_a,2) +  $past(mips_top_inst.src_b,2));									 
    endproperty

    assert property (Addi_property) $display("[ADDI] Correct %0t",$time);
  	else $error("[ADDI] instruction error: inputs or outputs do not match , %0t",$time);


  	property Addiu_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        (mips_top_inst.opcode_D == 'd9) |->  
    	##3 (mips_top_inst.ALU_result_W == $past(mips_top_inst.src_a,2) +  $past(mips_top_inst.src_b,2));									 
    endproperty

    assert property (Addiu_property) $display("[ADDIU] Correct %0t",$time);
  	else $error("[ADDIU] instruction error: inputs or outputs do not match , %0t",$time);


  	property beq_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        (mips_top_inst.branch_control_D) |->  
    	(mips_top_inst.PCBranch_result_D == mips_top_inst.PC_W);									 
    endproperty

    assert property (beq_property) $display("[beq] Correct %0t",$time);
  	else $error("[beq] instruction error: inputs or outputs do not match , %0t",$time);
   	

  	property lw_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        (mips_top_inst.opcode_D == 'd35) |->  
	##2 (mips_top_inst.ALU_result_M == $past(mips_top_inst.src_a_D,2) + $past(mips_top_inst.SignExt_D,2)); 
		//&& (`DATA_MEM[(mips_top_inst.ALU_result_M)] == mips_top_inst.ReadData_M));									 
    endproperty

    assert property (lw_property) $display("[lw] Correct %0t",$time);
  	else $error("[lw] instruction error: inputs or outputs do not match , %0t",$time);

  	property sw_property ;
        @(posedge clk) 
        disable iff (!rst_n)
        (mips_top_inst.opcode_D == 'd43) |->  
	##3 (mips_top_inst.ReadData_W == `DATA_MEM[($past(mips_top_inst.src_a_D,3) + $past(mips_top_inst.SignExt_D,3))]); 
		//&& (`DATA_MEM[mips_top_inst.ALU_result_M] == mips_top_inst.rd_data_data_mem_M);									 
    endproperty

    assert property (sw_property) $display("[sw] Correct %0t",$time);
  	else $error("[sw] instruction error: inputs or outputs do not match , %0t",$time);

*/







endmodule 