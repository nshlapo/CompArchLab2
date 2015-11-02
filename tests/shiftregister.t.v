//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn;

    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk),
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad),
    		           .parallelDataIn(parallelDataIn),
    		           .serialDataIn(serialDataIn),
    		           .parallelDataOut(parallelDataOut),
    		           .serialDataOut(serialDataOut));

    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
      $dumpfile("shftregister.vcd");
      $dumpvars(0,dut);


      $display("-----------------------------------------------");
      $display("Testing parallel in, serial out.");
      $display("parallelLoad | parallelDataIn | serialDataOut | Expected Out");
      parallelLoad = 1; parallelDataIn = 8'b10111010; #20
      $display("%b            | %b       | %b             | 1", parallelLoad, parallelDataIn, serialDataOut);
      $display("-----------------------------------------------");
      parallelLoad = 0;
      $display("Testing serial in, parallel out.");
      $display("peripheralClkEdge | serialDataIn | parallelDataOut | Expected Out");
      peripheralClkEdge = 1; serialDataIn = 1; #20
      $display("%b                 | %b            | %b        | 01110101", peripheralClkEdge, serialDataIn, parallelDataOut);
      $display("-----------------------------------------------");
      $display("Testing parallel load and peripheralClkEdge. peripheralClkEdge wins.");
      parallelLoad = 1;
      $display("parallelLoad | peripheralClkEdge | parallelDataIn | parallelDataOut | Expected Out");
      parallelDataIn = 8'b0; serialDataIn =  0; #20
      $display("%b            | %b                 | %b       | %b        | 11101010", parallelLoad, peripheralClkEdge, parallelDataIn, parallelDataOut);
      $display("-----------------------------------------------");
      $finish;
    end

endmodule
