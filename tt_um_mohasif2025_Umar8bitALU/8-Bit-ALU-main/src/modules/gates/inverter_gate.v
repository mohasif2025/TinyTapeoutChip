/* Inverter module, inverts the signal if invert_i input is '1'. */

module inverter_gate(
    input   input_i,
    input   invert_i,
    output  output_o
    );

    // if invert_i = '1', a_i gets inverted
    assign output_o = invert_i ? ~input_i : input_i;

endmodule
