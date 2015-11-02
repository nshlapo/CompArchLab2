module SPI(
    output[7:1] parOut,
    input button0,
    input switch0,
    input switch1,
    input Clk
    );

    wire conditioned0, positiveedge0, negativeedge0;
    wire conditioned1, positiveedge1, negativeedge1;
    wire conditioned2, positiveedge2, negativeedge2;
    wire serialDataOut;


    inputconditioner incond0 (conditioned0, positiveedge0, negativeedge0, Clk, button0);
    inputconditioner incond1 (conditioned1, positiveedge1, negativeedge1, Clk, switch0);
    inputconditioner incond2 (conditioned2, positiveedge2, negativeedge2, Clk, switch1);

    shiftregister shreg (parOut, serialDataOut, Clk, positiveedge2, negativeedge0, 8'hA5, conditioned1);

endmodule

