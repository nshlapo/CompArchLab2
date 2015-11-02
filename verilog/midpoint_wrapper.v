`timescale 1ns / 1ps

// JK flip-flop
module jkff1
(
    input trigger,
    input j,
    input k,
    output reg q
);
    always @(posedge trigger) begin
        if(j && ~k) begin
            q <= 1'b1;
        end
        else if(k && ~j) begin
            q <= 1'b0;
        end
        else if(k && j) begin
            q <= ~q;
        end
    end
endmodule

// Two-input MUX with parameterized bit width (default: 1-bit)
module mux2 #( parameter W = 1 )
(
    input[W-1:0]    in0,
    input[W-1:0]    in1,
    input           sel,
    output[W-1:0]   out
);
    // Conditional operator - http://www.verilog.renerta.com/source/vrg00010.htm
    assign out = (sel) ? in1 : in0;
endmodule


//--------------------------------------------------------------------------------
// Main Lab 0 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   4-bit operands to be stored, and two results to be alternately displayed
//   to the LEDs.
//
//   You must write the FullAdder4bit (in your adder.v) to complete this module.
//   Challenge: write your own interface module instead of using this one.
//--------------------------------------------------------------------------------

module midpoint_wrapper
(
    input        clk,
    input  [1:0] sw,
    input  [2:0] btn,
    output [3:0] led
);

    wire[3:0] res0, res1;     // Output display options
    wire [7:0] parOut;
    wire res_sel;             // Select between display options

    // // Capture button input to switch which MUX input to LEDs
    // jkff1 src_sel(.trigger(clk), .j(btn[2]), .k(btn[1]), .q(res_sel));
    // mux2 #(4) output_select(.in0(res0), .in1(res1), .sel(res_sel), .out(led));

    midpoint spi (.parOut(parOut), .button0(btn[0]), .switch0(sw[0]), .switch1(sw[1]), .Clk(clk));

    assign led = parOut[3:0];
    // assign res1 = parOut[7:4];

endmodule

