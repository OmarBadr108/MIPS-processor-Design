module equal_unit_D (
	input wire [31:0] in1 , 
	input wire [31:0] in2 ,

	output wire equal_unit_out
	);

assign equal_unit_out = (in1 == in2)? 1 : 0 ;
endmodule 