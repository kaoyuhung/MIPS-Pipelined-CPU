module branch_handle_unit(
    beq,
    bne,
    bge,
    bgt,
    Rsdata,
    Rtdata,
    branch
  );

  input beq;
  input bne;
  input bge;
  input bgt;
  input [31:0] Rsdata;
  input [31:0] Rtdata;
  output branch;

  assign branch = (beq & (Rsdata==Rtdata)) | (bne & (Rsdata!=Rtdata)) | (bge & (Rsdata>=Rtdata)) | (bgt & (Rsdata>Rtdata));
endmodule
