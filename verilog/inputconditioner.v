//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(
input       clk,            // Clock domain to synchronize input to
input       noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles

    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;

    always @(posedge clk ) begin

        // once we display a posedge or negedge, reset them
        if (positiveedge || negativeedge) begin
            positiveedge <= 0;
            negativeedge <= 0;
        end

        // if value hasn't changed, don't start anti-glitch counting yet
        if(conditioned == synchronizer1)
            counter <= 0;

        else begin
            // if counter finished, display high posedge or negedge and shift new conditioned value
            if( counter == waittime) begin
                positiveedge <= synchronizer1;
                negativeedge <= !synchronizer1;
                counter <= 0;
                conditioned <= synchronizer1;
            end
            // increment counter until complete
            else begin
                counter <= counter+1;
            end
        end

        // always shift into the two synch registers
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    end

endmodule

module inputconditioner_breakable
(
input       clk,            // Clock domain to synchronize input to
input       noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge,    // 1 clk pulse at falling edge of conditioned
input fault
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles

    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;

    always @(posedge clk) begin
        // if fault_pin is high, output of the conditioner should always be zero
        if (fault == 1)
            conditioned <= 0;

        else begin

             // once we display a posedge or negedge, reset them
            if (positiveedge || negativeedge) begin
                positiveedge <= 0;
                negativeedge <= 0;
            end

            // if value hasn't changed, don't start anti-glitch counting yet
            if(conditioned == synchronizer1)
                counter <= 0;

            else begin
                // if counter finished, display high posedge or negedge and shift new conditioned value
                if( counter == waittime) begin
                    positiveedge <= synchronizer1;
                    negativeedge <= !synchronizer1;
                    counter <= 0;
                    conditioned <= synchronizer1;
                end
                // increment counter until complete
                else begin
                    counter <= counter+1;
                end
            end

            // always shift into the two synch registers
            synchronizer0 <= noisysignal;
            synchronizer1 <= synchronizer0;
        end
    end

endmodule
