module xor_gate(
    input a_i,
    input b_i,
    output reg result_o
);

    // using built in operator:
    // assign result_o = a_i ^ b_i;
    always @(*) begin : xor_logic
        if ((a_i == 1'b0 && b_i == 1'b0) || (a_i == 1'b1 && b_i == 1'b1))
            result_o = 1'b0;
        else
            result_o = 1'b1;
    end

endmodule
