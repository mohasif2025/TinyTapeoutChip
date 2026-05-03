/* Gate module, input is only wired to output if enable is */

module enable_gate(
    input   input_i,
    input   enable_i,
    output  output_o
    );

    assign output_o = enable_i ? input_i : 0;

endmodule
