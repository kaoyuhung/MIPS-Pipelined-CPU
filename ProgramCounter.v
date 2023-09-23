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

module ProgramCounter(
    clk_i,
    rst_i,
    pc_in_i,
    PC_Write,
    pc_out_o
  );

  //I/O ports
  input           clk_i;
  input	          rst_i;
  input           PC_Write;
  input  [32-1:0] pc_in_i;
  output [32-1:0] pc_out_o;

  //Internal Signals
  reg    [32-1:0] pc_out_o;

  //Parameter


  //Main function
  always @(posedge clk_i)
  begin
    if(~rst_i)
      pc_out_o <= 0;
    else if(PC_Write)
      pc_out_o <= pc_in_i;
  end

endmodule





