`ifndef CONSTANTS_VH
`define CONSTANTS_VH

// ALU operation codes
`define ALL_ZERO            5'b00000
`define OUTPUT_A            5'b00001
`define OUTPUT_NOT_A        5'b10001
`define OUTPUT_A_AND_B      5'b01000
`define OUTPUT_A_OR_B       5'b01001
`define OUTPUT_A_XOR_B      5'b01010
`define OUTPUT_A_PLUS_B     5'b01011
`define OUTPUT_A_MINUS_B    5'b01100

// Bit width definitions
`define DATA_WIDTH 8
`define MUX_WIDTH 3
`define CONTROL_WIDTH 5

// ALU status flag
`define DEFAULT_FLAG 2'b00
`define ZERO_FLAG 2'b01
`define NEGATIVE_FLAG 2'b10
`define OVERFLOW_FLAG 2'b11

// ALU overflow flag
`define NO_OVERFLOW 1'b0
`define OVERFLOW 1'b1
`define NO_BOROROW 1'b0
`define BORROW  1'b1

`define CARRY_BORROW_OUT_BIT 7

`endif