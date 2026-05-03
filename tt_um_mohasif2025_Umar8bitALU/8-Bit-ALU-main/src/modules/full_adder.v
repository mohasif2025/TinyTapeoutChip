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

module full_adder(
    input a_i,
    input b_i,
    input carry_in_i,
    output carry_out_o,
    output sum_o
);

    wire first_xor_o, second_xor_o, first_and_o, second_and_o;

    // A xor B
    xor_gate first_xor (.a_i(a_i), .b_i(b_i), .result_o(first_xor_o));

    // (A xor B) xor carry_in
    xor_gate second_xor (.a_i(first_xor_o), .b_i(carry_in_i), .result_o(second_xor_o));

    // sum
    // second_xor gives result for additon of A + B with carry in
    assign sum_o = second_xor_o;

    // (A xor B) and carry_in
    and_gate first_and (.a_i(carry_in_i), .b_i(first_xor_o), .result_o(first_and_o));

    // A and B
    and_gate second_and (.a_i(a_i), .b_i(b_i), .result_o(second_and_o));

    // carry out
    // (A and B) or (result and carry in)
    or_gate carry_out_or (.a_i(first_and_o), .b_i(second_and_o), .result_o(carry_out_o));

endmodule
