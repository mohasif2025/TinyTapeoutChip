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

module multiplexer #(
        parameter AND_OUTPUT = 3'b000,
        parameter OR_OUTPUT = 3'b001,
        parameter XOR_OUTPUT = 3'b010,
        parameter ADDER_OUTPUT = 3'b011,
        parameter SUBTRACTOR_OUTPUT = 3'b100)
    (
    input and_r_i,
    input or_r_i,
    input xor_r_i,
    input adder_r_i,
    input subtractor_r_i,
    input [`MUX_WIDTH-1:0] f_i,
    // reg because i want to use always-block
    output reg result_o
);

    always @(*) begin : multiplexer
        case(f_i)
            AND_OUTPUT: begin
                result_o = and_r_i;
            end
            OR_OUTPUT: begin
                result_o = or_r_i;
            end
            XOR_OUTPUT: begin
                result_o = xor_r_i;
            end
            ADDER_OUTPUT: begin
                result_o = adder_r_i;
            end
            SUBTRACTOR_OUTPUT: begin
                result_o = subtractor_r_i;
            end
            default: begin
                result_o = and_r_i;
            end
        endcase
    end

endmodule
