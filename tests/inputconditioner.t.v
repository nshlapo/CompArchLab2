//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;

    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));


    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin

        $dumpfile("inputconditioner.vcd");
        $dumpvars(0,dut);

        $display("pin conditioned rising falling | Expected");
        // input sync. Changing input 7 seconds into clock cycle. Checking
        // output 123 seconds afterward (on clock cycle). Output is
        // synchronized.

        $display("Testing input sync");
        pin = 0; #70
        #7
        pin = 1; #123
        $display("%b   %b           %b      %b       | %b %b %b %b", pin,
                 conditioned, rising, falling, 1'b1, 1'b1, 1'b1, 1'b0);
        // Debouncing. Signal switches rapidly for 184 seconds. COnditioned
        // remains constant.

        $display("Testing debouncing");
        pin = 0; #8 pin = 1; #8 pin = 0; #8 pin = 1; #8 pin = 0; #8 pin = 1; #8
        pin = 0; #8 pin = 1; #8 pin = 0; #8 pin = 1; #8 pin = 0; #8 pin = 1; #8
        pin = 0; #8 pin = 1; #8 pin = 0; #8 pin = 1; #8 pin = 0; #8 pin = 1; #8
        pin = 0; #8 pin = 1; #8 pin = 0; #8 pin = 1; #8 pin = 0; #8
        $display("%b   %b           %b      %b       | %b %b %b %b", pin,
                 conditioned, rising, falling, 1'b0, 1'b1, 1'b0, 1'b0);
        #6

        // Edge detection.
        $display("Testing edge detection: falling");
        pin = 1; #20
        pin = 0; #110
        $display("%b   %b           %b      %b       | %b %b %b %b", pin,
                 conditioned, rising, falling, 1'b0, 1'b0, 1'b0, 1'b1);

        $display("Testing edge detection: rising");
        #10
        pin = 1; #110
        $display("%b   %b           %b      %b       | %b %b %b %b", pin,
                 conditioned, rising, falling, 1'b1, 1'b1, 1'b1, 1'b0);
        #10
        $finish;
    end

    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)

endmodule
