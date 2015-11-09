
module testSPI();
  reg clk;
  reg sclk_pin;
  reg cs_pin;
  wire miso_pin;
  reg mosi_pin;
  reg fault_pin;
  wire[3:0] leds;
  reg[7:0] result;

  spiMemory dut(.clk(clk),
                .sclk_pin(sclk_pin),
                .cs_pin(cs_pin),
                .miso_pin(miso_pin),
                .mosi_pin(mosi_pin),
                .fault_pin(fault_pin),
                .leds(leds));

  initial begin
    sclk_pin=0;
    clk=0;
    cs_pin=1;
    fault_pin=0;
  end

  always #15 sclk_pin=!sclk_pin;
  always #1 clk=!clk;

  initial begin
    $dumpfile("spi.vcd");
    $dumpvars(0,dut);

    // test: load data 1 at address 0
    // miso pin should be empty
    $display("Test 1");
    $display("Load 00000001 into 0000000");
    cs_pin=0;
    mosi_pin=0; #30 #30 #30 #30 #30 #30 #30
    mosi_pin=0; #30
    mosi_pin=0; #30 #30 #30 #30 #30 #30 #30
    mosi_pin=1; #30
    cs_pin=1; #30

    // test: read data that we just loaded
    // should display 1 as least significant bit
    $display("Read from 0000000, expects 00000001");
    cs_pin=0;
    mosi_pin=0; #30 #30 #30 #30 #30 #30 #30
    mosi_pin=1; #30
    mosi_pin=0; #15
    result[7] = miso_pin; #30
    result[6] = miso_pin; #30
    result[5] = miso_pin; #30
    result[4] = miso_pin; #30
    result[3] = miso_pin; #30
    result[2] = miso_pin; #30
    result[1] = miso_pin; #30
    result[0] = miso_pin; #30
    $display("Result: %b", result); #15
    cs_pin=1; #30

    // test: load data 1 at address 1111
    // miso pin should be empty
    $display("Test 2");
    $display("Load 00001111 into 0000111");
    cs_pin=0;
    mosi_pin=0; #30 #30 #30 #30
    mosi_pin=1; #30 #30 #30
    mosi_pin=0; #30
    mosi_pin=1; #30 #30 #30 #30
    mosi_pin=0; #30 #30 #30 #30
    cs_pin=1; #30

    // test: read data that just loaded
    // should display 1s as all bits
    $display("Read from 0000111, expects 00001111");
    cs_pin=0;
    mosi_pin=0; #30 #30 #30 #30
    mosi_pin=1; #30 #30 #30
    mosi_pin=1; #30
    mosi_pin=0; #15
    result[7] = miso_pin; #30
    result[6] = miso_pin; #30
    result[5] = miso_pin; #30
    result[4] = miso_pin; #30
    result[3] = miso_pin; #30
    result[2] = miso_pin; #30
    result[1] = miso_pin; #30
    result[0] = miso_pin; #30
    $display("Result: %b", result); #15
    cs_pin=1; #30

    // test: read data that we loaded in first test
    // should display 1 as least significant bit
    $display("Test 3");
    $display("Read from 0000000, expects 00000001 (first load)");
    cs_pin=0;
    mosi_pin=0; #30 #30 #30 #30 #30 #30 #30
    mosi_pin=1; #30
    mosi_pin=0; #15
    result[7] = miso_pin; #30
    result[6] = miso_pin; #30
    result[5] = miso_pin; #30
    result[4] = miso_pin; #30
    result[3] = miso_pin; #30
    result[2] = miso_pin; #30
    result[1] = miso_pin; #30
    result[0] = miso_pin; #30
    $display("Result: %b", result); #15
    cs_pin=1; #30

    // test: faulty
    // miso pin should be empty
    $display("Test 4");
    $display("Load 11111111 into 1111000, but the spi is faulty!");
    cs_pin=0;
    mosi_pin=1; #30 #30 #30 #30
    mosi_pin=0; #30 #30 #30
    mosi_pin=0; #30
    fault_pin=1;
    mosi_pin=1; #30 #30 #30 #30 #30 #30 #30
    mosi_pin=1; #30
    fault_pin=0;
    cs_pin=1; #30

    // test: read faulty data
    // should display 0
    $display("Read data from 1111000, which we loaded as 11111111, but is faulty! Therefore, should be 00000000");
    cs_pin=0;
    mosi_pin=1; #30 #30 #30 #30
    mosi_pin=0; #30 #30 #30
    mosi_pin=1; #30
    mosi_pin=0; #15
    result[7] = miso_pin; #30
    result[6] = miso_pin; #30
    result[5] = miso_pin; #30
    result[4] = miso_pin; #30
    result[3] = miso_pin; #30
    result[2] = miso_pin; #30
    result[1] = miso_pin; #30
    result[0] = miso_pin; #30
    $display("Result: %b", result); #15

    $finish;
  end

endmodule
