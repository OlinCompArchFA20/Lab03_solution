`timescale 1ns / 1ps

module OR
  #(parameter W = 2, DLY=5)
  (input  [W-1:0] in,
   output         out);

  wire [1:0] A;

  generate
    if (W == 2)
      assign A = in;
    else begin
      OR #(.W(W/2),.DLY(DLY)) instA(in[W/2-1:0],A[0]);
      OR #(.W(W/2),.DLY(DLY)) instB(in[W-1:W/2],A[1]);
    end
  endgenerate

  or #DLY (out,A[0],A[1]);


endmodule
