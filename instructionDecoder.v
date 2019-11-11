module instructionDecoder
(
  output [15:0] imm16,
  output [4:0] rd,
  output [4:0] rt,
  output [4:0] rs,
  output [31:0] target_instruction,
  input [31:0] instruction
);

assign imm16 = instruction[15:0];

assign rd = instruction[15:11];

assign rt = instruction[20:16];

assign rs = instruction[25:21];

assign target_instruction = instruction[25:0];


endmodule
