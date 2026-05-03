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

module eight_bit_alu_tb;

    // input signals
    reg [`DATA_WIDTH-1:0] tb_a8_i, tb_b8_i;
    // carry/borrow signal
    reg tb_carry_borrow_i;
    // control signal
    reg [`CONTROL_WIDTH-1:0] tb_f8_i;
    // output
    wire [`DATA_WIDTH-1:0] tb_y8_o;
    wire tb_carry_borrow_o;
    wire [1:0] tb_status_flag_o;

    eight_bit_alu dut_eight_bit_alu(
        .a8_i(tb_a8_i),
        .b8_i(tb_b8_i),
        .f8_i(tb_f8_i),
        .carry_borrow_i(tb_carry_borrow_i),
        .y8_o(tb_y8_o),
        .carry_borrow_o(tb_carry_borrow_o),
        .status_flag_o(tb_status_flag_o)
    );

    initial begin 
    $dumpfile("tb/eight_bit_alu_tb.vcd");
    $dumpvars(0, eight_bit_alu_tb);
    #1;

    // call tests
    test_subtraction();

    end

    /* using taks for testing*/
    task run_test;
        input [`CONTROL_WIDTH-1:0] func;
        input [`DATA_WIDTH-1:0] a;
        input [`DATA_WIDTH-1:0] b;
        input [`DATA_WIDTH-1:0] value;
        begin
            tb_f8_i = func;
            tb_a8_i = a;
            tb_b8_i = b;
            #10; // wait 10 time units

            if (tb_y8_o !== value)
                $display("FAILED: f=%b A=%d B=%d → got=%d expected=%d",
                         func, a, b, tb_y8_o, value);
            else
                $display("PASSED: f=%b A=%d B=%d → result=%d",
                         func, a, b, tb_y8_o);
        end
    endtask

    task run_test_with_status;
        input [`CONTROL_WIDTH-1:0] func;
        input [`DATA_WIDTH-1:0] a;
        input [`DATA_WIDTH-1:0] b;
        input [`DATA_WIDTH-1:0] expected_value;
        input expected_carry_borrow_out;
        input [1:0] expected_status_flag_value;
        begin
            tb_f8_i = func;
            tb_a8_i = a;
            tb_b8_i = b;
            // set carry/borrow into ALU to 0
            tb_carry_borrow_i = 0;
            #10; // wait 10 time units

            if (tb_y8_o !== expected_value)
                $display("FAILED: f=%b A=%d B=%d → got=%d expected=%d",
                         func, a, b, tb_y8_o, expected_value);
            else if (tb_carry_borrow_o !== expected_carry_borrow_out)
                $display("FAILED: f=%b A=%d B=%d → got carry/borrow out=%d expected carry/borrow out=%d",
                         func, a, b, tb_carry_borrow_o, expected_carry_borrow_out);
            else if (tb_status_flag_o !== expected_status_flag_value)
                $display("FAILED: f=%b A=%d B=%d → got status=%d expected status=%d",
                         func, a, b, tb_status_flag_o, expected_status_flag_value);
            else
                $display("PASSED: f=%b A=%d B=%d → result=%b",
                         func, a, b, tb_y8_o);
        end
    endtask

    task test_output_a_not_a;
        begin
            run_test(`ALL_ZERO, 8'd255, 8'd255, 8'd0);
            run_test(`OUTPUT_A, 8'd255, 8'd0, 8'd255);
            run_test(`OUTPUT_A, 8'd100, 8'd255, 8'd100);
            run_test(`OUTPUT_A, 8'd0, 8'd255, 8'd0);
            run_test(`OUTPUT_NOT_A, 8'b11111111, 8'd0, 8'b00000000);
            run_test(`OUTPUT_NOT_A, 8'b00000000, 8'd0, 8'b11111111);
            run_test(`OUTPUT_NOT_A, 8'b10101010, 8'd0, 8'b01010101);
        end
    endtask

    task test_and_or_xor;
        begin
            // AND
            run_test(`OUTPUT_A_AND_B, 8'b11111111, 8'b00000000, 8'b00000000);
            run_test(`OUTPUT_A_AND_B, 8'b00000000, 8'b11111111, 8'b00000000);
            run_test(`OUTPUT_A_AND_B, 8'b10101010, 8'b01010101, 8'b00000000);
            run_test(`OUTPUT_A_AND_B, 8'b11111111, 8'b10010001, 8'b10010001);
            run_test(`OUTPUT_A_AND_B, 8'b01000010, 8'b11111111, 8'b01000010);
            run_test(`OUTPUT_A_AND_B, 8'b11111111, 8'b11111111, 8'b11111111);
            // OR
            run_test(`OUTPUT_A_OR_B, 8'b00000000, 8'b00000000, 8'b00000000);
            run_test(`OUTPUT_A_OR_B, 8'b11111111, 8'b00000000, 8'b11111111);
            run_test(`OUTPUT_A_OR_B, 8'b00000000, 8'b11111111, 8'b11111111);
            run_test(`OUTPUT_A_OR_B, 8'b00000000, 8'b11111111, 8'b11111111);
            run_test(`OUTPUT_A_OR_B, 8'b11110000, 8'b00001111, 8'b11111111);
            run_test(`OUTPUT_A_OR_B, 8'b10101010, 8'b01010101, 8'b11111111);
            // XOR
            run_test(`OUTPUT_A_XOR_B, 8'b00000000, 8'b00000000, 8'b00000000);
            run_test(`OUTPUT_A_XOR_B, 8'b11111111, 8'b11111111, 8'b00000000);
            run_test(`OUTPUT_A_XOR_B, 8'b10101010, 8'b10101010, 8'b00000000);
            run_test(`OUTPUT_A_XOR_B, 8'b11110000, 8'b00001111, 8'b11111111);
            run_test(`OUTPUT_A_XOR_B, 8'b10101010, 8'b01010101, 8'b11111111);
            run_test(`OUTPUT_A_XOR_B, 8'b01000010, 8'b10010001, 8'b11010011);
        end
    endtask

    task test_addition;
        begin
            // A + B
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd0, 8'd0, 8'd0, `NO_OVERFLOW, `ZERO_FLAG);
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd100, 8'd0, 8'd100, `NO_OVERFLOW, `DEFAULT_FLAG);
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd0, 8'd100, 8'd100, `NO_OVERFLOW, `DEFAULT_FLAG);
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd50, 8'd50, 8'd100, `NO_OVERFLOW, `DEFAULT_FLAG);
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd33, 8'd66, 8'd99, `NO_OVERFLOW, `DEFAULT_FLAG);
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd255, 8'd0, 8'd255, `NO_OVERFLOW, `DEFAULT_FLAG);
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd0, 8'd255, 8'd255, `NO_OVERFLOW, `DEFAULT_FLAG);
            // results in overflow (1)00000000
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd255, 8'd1, 8'd0, `OVERFLOW, `OVERFLOW_FLAG);
            // results in overflow (1)01011110
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd200, 8'd150, 8'b01011110, `OVERFLOW, `OVERFLOW_FLAG);
            // results in overflow (1)11111110
            run_test_with_status(`OUTPUT_A_PLUS_B, 8'd255, 8'd255, 8'b11111110, `OVERFLOW, `OVERFLOW_FLAG);
        end
    endtask

    task test_subtraction;
        begin
            // 0 - 0 = 0
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd0, 8'd0, 8'd0, `NO_BOROROW, `ZERO_FLAG);
            // 1 - 0 = 1
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd1, 8'd0, 8'd1, `NO_BOROROW, `DEFAULT_FLAG);
            // 1 - 1 = 0
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd1, 8'd1, 8'd0, `NO_BOROROW, `ZERO_FLAG);

            // 0 - 1 = -1, should result in (1)11111111 (borrow and two's compliment -1)
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd0, 8'd1, 8'b11111111, `BORROW, `NEGATIVE_FLAG);

            // 10 - 5 = 5, should result in (0)00000101 (no borrow and unsigned binary 5)
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd10, 8'd5, 8'b00000101, `NO_BOROROW, `DEFAULT_FLAG);

            // 5 - 10 = -5, should result in (1)11111011 (borrow and two's compliment -5)
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd5, 8'd10, 8'b11111011, `BORROW, `NEGATIVE_FLAG);

            // 100 - 50 = 50, should result in (0)00110010 (no borrow and unsigned binary 50)
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd100, 8'd50, 8'd50, `NO_BOROROW, `DEFAULT_FLAG);

            // 255 - 255 = 0
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd255, 8'd255, 8'd0, `NO_BOROROW, `ZERO_FLAG);

            // 50 - 100 = -50, should result in (1)11001110 (borrow and two's compliment -50)
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd50, 8'd100, 8'b11001110, `BORROW, `NEGATIVE_FLAG);

            // 50 - 255 = -205, should result in (1)00110011 (borrow and two's compliment -205)
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd50, 8'd255, 8'b00110011, `BORROW, `NEGATIVE_FLAG);

            // 0 - 255 = -255, should result in (1)00000001 (borrow and two's compliment -255)
            run_test_with_status(`OUTPUT_A_MINUS_B, 8'd0, 8'd255, 8'b00000001, `BORROW, `NEGATIVE_FLAG);
        end 
    endtask

endmodule
