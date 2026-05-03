
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

module eight_bit_alu (
    input [`DATA_WIDTH-1:0] a8_i,
    input [`DATA_WIDTH-1:0] b8_i,
    input [`CONTROL_WIDTH-1:0] f8_i,
    input carry_borrow_i,
    output [`DATA_WIDTH-1:0] y8_o,
    output carry_borrow_o,
    output [1:0] status_flag_o
);

    wire [`DATA_WIDTH-1:0] carry_bits;
    wire [`DATA_WIDTH-1:0] borrow_bits;
    reg carry_borrow_out;
    reg [1:0] status_flag;
    // use generate block to connect 8 one_bit_alu's
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            one_bit_alu one_bit_alu_inst (
                .a_i(a8_i[i]),
                .b_i(b8_i[i]),
                .carry_in_i(i == 0 ? carry_borrow_i : carry_bits[i - 1]),
                .borrow_in_i(i == 0 ? carry_borrow_i : borrow_bits[i - 1]),
                .f_i(f8_i),
                .result_o(y8_o[i]),
                .carry_out_o(carry_bits[i]),
                .borrow_out_o(borrow_bits[i])
            );
        end
    endgenerate 

    // ALU status flags
    always @(*) begin
        
        // mux for carry or borrow out
        case(f8_i)
        `OUTPUT_A_PLUS_B : begin 
            carry_borrow_out = carry_bits[`CARRY_BORROW_OUT_BIT];
        end
        `OUTPUT_A_MINUS_B : begin
            carry_borrow_out = borrow_bits[`CARRY_BORROW_OUT_BIT];
        end
        default : begin
            carry_borrow_out = 0;
        end
        endcase

        // status output
        // default
        status_flag = `DEFAULT_FLAG;
        case(f8_i)
        `OUTPUT_A_PLUS_B : begin
            /* check for overflow and zero value */
            if (carry_borrow_out == 1) begin
                status_flag = `OVERFLOW_FLAG;
            end else if (y8_o == 8'd0) begin
                status_flag = `ZERO_FLAG;
            end
        end
        `OUTPUT_A_MINUS_B : begin
            if (carry_borrow_out == 1) begin
                /* if last borrow out bit is 1 the result is negativ */
                status_flag = `NEGATIVE_FLAG;
            end else if (y8_o == 8'd0) begin
                status_flag = `ZERO_FLAG;
            end
        end
        default : begin
            if (y8_o == 8'd0) begin
                status_flag = `ZERO_FLAG;
            end
        end
        endcase
    end

    // continious assignment of carry/borrow out and status flag
    assign carry_borrow_o = carry_borrow_out;
    assign status_flag_o = status_flag;

endmodule
