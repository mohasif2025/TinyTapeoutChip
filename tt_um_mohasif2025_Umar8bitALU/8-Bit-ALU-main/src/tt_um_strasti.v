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

`default_nettype none

module tt_um_strasti (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // alu instance
  top_level_alu_control top_level_alu_control_inst(
    .alu_in(ui_in),
    .ctrl_in(uio_in),
    .alu_out(uo_out),
    .clk(clk),
    .rst_n(rst_n)
  );

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  // Using IOs as input only
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

endmodule
