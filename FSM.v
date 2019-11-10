// Defines for instructions
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

// Finite State machine to set control signals for a multicycle CPU
module FSM
(
<<<<<<< HEAD
  output PC_WE,
=======
  output reg PC_WE,
>>>>>>> 7e016c4e07ab556590a04f509183b6bae5c6e6d1
  output reg [1:0] PCSrc,
  output reg MemIn,
  output reg Mem_WE,
  output reg IR_WE,
<<<<<<< HEAD
=======
  output reg A_WE,
  output reg B_WE,
>>>>>>> 7e016c4e07ab556590a04f509183b6bae5c6e6d1
  output reg ALUSrcA,
  output reg [2:0] ALUSrcB,
  output reg [2:0] ALUop,
  output reg Dst,
  output reg RegIn,
  output reg Reg_WE,
  output reg [3:0] Branch,
  output reg JAL,
<<<<<<< HEAD
  input reg clk,
  input reg [31:0] instruction
=======
  input clk,
  input [31:0] instruction
>>>>>>> 7e016c4e07ab556590a04f509183b6bae5c6e6d1
);

// State encoding (binary counter)
reg [4:0] state;
localparam IF_ = 0,
           ID_JAL = 1,
           ID_J = 2,
           ID_BEQ_BNE = 3,
           EX_BEQ = 4,
           EX_BNE = 5,
           EX_LW_SW_ADDI = 6,
           EX_XORI = 7,
           EX_ADD = 8,
           EX_SUB = 9,
           EX_SLT = 10,
           EX_JR = 11,
           MEM_LW = 12,
           MEM_SW = 13,
           WB_LW = 14,
           WB_ADDI_XORI = 15,
           WB_ADD_SUB_SLT = 16;

//Initialize state to IF_
initial begin
  state = IF_;
end

// Change state on the p-clk edge
always @ (posedge clk) begin
  // Transitions from IF_
  if (state == IF__ && instruction[31:26] == `JAL) begin
    state <= ID_JAL;
  end
  if (state == IF_ && instruction[31:26] == `J) begin
    state <= ID_J;
  endcondition
  if (state == IF_ && (instruction[31:26] == `BEQ || instruction[31:26] == `BNE)) begin
    state <= ID_BEQ_BNE;
  end
  if (state == IF_ && (instruction[31:26] == `LW || instruction[31:26] || instruction[31:26])) begin
    state <= EX_LW_SW_ADDI;
  end
  if (state == IF_ && instruction[31:26] == `XORI) begin
    state <= EX_XORI;
  end
  if (state == IF_ && instruction[5:0] == `ADD) begin
    state <= EX_ADD;
  end
  if (state == IF_ && instruction[5:0] == `SUB) begin
    state <= EX_SUB;
  end
  if (state == IF_ && instruction[5:0] == `SLT) begin
    state <= EX_SLT;
  end
  if (state == IF_ && instruction[5:0] == `JR) begin
    state <= EX_JR;
  end

  // Transition from ID states
  if (state == ID_J) begin
    state <= IF_;
  end
  if (state == ID_JAL) begin
    state <= IF_;
  end
  if (state == ID_BEQ_BNE && instruction[31:26] == `BEQ) begin
    state <= EX_BEQ;
  end
  if (state == ID_BEQ_BNE && instruction[31:26] == `BNE) begin
    state <= EX_BNE;
  end

  // Transition from EX states
  if (state == EX_LW_SW_ADDI && instruction[31:26] == `LW) begin
    state <= MEM_LW;
  end
  if (state == EX_LW_SW_ADDI && instruction[31:26] == `SW) begin
    state <= MEM_SW;
  end
  if (state == EX_LW_SW_ADDI && instruction[31:26] == `ADDI) begin
    state <= WB_ADDI_XORI;
  end
  if (state == EX_XORI) begin
    state <= WB_ADDI_XORI;
  end
  if (state == EX_ADD) begin
    state <= WB_ADD_SUB_SLT;
  end
  if (state == EX_SUB) begin
    state <= WB_ADD_SUB_SLT;
  end
  if (state == EX_SLT) begin
    state <= WB_ADD_SUB_SLT;
  end
  if (state == EX_JR) begin
    state <= IF_;
  end

  // Transitions from MEM
  if (state == MEM_LW) begin
    state <= WB_LW;
  end
  if (state == MEM_SW) begin
    state <= IF_;
  end

  // Transition from WB
  if (state == WB_LW || state == WB_ADDI_XORI || state == WB_ADD_SUB_SLT) begin
    state <= IF_;
  end
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
