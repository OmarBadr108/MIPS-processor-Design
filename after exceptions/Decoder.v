`timescale 1ns / 1ps 
module Decoder #(parameter WIDTH = 32)(
	input wire interrupt ,
	input wire break_point ,
	input wire overflow_E ,
	input wire syscall_D ,
	input wire undef_D ,

	output reg [2:0] int_cause
	);

always @(*) begin 
	if 	    (interrupt)     int_cause = 3'd0 ;
	else if (syscall_D)     int_cause = 3'd1 ;
	else if (break_point) int_cause = 3'd2 ;
	else if (undef_D)  	 	int_cause = 3'd3 ;
	else if (overflow_E)  	int_cause = 3'd4 ;
	else  		 	 	    int_cause = 3'd0 ;
end  	

endmodule 