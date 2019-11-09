// Finite State machine to set control signals for a multicycle CPU
module FSM
(
  output PC_WE,
  output [1:0] PCSrc,
  output MemIn,
  output Mem_WE,
  output IR_WE,
  output A_WE,
  output B_WE,
  output ALUSrcA,
  output [2:0] ALUSrcB,
  output [2:0] ALUop,
  output Dst,
  output RegIn,
  output Reg_WE,
  output [3:0] Branch,
  output JAL,
  input clk,
  input [31:0] instruction
);

// State encoding (binary counter)
reg [4:0] state;
localparam IF = 0,
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
           WB_ADD_SUB_SLY = 17;

//Initialize state to IF
initial begin
  state = IF;
end

// Change state on the p-clk edge
always @ (posedge clk) begin

end

// Output logic (depends only on state - Moore machine)
always @ (state) begin

end

endmodule // FSM
