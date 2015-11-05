
module testStateMachine();

    reg s_clk;
    reg CS;
    reg read_write;
    wire miso_buff;
    wire ad_we;
    wire sr_we;
    wire dm_we;

    fsm dut(.s_clk(s_clk),
    			 .CS(CS),
           .read_write(read_write),
		       .miso_buff(miso_buff),
    			 .ad_we(ad_we),
    			 .sr_we(sr_we),
           .dm_we(dm_we));


    // Generate clock (50MHz)
    initial s_clk=0;
    always #10 s_clk=!s_clk;    // 50MHz Clock

    initial begin

        $dumpfile("fsm.vcd");
        $dumpvars(0,dut);

        CS = 1; #20
        CS = 0; read_write = 1; #300
        // CS = 1; #20
        // CS = 0; read_write = 0; #300
        // CS = 1; #20

        $finish;
    end

    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)

endmodule
