module d_latch #(parameter WIDTH = 32)(
    input wire             clk ,
    input wire [WIDTH-1:0] D,      // Data input
    input wire             enable, // Enable input (control signal)
    input wire             CLR ,   // clear signal
    output reg [WIDTH-1:0] Q       // Latch output
);

always @ (*) begin
    if (clk) begin 
        if (CLR) begin
            Q = 'd0 ;         
        end
        else if (enable) begin
            Q = D ;
        end
    end
end

endmodule
