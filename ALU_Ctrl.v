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

module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o,
  );

  //I/O ports
  input      [6-1:0] funct_i;
  input      [3-1:0] ALUOp_i;

  output     [4-1:0] ALUCtrl_o;

  //Internal Signals
  reg        [4-1:0] ALUCtrl_o;
  //Parameter


  //Select exact operation
  always @(*)
  begin
    case (ALUOp_i)
      3'b000:
        ALUCtrl_o <= 4'b0010;
      3'b001:
        ALUCtrl_o <= 4'b0111;
      3'b100:
        ALUCtrl_o <= 4'b0110;
      3'b010:
      case (funct_i)
        6'b100000:
          ALUCtrl_o <= 4'b0010;
        6'b100010:
          ALUCtrl_o <= 4'b0110;
        6'b100100:
          ALUCtrl_o <= 4'b0000;
        6'b100101:
          ALUCtrl_o <= 4'b0001;
        6'b101010:
          ALUCtrl_o <= 4'b0111;
        6'b001000:
          ALUCtrl_o <= 4'b0010;
        6'b011000:
          ALUCtrl_o <= 4'b1000;
      endcase
      default:
        ALUCtrl_o<= 4'b0010;
    endcase
  end
endmodule







