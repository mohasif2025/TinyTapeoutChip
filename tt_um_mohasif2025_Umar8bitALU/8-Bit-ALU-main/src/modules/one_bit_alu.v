// Copyright 2026 Timon Strassern
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE−2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module one_bit_alu #(
        parameter F0 = 0,
        parameter F1 = 1,
        parameter F2 = 2,
        // enable gate
        parameter F3 = 3,
        // inverter gate
        parameter F4 = 4)
    (
    input a_i,
    input b_i,
    input carry_in_i,
    input borrow_in_i,
    input [`CONTROL_WIDTH-1:0] f_i,
    output result_o,
    output carry_out_o,
    output borrow_out_o
);

    wire inverter_a_o, enable_b_o, and_o, or_o, xor_o, adder_o, subtractor_o;

    // inputs: A, F4
    inverter_gate inverter_gate_inst (
        .input_i(a_i),
        .invert_i(f_i[F4]),
        .output_o(inverter_a_o)
    );

    // inputs: B, F3
    enable_gate enable_gate_inst (
        .input_i(b_i),
        .enable_i(f_i[F3]),
        .output_o(enable_b_o)
    );

    and_gate and_gate_inst (
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .result_o(and_o)
    );

    or_gate or_gate_inst(
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .result_o(or_o)
    );

    xor_gate xor_gate_inst(
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .result_o(xor_o)
    );

    full_adder full_adder_inst(
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .carry_in_i(carry_in_i),
        .carry_out_o(carry_out_o),
        .sum_o(adder_o)
    );

    full_subtractor full_subtractor_inst(
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .borrow_in_i(borrow_in_i),
        // TODO seperate wire for borrow_out with mux depending on sub or add
        .borrow_out_o(borrow_out_o),
        .diff_o(subtractor_o)
    );

    multiplexer multiplexer_inst(
        .and_r_i(and_o),
        .or_r_i(or_o),
        .xor_r_i(xor_o),
        .adder_r_i(adder_o),
        .subtractor_r_i(subtractor_o),
        // connect F0, F1 and F2
        .f_i(f_i[`MUX_WIDTH-1:0]),
        .result_o(result_o)
    );

endmodule
