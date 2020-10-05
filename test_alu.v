`include "defines.v"
`timescale 1ns / 1ps

module test_alu;

  parameter W = 4;
  parameter DLY = 5;

  reg [2:0] Ctrl;
  reg [W-1:0] A;
  wire signed [W-1:0] sA;
  reg [W-1:0] B;
  wire signed [W-1:0] sB;
  wire [W-1:0]  R;
  wire signed [W-1:0] sR;
  wire cout;
  wire zero;
  wire overflow;

  reg pass;

  ALU #(.W(W), .DLY(DLY)) DUT(Ctrl,A,B,R,cout,zero,overflow);
  assign sR = R;
  assign sA = A;
  assign sB = B;

  initial begin
    // Hooks for vvp/gtkwave
    // the *.vcd filename should match the *.v filename for Makefile cleanliness
    $dumpfile("test_alu.vcd");
    $dumpvars(0,test_alu);

    for (int ctrl=0; ctrl<2**3; ctrl=ctrl+1) begin
      Ctrl = ctrl;
      pass = 1;
      for (int a=0;a<2**W;a=a+1) begin
        A = a;
        for (int b=0;b<2**W;b=b+1) begin
          B = b;
          #(100*W*DLY)
          case (Ctrl)
            `ADD_:  begin if ((sA+sB)!=sR) begin pass=0; $display ("ADD:\tFail   %b + %b  -> %b",A,B,R); end end
            `SUB_:  begin if ((sA-sB)!=sR) begin pass=0; $display ("SUB:\tFail   %b + %b  -> %b",sA,sB,sR); end end
            `XOR_:  begin if ((A^B)!=R)    begin pass=0; $display ("XOR:\tFail   %b ^ %b  -> %b",sA,sB,R); end end
            `SLT_:  begin if ((sA<sB)!=R)  begin pass=0; $display ("SLT:\tFail   %b < %b  -> %b ",sA,sB,R); end end
            `AND_:  begin if ((A&B)!=R)    begin pass=0; $display ("AND:\tFail   %b & %b  -> %b",A,B,R); end end
            `NAND_: begin if (~(A&B)!=R)   begin pass=0; $display("NAND:\tFail ~(%b & %b) -> %b",A,B,R); end end
            `OR_:   begin if ((A|B)!=R)    begin pass=0; $display  ("OR:\tFail   %b | %b  -> %b",A,B,R); end end
            `NOR_:  begin if (~(A|B)!=R)   begin pass=0; $display ("NOR:\tFail ~(%b & %b) -> %b",A,B,R); end end
            default: /* default catch */;
          endcase
        end 
      end
      if (pass == 1) begin
        case (Ctrl)
          `ADD_:  $display ("ADD:\tPass");
          `SUB_:  $display ("SUB:\tPass");
          `XOR_:  $display ("XOR:\tPass");
          `SLT_:  $display ("SLT:\tPass");
          `AND_:  $display ("AND:\tPass");
          `NAND_: $display("NAND:\tPass");
          `OR_:   $display  ("OR:\tPass");
          `NOR_:  $display ("NOR:\tPass");
          default: /* default catch */;
        endcase
      end
    end
  end

endmodule
