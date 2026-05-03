
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

module top_level_alu_control(
    input  wire [7:0] alu_in,    // ALU data input
    input  wire [7:0] ctrl_in,   // ALU operation control
    output wire [7:0] alu_out,   // ALU controlled output (result or status)
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // register for input and result
    reg [`DATA_WIDTH-1:0] a_i;
    reg [`DATA_WIDTH-1:0] b_i;
    reg [`DATA_WIDTH-1:0] alu_output_reg;
    
    reg [1:0] state, next_state, prev_state;
    localparam READ_A = 2'b00;
    localparam READ_B = 2'b01;
    localparam CALC = 2'b10;
    localparam STATUS = 2'b11;

    // alu output wires
    wire [`DATA_WIDTH-1:0] alu_result;
    wire alu_borrow_out;
    wire [1:0] alu_status_flag;

    eight_bit_alu eight_bit_alu_inst(
        .a8_i(a_i),
        .b8_i(b_i),
        .f8_i(ctrl_in[7:3]),
        .carry_borrow_i(ctrl_in[2]),
        .y8_o(alu_result),
        .carry_borrow_o(alu_borrow_out),
        .status_flag_o(alu_status_flag)
    );

    always @(posedge clk) begin
        if (rst_n) begin
            state <= READ_A;
            a_i <= 8'd0;
            b_i <= 8'd0;
            alu_output_reg <= 8'd0;
        end else begin
            // set state
            prev_state <= state;
            state <= next_state;

            // clear reg when state changes
            if (state !== prev_state) begin
                alu_output_reg <= 8'd0;
            end

            case(state)
            READ_A : begin
                a_i <= alu_in;
            end
            READ_B : begin
                b_i <= alu_in;
            end
            CALC : begin
                alu_output_reg <= alu_result;
            end
            STATUS : begin
                alu_output_reg[1:0] <= alu_status_flag;
                alu_output_reg[2] <= alu_borrow_out;
            end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case(ctrl_in[1:0])
        READ_A : begin
            next_state = READ_A;
        end
        READ_B : begin
            next_state = READ_B;
        end
        CALC : begin
            next_state = CALC;
        end
        STATUS : begin
            next_state = STATUS;
        end
        endcase
    end

    assign alu_out = alu_output_reg;

endmodule