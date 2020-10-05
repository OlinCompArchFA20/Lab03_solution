`include "defines.v"
`timescale 1ns / 1ps

module test_alu_slice;

  reg [2:0] Ctrl;
  reg       A;
  reg       B;
  reg       Cin;
  wire      R;
  wire      Cout;

  ALU_SLICE DUT(Ctrl,A,B,Cin,R,Cout);

  initial begin
    // Hooks for vvp/gtkwave
    // the *.vcd filename should match the *.v filename for Makefile cleanliness
    $dumpfile("test_alu_slice.vcd");
    $dumpvars(0,test_alu_slice);

    $display("      A B Cin | R Cout");
    for (int i = 0; i < 2**6; i=i+1) begin
      {Ctrl,A,B,Cin} = i[5:0];
      #50
      case (Ctrl)
        `ADD_:  begin $display("ADD:  %d %d %d   | %d %d",A,B,Cin,R,Cout); end
        `SUB_:  begin $display("SUB:  %d %d %d   | %d %d",A,B,Cin,R,Cout); end 
        `XOR_:  begin $display("XOR:  %d %d %d   | %d %d",A,B,Cin,R,Cout); end 
        `SLT_:  begin $display("SLT:  %d %d %d   | %d %d",A,B,Cin,R,Cout); end
        `AND_:  begin $display("AND:  %d %d %d   | %d %d",A,B,Cin,R,Cout); end
        `NAND_: begin $display("NAND: %d %d %d   | %d %d",A,B,Cin,R,Cout); end
        `NOR_:  begin $display("NOR:  %d %d %d   | %d %d",A,B,Cin,R,Cout); end
        `OR_:   begin $display("OR:   %d %d %d   | %d %d",A,B,Cin,R,Cout); end
        default: /* default catch */;
      endcase
    end
  end

endmodule
