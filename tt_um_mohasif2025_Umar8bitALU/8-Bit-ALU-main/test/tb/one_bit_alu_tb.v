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

module one_bit_alu_tb;
    // input signals
    reg tb_a_i, tb_b_i, tb_carry_in_i, tb_borrow_in_i;
    // control signal
    reg [`CONTROL_WIDTH-1:0] tb_f_i;
    // output
    wire tb_result_o, tb_carry_out_o, tb_borrow_out_o;

    one_bit_alu dut_one_bit_alu(
        .a_i(tb_a_i),
        .b_i(tb_b_i),
        .carry_in_i(tb_carry_in_i),
        .borrow_in_i(tb_borrow_in_i),
        .f_i(tb_f_i),
        .result_o(tb_result_o),
        .carry_out_o(tb_carry_out_o),
        .borrow_out_o(tb_borrow_out_o)
    );

    initial begin 
    $dumpfile("tb/one_bit_alu_tb.vcd");
    $dumpvars(0, one_bit_alu_tb);
    #1;

    {tb_a_i, tb_b_i, tb_carry_in_i,tb_borrow_in_i} = 1'b0;
    tb_f_i = `ALL_ZERO;

    test_subtraction();

    end

    task run_test_logic;
        input [`CONTROL_WIDTH-1:0] func;
        input a;
        input b;
        input expected_result;
        begin
            tb_f_i = func;
            tb_a_i = a;
            tb_b_i = b;
            #10; // wait 10 time units
            if (tb_result_o !== expected_result) begin
                $display("FAILED: f=%b A=%b B=%b → got=%b expected=%d",
                         func, a, b, tb_result_o, expected_result);
            end else
                $display("PASSED: f=%b A=%d B=%d → result=%d",
                         func, a, b, tb_result_o);
        end
    endtask

    task run_test_algorithmic;
        input [`CONTROL_WIDTH-1:0] func;
        input a;
        input b;
        input carry_borrow_i;
        input expected_result;
        input expected_carry_borrow;
        begin
            tb_f_i = func;
            tb_a_i = a;
            tb_b_i = b;
            if (func == `OUTPUT_A_PLUS_B) begin
                tb_carry_in_i = carry_borrow_i;
            end else if (func == `OUTPUT_A_MINUS_B) begin
                tb_borrow_in_i = carry_borrow_i;
            end
            #10; // wait 10 time units

            if (tb_result_o !== expected_result) begin
                $display("FAILED: f=%b A=%b B=%b → got=%b expected=%d",
                         func, a, b, tb_result_o, expected_result);
            end else if (func == `OUTPUT_A_PLUS_B && tb_carry_out_o !== expected_carry_borrow) begin
                $display("FAILED: f=%b A=%b B=%b → got result=%b, carry_out=%b -> expected result=%b, carry_out=%b",
                         func, a, b, tb_result_o, tb_carry_out_o,expected_result,expected_carry_borrow);
            end else if (func == `OUTPUT_A_MINUS_B && tb_borrow_out_o !== expected_carry_borrow) begin
                 $display("FAILED: f=%b A=%b B=%b → got result=%b, borrow_out=%b -> expected result=%b, borrow_out=%b",
                         func, a, b, tb_result_o, tb_borrow_out_o,expected_result,expected_carry_borrow);
            end else
                $display("PASSED: f=%b A=%d B=%d → result=%d",
                         func, a, b, tb_result_o);
        end
    endtask

    task test_logic_operations;
        begin
            // --- ALL ZERO ---
            $display("\nTesting ALL ZERO...");
            run_test_logic(`ALL_ZERO,      0, 0, 0);
            run_test_logic(`ALL_ZERO,      1, 1, 0);

            // --- OUTPUT A ---
            $display("\nTesting OUTPUT A...");
            run_test_logic(`OUTPUT_A,      0, 0, 0);
            run_test_logic(`OUTPUT_A,      1, 0, 1);
            run_test_logic(`OUTPUT_A,      1, 1, 1);

            // --- OUTPUT NOT A ---
            $display("\nTesting OUTPUT NOT A...");
            run_test_logic(`OUTPUT_NOT_A,  0, 0, 1);
            run_test_logic(`OUTPUT_NOT_A,  1, 0, 0);

            // --- OUTPUT A AND B ---
            $display("\nTesting OUTPUT A AND B...");
            run_test_logic(`OUTPUT_A_AND_B, 0, 0, 0);
            run_test_logic(`OUTPUT_A_AND_B, 0, 1, 0);
            run_test_logic(`OUTPUT_A_AND_B, 1, 0, 0);
            run_test_logic(`OUTPUT_A_AND_B, 1, 1, 1);

            // --- OUTPUT A OR B ---
            $display("\nTesting OUTPUT A OR B...");
            run_test_logic(`OUTPUT_A_OR_B, 0, 0, 0);
            run_test_logic(`OUTPUT_A_OR_B, 0, 1, 1);
            run_test_logic(`OUTPUT_A_OR_B, 1, 0, 1);
            run_test_logic(`OUTPUT_A_OR_B, 1, 1, 1);

            // --- OUTPUT A XOR B ---
            $display("\nTesting OUTPUT A XOR B...");
            run_test_logic(`OUTPUT_A_XOR_B, 0, 0, 0);
            run_test_logic(`OUTPUT_A_XOR_B, 0, 1, 1);
            run_test_logic(`OUTPUT_A_XOR_B, 1, 0, 1);
            run_test_logic(`OUTPUT_A_XOR_B, 1, 1, 0);
        end
    endtask

    task test_addition;
        begin
            $display("\nTesting OUTPUT A + B...");
            run_test_algorithmic(`OUTPUT_A_PLUS_B, 0, 0, 0, 0, 0);
            run_test_algorithmic(`OUTPUT_A_PLUS_B, 0, 0, 1, 1, 0);
            run_test_algorithmic(`OUTPUT_A_PLUS_B, 0, 1, 0, 1, 0);
            run_test_algorithmic(`OUTPUT_A_PLUS_B, 0, 1, 1, 0, 1);
            run_test_algorithmic(`OUTPUT_A_PLUS_B, 1, 0, 0, 1, 0);
            run_test_algorithmic(`OUTPUT_A_PLUS_B, 1, 0, 1, 0, 1);
            run_test_algorithmic(`OUTPUT_A_PLUS_B, 1, 1, 0, 0, 1);
            run_test_algorithmic(`OUTPUT_A_PLUS_B, 1, 1, 1, 1, 1);
        end
    endtask

    task test_subtraction;
        begin
            $display("\nTesting OUTPUT A - B...");
            run_test_algorithmic(`OUTPUT_A_MINUS_B, 0, 0, 0, 0, 0);
            run_test_algorithmic(`OUTPUT_A_MINUS_B, 0, 0, 1, 1, 1);
            run_test_algorithmic(`OUTPUT_A_MINUS_B, 0, 1, 0, 1, 1);
            run_test_algorithmic(`OUTPUT_A_MINUS_B, 0, 1, 1, 0, 1);
            run_test_algorithmic(`OUTPUT_A_MINUS_B, 1, 0, 0, 1, 0);
            run_test_algorithmic(`OUTPUT_A_MINUS_B, 1, 0, 1, 0, 0);
            run_test_algorithmic(`OUTPUT_A_MINUS_B, 1, 1, 0, 0, 0);
            run_test_algorithmic(`OUTPUT_A_MINUS_B, 1, 1, 1, 1, 1);
        end
    endtask

endmodule
