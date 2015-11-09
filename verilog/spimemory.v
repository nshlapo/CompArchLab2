//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    input           fault_pin,  // For fault injection testing
    output [3:0]    leds        // LEDs for debugging
);
    wire [4:0] unwire;
    wire sclkpos, sclkneg, serialin, chipselect, miso_buff, dm_we, ad_we, sr_we, serialout, triwire;
    wire [7:0] memout, parout, address;

    inputconditioner_breakable serialcond (clk, mosi_pin, serialin, unwire[0], unwire[1], fault_pin);
    inputconditioner clockcond (clk, sclk_pin, unwire[2], sclkpos, sclkneg);
    inputconditioner statemachinecond (clk, cs_pin, chipselect, unwire[3], unwire[4]);

    shiftregister shreg (clk, sclkpos, sr_we, memout, serialin, parout, serialout);

    fsm fistma (clk, sclkpos, chipselect, parout[0], miso_buff, dm_we, ad_we, sr_we);

    addressLatch adlatch (clk, ad_we, parout, address);

    datamemory dmem (clk,  memout, address[7:1], dm_we, parout);

    DFF dff (clk, sclkneg, serialout, triwire);

    triBuff buff (triwire, miso_buff, miso_pin);

endmodule

