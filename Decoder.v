//Subject:     LAB4
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      高鈺鴻
//----------------------------------------------
//Date: 2022/5/25
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    beq_o,
    bne_o,
    bge_o,
    bgt_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o,
  );

  //I/O ports
  input  [6-1:0] instr_op_i;

  output            RegWrite_o;
  output  [3-1:0]   ALU_op_o;
  output            ALUSrc_o;
  output            RegDst_o;
  output            beq_o;
  output            bne_o;
  output            bge_o;
  output            bgt_o;
  output            MemRead_o;
  output            MemWrite_o;
  output            MemtoReg_o;

  //Internal Signals
  reg    [3-1:0] ALU_op_o;
  reg            ALUSrc_o;
  reg            RegWrite_o;
  reg            RegDst_o;
  reg            beq_o;
  reg            bne_o;
  reg            bge_o;
  reg            bgt_o;
  reg            MemRead_o;
  reg            MemWrite_o;
  reg            MemtoReg_o;

  //Parameter
  wire R_format;
  wire addi;
  wire slti;
  wire beq;
  wire bne;
  wire bge;
  wire bgt;
  wire lw;
  wire sw;

  //Main function
  assign R_format = (instr_op_i==6'b000000);
  assign addi = (instr_op_i==6'b001000);
  assign slti = (instr_op_i==6'b001010);
  assign beq = (instr_op_i==6'b000100);
  assign bne = (instr_op_i==6'b000101);
  assign bge = (instr_op_i==6'b000001);
  assign bgt = (instr_op_i==6'b000111);
  assign lw = (instr_op_i==6'b100011);
  assign sw = (instr_op_i==6'b101011);

  always @(*)
  begin
    RegDst_o <= R_format;
    ALUSrc_o <= addi | slti | lw | sw;
    RegWrite_o <= R_format | addi | slti | lw;
    beq_o <= beq;
    bne_o <= bne;
    bge_o <= bge;
    bgt_o <= bgt;
    ALU_op_o[2] <= beq | bne | bge | bgt;
    ALU_op_o[1] <= R_format;
    ALU_op_o[0] <= slti;
    MemRead_o <= lw;
    MemWrite_o <= sw;
    MemtoReg_o <= lw;
  end
endmodule







