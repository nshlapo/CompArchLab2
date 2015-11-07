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

module triBuff (
    input q,
    input buff,
    output pin);

    assign pin = (buff) ? q : 1'bz;
endmodule