module Forwarding_unit(
    ID_RegRs,
    ID_RegRt,
    EX_RegRs,
    EX_RegRt,
    MEM_RegWrite,
    MEM_RegRd,
    WB_RegWrite,
    WB_RegRd,
    FA,
    FB,
    FC,
    FD
  );
  input [5-1:0] ID_RegRs;
  input [5-1:0] ID_RegRt;
  input [5-1:0] EX_RegRs;
  input [5-1:0] EX_RegRt;
  input [5-1:0] MEM_RegRd;
  input [5-1:0] WB_RegRd;
  input MEM_RegWrite;
  input WB_RegWrite;

  output [2-1:0] FA;
  output [2-1:0] FB;
  output [2-1:0] FC;
  output [2-1:0] FD;

  reg [2-1:0] FA;
  reg [2-1:0] FB;
  reg [2-1:0] FC;
  reg [2-1:0] FD;

  always @(*)
  begin
    if(MEM_RegWrite && MEM_RegRd!=0 && MEM_RegRd==EX_RegRs)
      FA <= 2'b01;
    else if(WB_RegWrite && WB_RegRd!=0 && WB_RegRd==EX_RegRs)
      FA <= 2'b10;
    else
      FA <= 2'b00;

    if(MEM_RegWrite && MEM_RegRd!=0 && MEM_RegRd==EX_RegRt)
      FB <= 2'b01;
    else if(WB_RegWrite && WB_RegRd!=0 && WB_RegRd==EX_RegRt)
      FB <= 2'b10;
    else
      FB <= 2'b00;

    if(MEM_RegWrite && MEM_RegRd!=0 && MEM_RegRd==ID_RegRs)
      FC<=2'b01;
    else if(WB_RegWrite  && WB_RegRd!=0 && WB_RegRd==ID_RegRs)
      FC<=2'b10;
    else
      FC<=2'b00;

    if(MEM_RegWrite && MEM_RegRd!=0 && MEM_RegRd==ID_RegRt)
      FD<=2'b01;
    else if(WB_RegWrite && WB_RegRd!=0 && WB_RegRd==ID_RegRt)
      FD<=2'b10;
    else
      FD<=2'b00;
  end
endmodule
