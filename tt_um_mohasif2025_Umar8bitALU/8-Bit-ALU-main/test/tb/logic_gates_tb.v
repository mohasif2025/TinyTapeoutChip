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

`timescale 1ns/1ns

module logic_gates_tb;

    // input signals
    reg a_i, b_i, f1_i;
    // output signals
    wire enable_gate_o;
    wire inverter_gate_o;
    wire and_gate_o;
    wire or_gate_o;
    wire xor_gate_o;

    enable_gate dut_enable_gate(
        .input_i(a_i),
        .enable_i(f1_i),
        .output_o(enable_gate_o)
    );

    inverter_gate dut_inverter_gate(
        .input_i(a_i),
        .invert_i(f1_i),
        .output_o(inverter_gate_o)
    );

    and_gate dut_and_gate(
        .a_i(a_i),
        .b_i(b_i),
        .result_o(and_gate_o)
    );

    or_gate dut_or_gate(
        .a_i(a_i),
        .b_i(b_i),
        .result_o(or_gate_o)
    );

    xor_gate dut_xor_gate(
        .a_i(a_i),
        .b_i(b_i),
        .result_o(xor_gate_o)
    );

    initial begin 
        $dumpfile("tb/logic_gates_tb.vcd");
        $dumpvars(0, logic_gates_tb);
        #1;

        a_i = 1'b0;
        b_i = 1'b0;

        /* Test enable gate and inverter */

        f1_i = 1'b0;
        /*
        input: a_i = 0, f1_i = 0
        results:
            enable_gate_o = 0
            inverter_gate_o = 0
        */
        #10; // wait 10 time units

        f1_i = 1'b1;
        /*
        input: a_i = 0, f1_i = 1
        results:
            enable_gate_o = 0
            inverter_gate_o = 1
        */
        #10; // wait 10 time units

        f1_i = 1'b0;
        a_i = 1'b1;
        /*
        input: a_i = 1, f1_i = 0
        results:
            enable_gate_o = 0
            inverter_gate_o = 1
        */
        #10; // wait 10 time units

        f1_i = 1'b1;
        /*
        input: a_i = 1, f1_i = 1
        results:
            enable_gate_o = 1
            inverter_gate_o = 0
        */
        #10; // wait 10 time units

        /* Test logic gates */

        /*
        input: a_i = 0, b_i = 0
        results:
            and_gate = 0
            or_gate = 0
            xor_gate = 0
        */
        a_i = 1'b0; b_i = 1'b0;
        #10; // wait 10 time units

        /*
        input: a_i = 1, b_i = 0
        results:
            and_gate = 0
            or_gate = 1
            xor_gate = 1
        */
        a_i = 1'b1; b_i = 1'b0;
        #10; // wait 10 time units

         /*
        input: a_i = 0, b_i = 1
        results:
            and_gate = 0
            or_gate = 1
            xor_gate = 1
        */
        a_i = 1'b0; b_i = 1'b1;
        #10; // wait 10 time units

        /*
        input: a_i = 1, b_i = 1
        results:
            and_gate = 1
            or_gate = 1
            xor_gate = 0
        */
        a_i = 1'b1; b_i = 1'b1;
        #10; // wait 10 time units

    end

endmodule
