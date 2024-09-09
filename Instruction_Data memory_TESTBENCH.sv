`timescale 1ns / 1ps 
module ram_memory_tb ;
	parameter DEPTH = 1 * 1024 ,
			  WIDTH = 8 ;

	// signal declaration 

	reg		               clk = 0 ;
	// write ports
	reg  	  			   wr_en ;
	reg [$clog2(DEPTH)-1:0] addr ;    // 
	reg [(4*WIDTH)-1:0] 	   wr_data ; // 32 bit
	
	// read port
	wire [(4*WIDTH)-1:0] rd_data  ;	 // 32 bit

	// DUT instantiation
	ram_memory DUT (.*);

	parameter CLK_PERIOD  = 20 ;
	// clk generation 
	always #(CLK_PERIOD/2) clk = !clk ;

	initial begin
		#CLK_PERIOD ; 
		$display("check that the memory is zero'ed ,%t ",$time);
		#CLK_PERIOD ;


		// writing in the first location then read it in the following cycle
		@(posedge clk);
		wr_en   = 1'b1 ;
		addr    = 'd0 ;
		wr_data = 32'hABCD_ABCD ;
		#CLK_PERIOD ;
		wr_en   = 1'b0 ;
		#CLK_PERIOD ;
		check_output(32'hABCD_ABCD);

		// writing in the second location then read it in the following cycle
		wr_en   = 1'b1 ;
		addr    = 'd4*1 ;
		wr_data = 32'hABCD_ABCD ;
		#CLK_PERIOD ;
		wr_en   = 1'b0 ;
		#CLK_PERIOD ;
		check_output(32'hABCD_ABCD);



		// writing in the fifth location then read it in the following cycle
		wr_en   = 1'b1 ;
		addr    = 'd4*5 ;
		wr_data = 32'hABCD_FFFF ;
		#CLK_PERIOD ;
		wr_en   = 1'b0 ;
		#CLK_PERIOD ;
		check_output(32'hABCD_FFFF);



		// writing in the random location then read it in the following cycle
		wr_en   = 1'b1 ;
		addr    = 'd4*50 ;
		wr_data = 32'hFFFF_0000 ;
		#CLK_PERIOD ;
		wr_en   = 1'b0 ;
		#CLK_PERIOD ;
		check_output(32'hFFFF_0000);



		// writing in the last location then read it in the following cycle
		wr_en   = 1'b1 ;
		addr    = 'd1024 ;
		wr_data = 32'hF0F0_F0F0 ;
		#CLK_PERIOD ;
		wr_en   = 1'b0 ;
		#CLK_PERIOD ;
		check_output(32'hF0F0_F0F0);

		# (5*CLK_PERIOD) $stop;

	end 

	task check_output(input logic [31:0] expected);
		begin 
			if (expected != rd_data) begin 
				$display("ERROR , expected = %h while rd_data = %h ",expected ,rd_data );
			end 
			else if (expected == rd_data) begin 
				$display("PASS , expected = %h while rd_data = %h ",expected ,rd_data );
			end 
			else $display("Not Applicable");
		end 
	endtask : check_output

endmodule 
