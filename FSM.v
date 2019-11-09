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
