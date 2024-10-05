module Branch_Predictor_tb ;
	reg  	   clk = 0, rst_n ;
	reg 	   branch_taken_D ;
	reg [31:0] PCBranch_result_D ; // write target
	reg [31:0] PC_D ; // write address
	reg        Branch_D ;
	reg [31:0] PC_F ;

	wire [31:0] Branch_predictor_target ; // will alwyas contain that the branch address 
	wire 	  	Branch_Predictor_sel ;
	wire  	    Misprediction_for_taken ;
	wire  	    Misprediction_for_not_taken ;
	
	Branch_Predictor DUT (.*) ;


	parameter CLK_PERIOD  = 20 ;
	// clk generation 
	always #(CLK_PERIOD/2) clk = !clk ;

	initial begin 
		Branch_D       = 1'b0 ;
		branch_taken_D = 1'b0 ;
		PC_D = 32'h0000bbb0 ;
		PC_F = 32'h0000bbb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;

		rst_n = 1'b0 ;
		#(4*CLK_PERIOD);
		rst_n = 1'b1 ;

		$display("check that the memory is zero'ed ,%t ",$time);

		#(4*CLK_PERIOD);
		@(posedge clk)
		Branch_D       = 1'b1 ;
		branch_taken_D = 1'b1 ;
		PC_D = 32'h0000bbc0 ;
		PC_F = 32'h0000bbb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;


		#(1*CLK_PERIOD);
		Branch_D       = 1'b0 ;
		branch_taken_D = 1'b0 ;
		PC_D = 32'h0000bbc0 ;
		PC_F = 32'h0000bbb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;



		#(1*CLK_PERIOD);
		Branch_D       = 1'b1 ;
		branch_taken_D = 1'b1 ;
		PC_D = 32'h0000aaa0 ;
		PC_F = 32'h0000eeb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;



		#(1*CLK_PERIOD);
		Branch_D       = 1'b0 ;
		branch_taken_D = 1'b0 ;
		PC_D = 32'h0000bbc0 ;
		PC_F = 32'h0000bbb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;


		#(1*CLK_PERIOD);
		Branch_D       = 1'b0 ;
		branch_taken_D = 1'b0 ;
		PC_D = 32'h0000bbc0 ;
		PC_F = 32'h0000bbb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;




		#(1*CLK_PERIOD);
		Branch_D       = 1'b1 ;
		branch_taken_D = 1'b0 ;
		PC_D = 32'h0000b560 ;
		PC_F = 32'h0000b264 ;
		PCBranch_result_D = 32'h0000_fff0 ;



		#(1*CLK_PERIOD);
		Branch_D       = 1'b0 ;
		branch_taken_D = 1'b0 ;
		PC_D = 32'h0000bbc0 ;
		PC_F = 32'h0000bbb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;



		#(1*CLK_PERIOD);
		Branch_D       = 1'b0 ;
		branch_taken_D = 1'b0 ;
		PC_D = 32'h0000bbc0 ;
		PC_F = 32'h0000bbb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;



		#(1*CLK_PERIOD);
		Branch_D       = 1'b1 ;
		branch_taken_D = 1'b1 ;
		PC_D = 32'h0000bbb0 ;
		PC_F = 32'h0000bbb0 ;
		PCBranch_result_D = 32'h0000_fff0 ;


		#(1*CLK_PERIOD);
		Branch_D       = 1'b0 ;
		branch_taken_D = 1'b0 ;
		PC_D = 32'h0000bbc0 ;
		PC_F = 32'h0000bbb4 ;
		PCBranch_result_D = 32'h0000_fff0 ;

		#(10*CLK_PERIOD);
		$stop ;
	end 
endmodule 