`include "defines.v"
`timescale 1ns / 1ps

module ALU_SLICE
 #(parameter DLY = 5)
  (input [2:0] Ctrl,
   input A, B, Cin,
   output reg R, Cout);

  wire xB;
  wire AxB;
  wire Sum;
  wire _A;
  wire _AxBC;
  wire _AB;
  wire AB;
  wire _AoB;
  wire AoB;

  // Decode control to detect SUB and SLT
  wire [2:0] _Ctrl;
  wire _isSub;
  wire isSub;
  generate genvar i;
    for (i=0;i<3;i=i+1) begin
      not #DLY not_inst(_Ctrl[i],Ctrl[i]);
    end
  endgenerate
  nand #DLY isSub_nand(_isSub,_Ctrl[2],Ctrl[0]);
  not #DLY isSub_not(isSub,_isSub);

  // XOR and Sum
  xor #DLY sub_xor(xB,B,isSub);
  xor #DLY ab_xor(AxB,A,xB);
  xor #DLY sum_xor(Sum,AxB,Cin);

  // Carry Out
  nand #DLY axbc_nand(_AxBC,AxB,Cin);
  nand #DLY ab_nand(_AB,A,xB);
  nand #DLY cout_nand(Cout,_AB,_AxBC);

  // AND
  not #DLY ab_not(AB,_AB);

  // NOR and OR
  nor #DLY ab_nor(_AoB,A,B);
  not #DLY aob_not(AoB,_AoB);

  // Not
  not #DLY a_not(_A,A);

  // MUX
  always @* begin
    case (Ctrl)
      `ADD_:  begin R = Sum;  end
      `SUB_:  begin R = Sum;  end 
      `XOR_:  begin R = AxB;  end 
      `SLT_:  begin R = Sum;  end
      `AND_:  begin R = AB;   end
      `NAND_: begin R = _AB;  end
      `NOR_:  begin R = _AoB; end
      `OR_:   begin R = AoB;  end
      default: /* default catch */;
    endcase
  end

endmodule
