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

module full_subtractor(
    input a_i,
    input b_i,
    input borrow_in_i,
    output borrow_out_o,
    output diff_o
);

    wire a_b_xor_o, nota_b_and_o, bout_and_o;

    // A xor B
    xor_gate first_xor (.a_i(a_i), .b_i(b_i), .result_o(a_b_xor_o));

    // not A and B
    and_gate first_and (.a_i(~a_i), .b_i(b_i), .result_o(nota_b_and_o));

    // Borrow and
    and_gate bout_and (.a_i(~a_b_xor_o), .b_i(borrow_in_i), .result_o(bout_and_o));

    // Borrow out
    or_gate bout_out_or (.a_i(bout_and_o), .b_i(nota_b_and_o), .result_o(borrow_out_o));

    // Difference out
    xor_gate difference_out_xor (.a_i(borrow_in_i), .b_i(a_b_xor_o), .result_o(diff_o));

endmodule
