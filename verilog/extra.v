// Latch to store the address passed by the shift register
module addressLatch (
    input C,
    input CE,
    input[7:0] D,
    output reg[7:0] Q);

    always @(posedge C) begin
        if (CE == 1)
            Q <= D;
    end
endmodule

// D Flip Flop to store the output of shift register serial out
module DFF (
    input C,
    input CE,
    input D,
    output reg Q);

    always @(posedge C) begin
        if (CE == 1)
            Q <= D;
    end
endmodule

// Tri-state buffer to output dff to miso pin
module triBuff (
    input q,
    input buff,
    output pin);

    // If buff high, q, else z
    assign pin = (buff) ? q : 1'bz;
endmodule