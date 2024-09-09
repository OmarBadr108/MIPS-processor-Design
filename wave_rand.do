onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_testbench_randomized/mips_top_inst/zero
add wave -noupdate /mips_testbench_randomized/mips_top_inst/wr_en_ins
add wave -noupdate /mips_testbench_randomized/mips_top_inst/wr_data3_mux_out
add wave -noupdate /mips_testbench_randomized/mips_top_inst/wr_data
add wave -noupdate /mips_testbench_randomized/mips_top_inst/wr_addr3
add wave -noupdate /mips_testbench_randomized/mips_top_inst/src_b_mux_out
add wave -noupdate /mips_testbench_randomized/mips_top_inst/sign_imm_shifted
add wave -noupdate /mips_testbench_randomized/mips_top_inst/sign_imm
add wave -noupdate /mips_testbench_randomized/mips_top_inst/shamt
add wave -noupdate /mips_testbench_randomized/mips_top_inst/Rt
add wave -noupdate /mips_testbench_randomized/mips_top_inst/rst
add wave -noupdate /mips_testbench_randomized/mips_top_inst/Rs
add wave -noupdate /mips_testbench_randomized/mips_top_inst/RegWrite
add wave -noupdate /mips_testbench_randomized/mips_top_inst/RegDst
add wave -noupdate /mips_testbench_randomized/mips_top_inst/rd_data_data_mem
add wave -noupdate /mips_testbench_randomized/mips_top_inst/rd_data2
add wave -noupdate /mips_testbench_randomized/mips_top_inst/rd_data1
add wave -noupdate /mips_testbench_randomized/mips_top_inst/Rd
add wave -noupdate /mips_testbench_randomized/mips_top_inst/PCBranch_result
add wave -noupdate /mips_testbench_randomized/mips_top_inst/PC_plus_4
add wave -noupdate /mips_testbench_randomized/mips_top_inst/pc_next
add wave -noupdate /mips_testbench_randomized/mips_top_inst/pc
add wave -noupdate /mips_testbench_randomized/mips_top_inst/opcode
add wave -noupdate /mips_testbench_randomized/mips_top_inst/MemWrite
add wave -noupdate /mips_testbench_randomized/mips_top_inst/MemtoReg
add wave -noupdate /mips_testbench_randomized/mips_top_inst/jump_shifted
add wave -noupdate /mips_testbench_randomized/mips_top_inst/jump
add wave -noupdate /mips_testbench_randomized/mips_top_inst/INSTRUCTION
add wave -noupdate /mips_testbench_randomized/mips_top_inst/funct
add wave -noupdate /mips_testbench_randomized/mips_top_inst/clk
add wave -noupdate /mips_testbench_randomized/mips_top_inst/branch_control_out
add wave -noupdate /mips_testbench_randomized/mips_top_inst/branch_control
add wave -noupdate /mips_testbench_randomized/mips_top_inst/Branch
add wave -noupdate /mips_testbench_randomized/mips_top_inst/AluSrc
add wave -noupdate /mips_testbench_randomized/mips_top_inst/AluControl
add wave -noupdate /mips_testbench_randomized/mips_top_inst/alu_result
add wave -noupdate /mips_testbench_randomized/mips_top_inst/alu_opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46028 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {23759334 ps} {24044246 ps}
