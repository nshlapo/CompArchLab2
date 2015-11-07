module midpoint(
    input button0,
    input switch0,
    input switch1,
    input Clk
    output[7:0] parOut,
    );

    wire conditioned0, positiveedge0, negativeedge0;
    wire conditioned1, positiveedge1, negativeedge1;
    wire conditioned2, positiveedge2, negativeedge2;
    wire serialDataOut;


    inputconditioner incond0 (Clk, button0, conditioned0, positiveedge0, negativeedge0);
    inputconditioner incond1 (Clk, switch0, conditioned1, positiveedge1, negativeedge1);
    inputconditioner incond2 (Clk, switch1, conditioned2, positiveedge2, negativeedge2);

    shiftregister shreg (Clk, positiveedge2, negativeedge0, 8'hA5, conditioned1, parOut, serialDataOut);

endmodule

