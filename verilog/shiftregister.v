//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out q
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut       // Positive edge synchronized
);

    reg [width-1:0]      shiftregistermem;

    always @(posedge clk) begin
      // if the peripheral clock ticks, shift new data in
      if (peripheralClkEdge == 1)  begin
        shiftregistermem <= {shiftregistermem[width-2:0], serialDataIn};
      end
      // if parallel input selected, and there is no new serial input, load parallel data
      else if (parallelLoad == 1) begin
        shiftregistermem <= parallelDataIn;
      end
    end

    //serial and parallel out should be constantly driven
    assign serialDataOut = shiftregistermem[width-1];
    assign parallelDataOut = shiftregistermem;

endmodule
