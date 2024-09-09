module Hazarad_Unit (
	input wire [4:0] RsD , RtD ,
	input wire [4:0] RsE , RtE ,
	input wire [4:0] WriteRegW ,
	input wire [4:0] WriteRegM ,
	input wire [4:0] WriteRegE ,
	input wire       RegWriteW ,
	input wire       MemtoRegM , RegWriteM ,
	input wire       MemtoRegE , RegWriteE ,
	input wire 		 BranchD ,

	output reg ForwardAE ,
	output reg ForwardBE ,
	output reg FlushE ,
	output reg StallD ,
	output reg StallF
	);


endmodule 