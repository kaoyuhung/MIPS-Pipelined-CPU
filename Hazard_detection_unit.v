module Hazard_detection_unit(
    EX_MemRead,
    EX_RegRt,
    EX_RegWrite,
    EX_branch_load_use,
    ID_RegRs,
    ID_RegRt,
    branch,
    branch_taken,
    IF_Flush,
    IF_ID_PipeRegWrite,
    ID_Flush,
    PC_Write,
    branch_load_use
  );
  input EX_MemRead;
  input EX_RegWrite;
  input [5-1:0] EX_RegRt;
  input [5-1:0] ID_RegRs;
  input [5-1:0] ID_RegRt;
  input branch_taken;
  input branch;
  input EX_branch_load_use;

  output IF_Flush;
  output ID_Flush;
  output PC_Write;
  output IF_ID_PipeRegWrite;
  output branch_load_use;

  reg IF_Flush;
  reg ID_Flush;
  reg PC_Write; // 控制 IF stage 的 stall
  reg IF_ID_PipeRegWrite; // 控制 ID stage 的 stall


  wire load_use;
  wire branch_data_hazard;
  wire branch_load_use;

  assign load_use = EX_MemRead & ((EX_RegRt==ID_RegRs) | (EX_RegRt==ID_RegRt));
  assign branch_data_hazard = branch & EX_RegWrite & (EX_RegRt==ID_RegRs | EX_RegRt==ID_RegRt) ;
  assign branch_load_use = EX_MemRead & branch & ((EX_RegRt==ID_RegRs) | (EX_RegRt==ID_RegRt));


  always @(*)
  begin
    if(EX_branch_load_use | branch_load_use)
    begin
      IF_Flush <= 1'b0;
      ID_Flush <= 1'b1;
      IF_ID_PipeRegWrite <= 1'b0;
      PC_Write <= 1'b0;
    end
    else if(branch_data_hazard)
    begin
      IF_Flush <= 1'b0;
      ID_Flush <= 1'b1;
      IF_ID_PipeRegWrite <= 1'b0;
      PC_Write <= 1'b0;
    end
    else if(branch_taken)
    begin
      IF_Flush <=1'b1;
      ID_Flush <=1'b0;
      IF_ID_PipeRegWrite <= 1'b1;
      PC_Write <= 1'b1;
    end
    else if(load_use)
    begin
      IF_Flush <=1'b0;
      ID_Flush <= 1'b1;
      PC_Write <= 1'b0;
      IF_ID_PipeRegWrite <= 1'b0;
    end
    else
    begin
      IF_Flush <= 1'b0;
      ID_Flush <= 1'b0;
      PC_Write <= 1'b1;
      IF_ID_PipeRegWrite <= 1'b1;
    end
  end
endmodule
