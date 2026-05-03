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

`include "../src/constants/constants.vh"
`timescale 1ns/1ns

module multiplexer_tb;

    localparam AND_OUTPUT = 3'b000;
    localparam OR_OUTPUT = 3'b001;
    localparam XOR_OUTPUT = 3'b010;
    localparam ADDER_OUTPUT = 3'b011;
    localparam SUBTRACTOR_OUTPUT = 3'b100;
    
    // input signals
    reg and_output_i, or_output_i, xor_output_i, adder_output_i, subtractor_output_i;
    // control signal
    reg [`MUX_WIDTH-1:0] f_i;
    // output
    wire multiplexer_o;

    multiplexer dut_multiplexer(
        .and_r_i(and_output_i),
        .or_r_i(or_output_i),
        .xor_r_i(xor_output_i),
        .adder_r_i(adder_output_i),
        .subtractor_r_i(subtractor_output_i),
        .f_i(f_i),
        .result_o(multiplexer_o)
    );

    initial begin 
        $dumpfile("tb/multiplexer_tb.vcd");
        $dumpvars(0, multiplexer_tb);
        #1;

        and_output_i = 1'b0; or_output_i = 1'b0; xor_output_i = 1'b0; adder_output_i = 1'b0; subtractor_output_i = 1'b0;

        f_i = AND_OUTPUT;
        #10; // wait 10 time units
        and_output_i = 1'b1;
        #10; // wait 10 time units

        f_i = OR_OUTPUT;
        #10; // wait 10 time units
        or_output_i = 1'b1;
        #10; // wait 10 time units

        f_i = XOR_OUTPUT;
        #10; // wait 10 time units
        xor_output_i = 1'b1;
        #10; // wait 10 time units

        f_i = ADDER_OUTPUT;
        #10; // wait 10 time units
        adder_output_i = 1'b1;
        #10; // wait 10 time units

        f_i = SUBTRACTOR_OUTPUT;
        #10; // wait 10 time units
        subtractor_output_i = 1'b1;
        #10; // wait 10 time units

    end
endmodule
