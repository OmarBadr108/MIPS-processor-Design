module d_flipflop (
    input wire D,       // Data input
    input wire clk,     // Clock input
    input wire rst_n,     // Synchronous reset input
    output reg Q        // Flip-flop output
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      Q <= 1'b0;        // Reset the flip-flop to 0 on reset signal
    end
    else begin
      Q <= D;           // On clock's rising edge, update Q to D
    end
  end

endmodule
