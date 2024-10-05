onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_testbench/mips_top_inst/clk
add wave -noupdate /mips_testbench/mips_top_inst/rst_n
add wave -noupdate /mips_testbench/mips_top_inst/jump_addr_D
add wave -noupdate /mips_testbench/mips_top_inst/Jr_mux_out_W
add wave -noupdate /mips_testbench/mips_top_inst/ForwardRs_D
add wave -noupdate -height 40 -expand -group {Hazard Unit} /mips_testbench/mips_top_inst/Hazarad_Unit_DUT/LwStall
add wave -noupdate -height 40 -group {Fetch Satge} /mips_testbench/mips_top_inst/Stall_F
add wave -noupdate -height 40 -group {Fetch Satge} /mips_testbench/mips_top_inst/PC_plus_4_F
add wave -noupdate -height 40 -group {Fetch Satge} /mips_testbench/mips_top_inst/PC_F
add wave -noupdate -height 40 -group {Fetch Satge} /mips_testbench/mips_top_inst/INSTRUCTION_F
add wave -noupdate -color Gold -itemcolor Gold /mips_testbench/mips_top_inst/INSTRUCTION_D
add wave -noupdate /mips_testbench/mips_top_inst/Rs_D
add wave -noupdate /mips_testbench/mips_top_inst/Stall_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/SignExt_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/ZeroExt_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/src_b_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/src_a_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/shamt_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/Rt_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/RegWrite_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/RegDst_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/PCBranch_result_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/PC_plus_4_D
add wave -noupdate -height 40 -group {Decode Stage} -color Red -itemcolor Red -radix unsigned /mips_testbench/mips_top_inst/opcode_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/MemWrite_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/MemtoReg_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/lo_reg
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/link_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/jump_shifted_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/Jr_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/J_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/hi_reg
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/funct_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/ForwardB_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/ForwardA_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/ByteControl_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/Branch_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/branch_control_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/Arith_u_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/AluSrc_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/AluControl
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/Alu_opcode_D
add wave -noupdate -height 40 -group {Decode Stage} /mips_testbench/mips_top_inst/Rd_D
add wave -noupdate /mips_testbench/mips_top_inst/Rs_E
add wave -noupdate /mips_testbench/mips_top_inst/WriteReg_M
add wave -noupdate /mips_testbench/mips_top_inst/WriteReg_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/SignExt_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/ZeroExt_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/src_b_muxout_muxin
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/src_b_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/src_b
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/src_a_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/src_a
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/SignExt_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/shamt_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/Rt_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/RegWrite_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/RegDst_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/Rd_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/PC_plus_4_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/opcode_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/MemWrite_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/MemtoReg_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/link_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/Jr_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/J_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/funct_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/ForwardB_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/ForwardA_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/Flush_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/ByteControl_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/Arith_u_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/ALUSrc_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/ALU_result_E
add wave -noupdate -height 40 -expand -group {Excute Stage} /mips_testbench/mips_top_inst/Alu_opcode_E
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/WriteData_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/RegWrite_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/ReadData_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/rd_data_data_mem_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/rd_data2
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/rd_data1
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/PC_plus_4_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/MemWrite_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/MemtoReg_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/link_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/Jr_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/J_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/ByteControl_M
add wave -noupdate -height 40 -group {Memory Stage} /mips_testbench/mips_top_inst/ALU_result_M
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/RegWrite_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/ReadData_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/rd_data_data_mem_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/PC_plus_4_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/MemtoReg_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/link_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/Jr_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/J_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/ByteControl_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/Byte_Control_out_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/PC_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/ALU_result_W
add wave -noupdate -height 40 -group {WriteBack Stage} /mips_testbench/mips_top_inst/WriteReg_W
add wave -noupdate /mips_testbench/mips_top_inst/wr_data3
add wave -noupdate /mips_testbench/mips_top_inst/wr_addr3
add wave -noupdate /mips_testbench/mips_top_inst/sign_imm_shifted
add wave -noupdate -height 40 -expand -group {Branch Prediction} /mips_testbench/mips_top_inst/prediction_mux_out_W
add wave -noupdate -height 40 -expand -group {Branch Prediction} /mips_testbench/mips_top_inst/Misprediction_for_taken
add wave -noupdate -height 40 -expand -group {Branch Prediction} /mips_testbench/mips_top_inst/Misprediction_for_not_taken
add wave -noupdate -height 40 -expand -group {Branch Prediction} /mips_testbench/mips_top_inst/Branch_predictor_target
add wave -noupdate -height 40 -expand -group {Branch Prediction} /mips_testbench/mips_top_inst/Branch_Predictor_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {122003 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {248142 ps}
