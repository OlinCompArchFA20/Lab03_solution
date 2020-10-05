`include "defines.v"
`timescale 1ns / 1ps

module ALU
 #(parameter W = 4,
           DLY = 5)
  (input     [2:0] Ctrl,// Control word to select operation
   input      [W-1:0] A,// Input Operand
   input      [W-1:0] B,// Output Operand
   output reg [W-1:0] R,// Result 
   output reg      cout,// Was there a carry out? Unsigned overflow
   output reg      zero,// Result == 0
   output reg overflow);// Result overflowed

  wire [W:0] carry;
  wire [W:0] result;
  wire       slt;

  generate genvar i;
    for (i=0;i<W;i=i+1) begin
      ALU_SLICE #(.DLY(DLY)) slice_inst(Ctrl,A[i],B[i],carry[i],result[i],carry[i+1]);
    end
  endgenerate

  // Control subtraction with the LSB of ctrl
  assign carry[0] = Ctrl[0];

  // Output Flags
  // Unsigned Overflow (aka carry out)
  assign cout = carry[W];
  // Detect Signed Overflow
  xor #DLY (overflow,carry[W-1],carry[W]); 
  // Calculate SLT
  xor #DLY (slt,overflow,result[W-1]);
  
  // MUX
  always @* begin
    case (Ctrl)
      `SLT_:   R <= slt;
      default: R <= result;
    endcase
    zero = result == 0;
  end

endmodule
