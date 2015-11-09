
module testStateMachine();
    reg clk;
    reg s_clk;
    reg CS;
    reg read_write;
    wire miso_buff;
    wire ad_we;
    wire sr_we;
    wire dm_we;

    fsm dut(.clk(clk),
            .s_clk(s_clk),
    		.CS(CS),
            .read_write(read_write),
		    .miso_buff(miso_buff),
    		.ad_we(ad_we),
    		.sr_we(sr_we),
           .dm_we(dm_we));


    // Generate clock (50MHz)
    initial begin
        s_clk=0;
        clk=0;
    end

    always #10 s_clk=!s_clk;    // 50MHz Clock
    always #5 clk=!clk;

    initial begin

        $dumpfile("fsm.vcd");
        $dumpvars(0,dut);

        CS = 1; #20
        CS = 0; read_write = 1; #700
        CS = 1; #20
        CS = 0; read_write = 0; #700
        CS = 1; #20

        $finish;
    end

    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)

endmodule
