`define LW 6'h23
`define SW 6'h2b
`define J 6'h02
`define JAL 6'h03
`define BEQ 6'h04
`define BNE 6'h05
`define XORI 6'h0E
`define ADDI 6'h08
`define RINST 6'h00
`define JR 6'h08
`define ADD 6'h20
`define SUB 6'h22
`define SLT 6'h2a

// always @(instruction) begin
//     case (instruction[31:26])
//       `LW:   begin regDst = 0; regWr = 1; ALUControl = 3'b000; ALUSrc = 0; memWr = 0; memToReg = 1; jump = 0; branch = 0; notEqual = 0; jReg = 0; jAndLink = 0; end
//       `SW:   begin regDst = 0; regWr = 0; ALUControl = 3'b000; ALUSrc = 0; memWr = 1; memToReg = 0; jump = 0; branch = 0; notEqual = 0; jReg = 0; jAndLink = 0; end
//       `J:    begin regDst = 0; regWr = 0; ALUControl = 3'b000; ALUSrc = 0; memWr = 0; memToReg = 0; jump = 1; branch = 0; notEqual = 0; jReg = 0; jAndLink = 0; end
//       `JAL:  begin regDst = 0; regWr = 1; ALUControl = 3'b000; ALUSrc = 0; memWr = 0; memToReg = 0; jump = 1; branch = 0; notEqual = 0; jReg = 0; jAndLink = 1; end
//       `BEQ:  begin regDst = 0; regWr = 0; ALUControl = 3'b001; ALUSrc = 1; memWr = 0; memToReg = 0; jump = 0; branch = 1; notEqual = 0; jReg = 0; jAndLink = 0; end
//       `BNE:  begin regDst = 0; regWr = 0; ALUControl = 3'b001; ALUSrc = 1; memWr = 0; memToReg = 0; jump = 0; branch = 1; notEqual = 1; jReg = 0; jAndLink = 0; end
//       `XORI: begin regDst = 0; regWr = 1; ALUControl = 3'b010; ALUSrc = 0; memWr = 0; memToReg = 0; jump = 0; branch = 0; notEqual = 0; jReg = 0; jAndLink = 0; end
//       `ADDI: begin regDst = 0; regWr = 1; ALUControl = 3'b000; ALUSrc = 0; memWr = 0; memToReg = 0; jump = 0; branch = 0; notEqual = 0; jReg = 0; jAndLink = 0; end
//       `RINST: begin case(instruction[5:0])
//           `JR:   begin regDst = 0; regWr = 0; ALUControl = 3'b000; ALUSrc = 1; memWr = 0; memToReg = 0; jump = 1; branch = 0; notEqual = 0; jReg = 1; jAndLink = 0; end
//           `ADD:  begin regDst = 1; regWr = 1; ALUControl = 3'b000; ALUSrc = 1; memWr = 0; memToReg = 0; jump = 0; branch = 0; notEqual = 0; jReg = 0; jAndLink = 0; end
//           `SUB:  begin regDst = 1; regWr = 1; ALUControl = 3'b001; ALUSrc = 1; memWr = 0; memToReg = 0; jump = 0; branch = 0; notEqual = 0; jReg = 0; jAndLink = 0; end
//           `SLT:  begin regDst = 1; regWr = 1; ALUControl = 3'b011; ALUSrc = 1; memWr = 0; memToReg = 0; jump = 0; branch = 0; notEqual = 0; jReg = 0; jAndLink = 0; end
//         endcase
//       end
//     endcase
//   end


// Finite State machine to set control signals for a multicycle CPU
module FSM
(
  output reg PC_WE,
  output reg [1:0] PCSrc,
  output reg MemIn,
  output reg Mem_WE,
  output reg IR_WE,
  output reg A_WE,
  output reg B_WE,
  output reg ALUSrcA,
  output reg [2:0] ALUSrcB,
  output reg [2:0] ALUop,
  output reg Dst,
  output reg RegIn,
  output reg Reg_WE,
  output reg [3:0] Branch,
  output reg JAL,
  input clk,
  input [31:0] instruction
);

// State encoding (binary counter)
reg [4:0] state;
localparam IF_ = 0,
           ID_JAL = 1,
           ID_J = 2,
           ID_BEQ_BNE = 3,
           ID_SW_ADD_SUB_SLT_LW_JR_ADDI_XORI = 4,
           EX_BEQ = 5,
           EX_BNE = 6,
           EX_LW_SW_ADDI = 7,
           EX_XORI = 8,
           EX_ADD = 9,
           EX_SUB = 10,
           EX_SLT = 11,
           EX_JR = 12,
           MEM_LW = 13,
           MEM_SW = 14,
           WB_LW = 15,
           WB_ADDI_XORI = 16,
           WB_ADD_SUB_SLT = 17;

//Initialize state to IF
initial begin
  state = IF_;
end

// Change state on the p-clk edge
always @ (posedge clk) begin

end

// output reg logic (depends only on state - Moore machine)
always @ (state) begin
  case (state)
    IF_:  begin Mem_WE = 0; RegIn = 0; IR_WE = 1; PCSrc = 1; Branch = 0; ALUSrcB = 3; ALUSrcA = 0; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 1; ALUop = 0; Dst = 0; end
    ID_J:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 2; Branch = 0; ALUSrcB = 0; ALUSrcA = 0; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 1; ALUop = 0; Dst = 0; end
    ID_SW_ADD_SUB_SLT_LW_JR_ADDI_XORI:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 0; ALUSrcA = 0; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 0; Dst = 0; end
    ID_BEQ_BNE:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 0; ALUSrcA = 0; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 0; Dst = 0; end
    ID_JAL:  begin Mem_WE = 0; RegIn = 1; IR_WE = 0; PCSrc = 2; Branch = 0; ALUSrcB = 0; ALUSrcA = 0; Reg_WE = 1; JAL = 1; MemIn = 0; PC_WE = 1; ALUop = 0; Dst = 0; end
    EX_BEQ:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 1; ALUSrcB = 2; ALUSrcA = 1; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 1; Dst = 0; end
    EX_BNE:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 2; ALUSrcB = 2; ALUSrcA = 1; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 1; Dst = 0; end
    EX_LW_SW_ADDI:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 1; ALUSrcA = 1; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 0; Dst = 0; end
    EX_JR:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 1; Branch = 0; ALUSrcB = 4; ALUSrcA = 1; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 1; ALUop = 0; Dst = 0; end
    EX_ADD:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 2; ALUSrcA = 1; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 0; Dst = 0; end
    EX_SLT:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 2; ALUSrcA = 1; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 3; Dst = 0; end
    EX_SUB:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 2; ALUSrcA = 1; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 1; Dst = 0; end
    EX_XORI:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 1; ALUSrcA = 1; Reg_WE = 0; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 2; Dst = 0; end
    MEM_LW:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 0; ALUSrcA = 0; Reg_WE = 0; JAL = 0; MemIn = 1; PC_WE = 0; ALUop = 0; Dst = 0; end
    MEM_SW:  begin Mem_WE = 1; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 0; ALUSrcA = 0; Reg_WE = 0; JAL = 0; MemIn = 1; PC_WE = 0; ALUop = 0; Dst = 0; end
    WB_LW:  begin Mem_WE = 0; RegIn = 0; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 0; ALUSrcA = 0; Reg_WE = 1; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 0; Dst = 0; end
    WB_ADD_SUB_SLT:  begin Mem_WE = 0; RegIn = 1; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 2; ALUSrcA = 1; Reg_WE = 1; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 0; Dst = 1; end
    WB_ADDI_XORI:  begin Mem_WE = 0; RegIn = 1; IR_WE = 0; PCSrc = 0; Branch = 0; ALUSrcB = 1; ALUSrcA = 1; Reg_WE = 1; JAL = 0; MemIn = 0; PC_WE = 0; ALUop = 0; Dst = 0; end
  endcase
end

endmodule // FSM
