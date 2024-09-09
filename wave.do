onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_testbench/clk
add wave -noupdate /mips_testbench/rst_n
add wave -noupdate /mips_testbench/Imm_16
add wave -noupdate /mips_testbench/check_I_type_Instruction/Imm_16_task
add wave -noupdate /mips_testbench/check_I_type_Instruction/Imm_16_task_extended
add wave -noupdate /mips_testbench/check_I_type_Instruction/RS
add wave -noupdate -height 70 -expand -group INSTRUCTION -color Gold -radix unsigned /mips_testbench/mips_top_inst/Rs
add wave -noupdate -height 70 -expand -group INSTRUCTION -color Gold -radix unsigned /mips_testbench/mips_top_inst/Rt
add wave -noupdate -height 70 -expand -group INSTRUCTION -color Gold -radix unsigned /mips_testbench/mips_top_inst/Rd
add wave -noupdate -height 70 -expand -group INSTRUCTION -color Gold -radix unsigned /mips_testbench/mips_top_inst/shamt
add wave -noupdate -height 70 -expand -group INSTRUCTION -color Gold -radix hexadecimal /mips_testbench/mips_top_inst/INSTRUCTION
add wave -noupdate -height 40 -expand -group {Control Unit} -radix unsigned /mips_testbench/mips_top_inst/opcode
add wave -noupdate -height 40 -expand -group {Control Unit} -radix unsigned /mips_testbench/mips_top_inst/funct
add wave -noupdate -height 40 -expand -group {Control Unit} /mips_testbench/mips_top_inst/MemtoReg
add wave -noupdate -height 40 -expand -group {Control Unit} /mips_testbench/mips_top_inst/MemWrite
add wave -noupdate -height 40 -expand -group {Control Unit} /mips_testbench/mips_top_inst/Branch
add wave -noupdate -height 40 -expand -group {Control Unit} /mips_testbench/mips_top_inst/AluSrc
add wave -noupdate -height 40 -expand -group {Control Unit} /mips_testbench/mips_top_inst/RegDst
add wave -noupdate -height 40 -expand -group {Control Unit} /mips_testbench/mips_top_inst/RegWrite
add wave -noupdate -height 40 -expand -group {Control Unit} /mips_testbench/mips_top_inst/jump
add wave -noupdate -height 40 -expand -group ALU -color {Violet Red} /mips_testbench/mips_top_inst/zero
add wave -noupdate -height 40 -expand -group ALU -color {Violet Red} /mips_testbench/mips_top_inst/src_b_mux_out
add wave -noupdate -height 40 -expand -group ALU -color {Violet Red} /mips_testbench/mips_top_inst/rd_data1
add wave -noupdate -height 40 -expand -group ALU -color {Violet Red} /mips_testbench/mips_top_inst/AluControl
add wave -noupdate -height 40 -expand -group ALU -color {Violet Red} /mips_testbench/mips_top_inst/alu_result
add wave -noupdate -height 40 -expand -group ALU -color {Violet Red} /mips_testbench/mips_top_inst/alu_opcode
add wave -noupdate -height 40 -expand -group {Program Counter} /mips_testbench/mips_top_inst/PCBranch_result
add wave -noupdate -height 40 -expand -group {Program Counter} /mips_testbench/mips_top_inst/PC_plus_4
add wave -noupdate -height 40 -expand -group {Program Counter} /mips_testbench/mips_top_inst/pc_next
add wave -noupdate -height 40 -expand -group {Program Counter} /mips_testbench/mips_top_inst/pc
add wave -noupdate /mips_testbench/mips_top_inst/clk
add wave -noupdate -height 40 -expand -group RegFile -color Khaki -radix unsigned /mips_testbench/mips_top_inst/wr_addr3
add wave -noupdate -height 40 -expand -group RegFile -color Khaki /mips_testbench/mips_top_inst/rd_data2
add wave -noupdate -height 40 -expand -group {Sign Extension} /mips_testbench/mips_top_inst/sign_imm_shifted
add wave -noupdate -height 40 -expand -group {Sign Extension} /mips_testbench/mips_top_inst/sign_imm
add wave -noupdate -height 40 -expand -group Branch -color Cyan /mips_testbench/mips_top_inst/branch_control_out
add wave -noupdate -height 40 -expand -group Branch -color Cyan /mips_testbench/mips_top_inst/branch_control
add wave -noupdate /mips_testbench/mips_top_inst/rd_data_data_mem
add wave -noupdate /mips_testbench/mips_top_inst/jump_shifted
add wave -noupdate /mips_testbench/Imm_26
add wave -noupdate /mips_testbench/mips_top_inst/zero_extend_imm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {126807 ps} 0}
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
WaveRestoreZoom {0 ps} {284912 ps}
