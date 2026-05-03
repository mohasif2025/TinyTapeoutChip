module or_gate(
    input a_i,
    input b_i,
    output reg result_o
);

    // using built in operator:
    // assign result_o = a_i || b_i;
    always @(*) begin : or_logic
        if (a_i == 1'b1 || b_i == 1'b1)
            result_o = 1'b1;
        else
            result_o = 1'b0;
    end

endmodule
