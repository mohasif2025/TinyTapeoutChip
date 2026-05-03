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
`timescale 1ns / 1ps

module top_level_alu_control_tb;

    localparam READ_A = 2'b00;
    localparam READ_B = 2'b01;
    localparam CALC = 2'b10;
    localparam STATUS = 2'b11;

    reg clk;
    reg reset;

    reg [`DATA_WIDTH-1:0] tb_alu_data_i, tb_alu_control_i = 8'd0;
    wire [`DATA_WIDTH-1:0] tb_alu_output;

    top_level_alu_control dut_top_level_alu_control(
        .alu_in(tb_alu_data_i),
        .ctrl_in(tb_alu_control_i),
        .alu_out(tb_alu_output),
        .clk(clk),
        .rst_n(reset)
    );

    initial begin
        $dumpfile("tb/top_level_alu_control_tb.vcd");
        $dumpvars(0, top_level_alu_control_tb);

        clk = 0;
        forever #10 clk = ~clk;   // Toggle every 10 ns
    end

    initial begin
        reset = 1'b1;
        #100;        // hold reset for 100 ns
        reset = 1'b0;  // release reset
    end

    initial begin
        // Wait for reset to deassert
        @(negedge reset);

        test_subtraction();

        // Wait some time to observe results
        #100;

        $finish;
    end

    task test_output_a_not_a;
        begin

            // Wait a few clock cycles
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = READ_A;
            tb_alu_data_i = 8'b11110000;
            tb_alu_control_i[7:3] = `OUTPUT_A;
            repeat (5) @(posedge clk);

            tb_alu_control_i[1:0] = CALC;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = STATUS;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = CALC;
            repeat (5) @(posedge clk);

            tb_alu_control_i[7:3] = `OUTPUT_NOT_A;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = STATUS;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = CALC;
            repeat (5) @(posedge clk);

        end
    endtask

    task test_A_AND_B;
        begin
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = READ_A;
            tb_alu_data_i = 8'b11111111;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = READ_B;
            repeat (5) @(posedge clk);
            tb_alu_data_i = 8'b10000001;
            repeat (5) @(posedge clk);
            tb_alu_control_i[7:3] = `OUTPUT_A_AND_B;
            tb_alu_control_i[1:0] = CALC;
            repeat (5) @(posedge clk);
            tb_alu_control_i[7:3] = `OUTPUT_A_OR_B;
            repeat (5) @(posedge clk);
            tb_alu_control_i[7:3] = `OUTPUT_A_XOR_B;
            repeat (5) @(posedge clk);
        end
    endtask

    task test_addition;
        begin
            repeat (5) @(posedge clk);
            // 4 + 6 = 10
            tb_alu_control_i[7:3] = `OUTPUT_A_PLUS_B;
            tb_alu_control_i[1:0] = READ_A;
            tb_alu_data_i = 8'd4;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = READ_B;
            repeat (5) @(posedge clk);
            tb_alu_data_i = 8'd6;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = CALC;
            repeat (5) @(posedge clk);
        end
    endtask

    task test_subtraction;
        begin
            repeat (5) @(posedge clk);
            // 10 - 5 = 5
            tb_alu_control_i[7:3] = `OUTPUT_A_MINUS_B;
            tb_alu_control_i[1:0] = READ_A;
            tb_alu_data_i = 8'd10;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = READ_B;
            repeat (5) @(posedge clk);
            tb_alu_data_i = 8'd5;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = CALC;
            repeat (5) @(posedge clk);

            // 5 - 10 = -5
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = READ_A;
            tb_alu_data_i = 8'd5;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = READ_B;
            repeat (5) @(posedge clk);
            tb_alu_data_i = 8'd10;
            repeat (5) @(posedge clk);
            tb_alu_control_i[1:0] = CALC;
            repeat (5) @(posedge clk);

        end
    endtask

endmodule