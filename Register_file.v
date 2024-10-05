`timescale 1ns / 1ps
module register_file (
	input wire 		  clk , rst_n ,
	input wire 		  wr_en3 ,
	input wire [4:0]  rd_addr1 , // Rs address
	input wire [4:0]  rd_addr2 , // Rt address
	input wire [4:0]  wr_addr3 , // Rd address (destination) 
	input wire [31:0] wr_data3 , // Rs
	// output 
	output wire [31:0] rd_data1 , // Rs contents
	output wire [31:0] rd_data2   // Rt contents
	);
	
	//------------------------------------------------------------
	// 32 location of 32-bit each
	//------------------------------------------------------------
	reg [31:0] regfile [0:31] ;
	integer i  ;

	//combinational read operation 
	assign rd_data1 = (rd_addr1 != 0) ? regfile [rd_addr1] : 0 ;
	assign rd_data2 = (rd_addr2 != 0) ? regfile [rd_addr2] : 0 ; 

	always @(negedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// assign all the default values for all registers .. to be continued
			for ( i = 0 ; i < 32 ; i = i +1)
			regfile [i] <= 'd0 ;			
		end
		else  begin
			if (wr_en3) begin 
				regfile[wr_addr3] <= wr_data3 ;
			end 
			regfile [0] <= 'd0 ; // register zero

			//rd_data1 = (rd_addr1 != 0) ? regfile [rd_addr1] : 0 ;
			//rd_data2 = (rd_addr2 != 0) ? regfile [rd_addr2] : 0 ;
		end
	end
endmodule 