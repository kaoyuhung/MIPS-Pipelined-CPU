`timescale 1ns / 1ps
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
module Pipe_CPU_1(
    clk_i,
    rst_i
  );

  /****************************************
  I/O ports
  ****************************************/
  input clk_i;
  input rst_i;

  /****************************************
  Internal signal
  ****************************************/
  /**** IF stage ****/
  wire [32-1:0]pc_in;
  wire [32-1:0]pc_branch;
  wire [32-1:0]pc_n;
  wire [32-1:0]pc_out;
  wire [32-1:0]instr;
  wire [32-1:0]instr_tmp;

  /**** ID stage ****/
  wire [32-1:0]ID_pc_n;
  wire [32-1:0]ID_instr;
  wire [32-1:0]RsData;
  wire [32-1:0]RtData;
  wire [32-1:0]RsData_tmp;
  wire [32-1:0]RtData_tmp;
  wire [32-1:0]SEnum;
  wire [32-1:0]branch_offset;
  wire [9-1:0]ID_EX_c;

  //control signal
  wire pc_write_c;
  wire pc_src_c;
  wire RegWrite_c;
  wire beq_c;
  wire bne_c;
  wire bge_c;
  wire bgt_c;
  wire ALUSrc_c;
  wire [3-1:0]ALUop_c;
  wire RegDst_c;
  wire MemRead_c;
  wire MemWrite_c;
  wire MemtoReg_c;
  wire IF_Flush_c;
  wire ID_Flush_c;
  wire IF_ID_PipeRegWrite_c;
  wire branch_load_use_c;
  /**** EX stage ****/
  wire [5-1:0]EX_RegRs;
  wire [5-1:0]EX_RegRt;
  wire [5-1:0]EX_RegRd;
  wire [6-1:0]EX_func;
  wire [32-1:0]EX_RsData;
  wire [32-1:0]EX_RtData;
  wire [32-1:0]EX_SEnum;
  wire [32-1:0]ALUsrc1;
  wire [32-1:0]ALUsrc2;
  wire [32-1:0]ALUsrc2_tmp;
  wire [32-1:0]ALUresult;
  wire [5-1:0]WriteReg;

  //control signal
  wire EX_ALUSrc_c;
  wire [3-1:0]EX_ALUop_c;
  wire EX_RegDst_c;
  wire EX_MemRead_c;
  wire EX_MemWrite_c;
  wire EX_MemtoReg_c;
  wire EX_RegWrite_c;
  wire [4-1:0]ALUctrl_c;
  wire EX_branch_load_use_c;
  /**** MEM stage ****/
  wire [32-1:0]MEM_ALUresult;
  wire [32-1:0]MEM_data;
  wire [5-1:0] MEM_WriteReg;
  wire [32-1:0]MemResult;

  //control signal
  wire MEM_RegWrite_c;
  wire MEM_MemtoReg_c;
  wire MEM_MemRead_c;
  wire MEM_MemWrite_c;

  /**** WB stage ****/
  wire [32-1:0]WB_WBdata;
  wire [32-1:0]WB_ALUresult;
  wire [32-1:0]WB_MemResult;
  wire [5-1:0]WB_WriteReg;

  //control signal
  wire [2-1:0] FA;
  wire [2-1:0] FB;
  wire [2-1:0] FC;
  wire [2-1:0] FD;
  wire WB_RegWrite_c;
  wire WB_MemtoReg_c;

  /****************************************
  Instantiate modules
  ****************************************/
  //Instantiate the components in IF stage
  MUX_2to1 #(.size(32)) Mux0(
             .data0_i(pc_n),
             .data1_i(pc_branch),
             .select_i(pc_src_c),
             .data_o(pc_in)
           );

  ProgramCounter PC(
                   .clk_i(clk_i),
                   .rst_i(rst_i),
                   .pc_in_i(pc_in),
                   .PC_Write(pc_write_c),
                   .pc_out_o(pc_out)
                 );

  Instruction_Memory IM(
                       .addr_i(pc_out),
                       .instr_o(instr_tmp)
                     );

  Adder Add_pc(
          .src1_i(32'h0004),
          .src2_i(pc_out),
          .sum_o(pc_n)
        );


  MUX_2to1 #(.size(32)) Mux6(
             .data0_i(instr_tmp),
             .data1_i(32'h0000),
             .select_i(IF_Flush_c),
             .data_o(instr)
           );

  Pipe_Reg #(.size(64)) IF_ID(
             .clk_i(clk_i),
             .rst_i(rst_i),
             .data_i({pc_n,instr}),
             .Pipe_Reg_Write(IF_ID_PipeRegWrite_c),
             .data_o({ID_pc_n,ID_instr})
           );


  //Instantiate the components in ID stage
  Reg_File RF(
             .clk_i(clk_i),
             .rst_i(rst_i),
             .RSaddr_i(ID_instr[25:21]),
             .RTaddr_i(ID_instr[20:16]),
             .RDaddr_i(WB_WriteReg),
             .RDdata_i(WB_WBdata),
             .RegWrite_i(WB_RegWrite_c),
             .RSdata_o(RsData_tmp),
             .RTdata_o(RtData_tmp)
           );

  Decoder Control(
            .instr_op_i(ID_instr[31:26]),
            .RegWrite_o(RegWrite_c),
            .ALU_op_o(ALUop_c),
            .ALUSrc_o(ALUSrc_c),
            .RegDst_o(RegDst_c),
            .beq_o(beq_c),
            .bne_o(bne_c),
            .bge_o(bge_c),
            .bgt_o(bgt_c),
            .MemRead_o(MemRead_c),
            .MemWrite_o(MemWrite_c),
            .MemtoReg_o(MemtoReg_c)
          );

  Sign_Extend Sign_Extend(
                .data_i(ID_instr[15:0]),
                .data_o(SEnum)
              );

  Shift_Left_Two_32 Shifter(
                      .data_i(SEnum),
                      .data_o(branch_offset)
                    );

  Adder Add_pc_branch(
          .src1_i(ID_pc_n),
          .src2_i(branch_offset),
          .sum_o(pc_branch)
        );

  MUX_3to1 #(.size(32)) Mux8(
             .data0_i(RsData_tmp),
             .data1_i(MEM_ALUresult),
             .data2_i(WB_WBdata),
             .select_i(FC),
             .data_o(RsData)
           );

  MUX_3to1 #(.size(32)) Mux9(
             .data0_i(RtData_tmp),
             .data1_i(MEM_ALUresult),
             .data2_i(WB_WBdata),
             .select_i(FD),
             .data_o(RtData)
           );

  branch_handle_unit BHU(
                       .beq(beq_c),
                       .bne(bne_c),
                       .bge(bge_c),
                       .bgt(bgt_c),
                       .Rsdata(RsData),
                       .Rtdata(RtData),
                       .branch(pc_src_c)
                     );

  MUX_2to1 #(.size(9)) Mux(
             .data0_i({RegWrite_c, MemtoReg_c,
                       MemRead_c, MemWrite_c,
                       ALUSrc_c, ALUop_c, RegDst_c}),
             .data1_i(9'b000000000),
             .select_i(ID_Flush_c),
             .data_o(ID_EX_c)
           );

  Pipe_Reg #(.size(127)) ID_EX(
             .clk_i(clk_i),
             .rst_i(rst_i),
             .data_i({ID_EX_c,branch_load_use_c,RsData,RtData,SEnum,
                      ID_instr[25:11],ID_instr[5:0]}),
             .Pipe_Reg_Write(1'b1),
             .data_o({EX_RegWrite_c, EX_MemtoReg_c,
                      EX_MemRead_c, EX_MemWrite_c,
                      EX_ALUSrc_c, EX_ALUop_c,EX_RegDst_c, EX_branch_load_use_c,
                      EX_RsData, EX_RtData,EX_SEnum,
                      EX_RegRs, EX_RegRt,EX_RegRd, EX_func})
           );

  MUX_3to1 #(.size(32)) Mux4(
             .data0_i(EX_RsData),
             .data1_i(MEM_ALUresult),
             .data2_i(WB_WBdata),
             .select_i(FA),
             .data_o(ALUsrc1)
           );

  MUX_3to1 #(.size(32)) Mux5(
             .data0_i(EX_RtData),
             .data1_i(MEM_ALUresult),
             .data2_i(WB_WBdata),
             .select_i(FB),
             .data_o(ALUsrc2_tmp)
           );

  MUX_2to1 #(.size(32)) Mux1(
             .data0_i(ALUsrc2_tmp),
             .data1_i(EX_SEnum),
             .select_i(EX_ALUSrc_c),
             .data_o(ALUsrc2)
           );

  ALU_Control ALU_Control(
                .funct_i(EX_func),
                .ALUOp_i(EX_ALUop_c),
                .ALUCtrl_o(ALUctrl_c)
              );

  ALU ALU(
        .src1_i(ALUsrc1),
        .src2_i(ALUsrc2),
        .ctrl_i(ALUctrl_c),
        .result_o(ALUresult)
      );

  MUX_2to1 #(.size(5)) Mux2(
             .data0_i(EX_RegRt),
             .data1_i(EX_RegRd),
             .select_i(EX_RegDst_c),
             .data_o(WriteReg)
           );

  Pipe_Reg #(.size(73)) EX_MEM(
             .clk_i(clk_i),
             .rst_i(rst_i),
             .data_i({EX_RegWrite_c,EX_MemtoReg_c,
                      EX_MemRead_c,EX_MemWrite_c,
                      ALUresult,ALUsrc2_tmp,WriteReg}),
             .Pipe_Reg_Write(1'b1),
             .data_o({MEM_RegWrite_c,MEM_MemtoReg_c,
                      MEM_MemRead_c,MEM_MemWrite_c,
                      MEM_ALUresult,MEM_data,MEM_WriteReg})
           );

  //Instantiate the components in MEM stage
  Data_Memory DM(
                .clk_i(clk_i),
                .addr_i(MEM_ALUresult),
                .data_i(MEM_data),
                .MemRead_i(MEM_MemRead_c),
                .MemWrite_i(MEM_MemWrite_c),
                .data_o(MemResult)
              );

  Pipe_Reg #(.size(71)) MEM_WB(
             .clk_i(clk_i),
             .rst_i(rst_i),
             .data_i({MEM_RegWrite_c,MEM_MemtoReg_c,
                      MEM_ALUresult,MemResult,MEM_WriteReg}),
             .Pipe_Reg_Write(1'b1),
             .data_o({WB_RegWrite_c,WB_MemtoReg_c,
                      WB_ALUresult,WB_MemResult,WB_WriteReg})
           );


  //Instantiate the components in WB stage
  MUX_2to1 #(.size(32)) Mux3(
             .data0_i(WB_ALUresult),
             .data1_i(WB_MemResult),
             .select_i(WB_MemtoReg_c),
             .data_o(WB_WBdata)
           );

  Forwarding_unit FU(
                    .ID_RegRs(ID_instr[25:21]),
                    .ID_RegRt(ID_instr[20:16]),
                    .EX_RegRs(EX_RegRs),
                    .EX_RegRt(EX_RegRt),
                    .MEM_RegWrite(MEM_RegWrite_c),
                    .MEM_RegRd(MEM_WriteReg),
                    .WB_RegWrite(WB_RegWrite_c),
                    .WB_RegRd(WB_WriteReg),
                    .FA(FA),
                    .FB(FB),
                    .FC(FC),
                    .FD(FD)
                  );

  Hazard_detection_unit HDU(
                          .EX_MemRead(EX_MemRead_c),
                          .EX_RegRt(WriteReg),
                          .EX_RegWrite(EX_RegWrite_c),
                          .EX_branch_load_use(EX_branch_load_use_c),
                          .ID_RegRs(ID_instr[25:21]),
                          .ID_RegRt(ID_instr[20:16]),
                          .branch(beq_c|bne_c|bge_c|bgt_c),
                          .branch_taken(pc_src_c),
                          .IF_Flush(IF_Flush_c),
                          .IF_ID_PipeRegWrite(IF_ID_PipeRegWrite_c),
                          .ID_Flush(ID_Flush_c),
                          .PC_Write(pc_write_c),
                          .branch_load_use(branch_load_use_c)
                        );

  /****************************************
  signal assignment
  ****************************************/

endmodule

