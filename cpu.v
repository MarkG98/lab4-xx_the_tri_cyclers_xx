`include "FSM.v"
`include "memory.v"
`include "instructionDecoder.v"
`include "Regfile/regfile.v"
`include "signExtend.v"
`include "ALU/alu.v"

module cpu
(
  input clk
);

// 32-bit instruction wire
wire[31:0] instruction;

// FSM controlled control signals
wire PC_WE;
wire [1:0] PCSrc;
wire Mem_WE;
wire IR_WE;
wire ALUSrcA;
wire [2:0] ALUSrcB;
wire [2:0] ALUop;
wire Dst;
wire RegIn;
wire Reg_WE;
wire [3:0] Branch;
wire JAL;

reg PCounter_En;
reg [31:0] Rtor31;
reg [4:0] Aw;
reg [31:0] Dw;
reg [31:0] ALUA;
reg [31:0] ALUB;
reg [31:0] nextPC;

wire [31:0] PC;
wire zero;
wire [31:0] data_out;
wire [31:0] Da;
wire [31:0] Db;
wire [31:0] ALURes;
wire [31:0] MDRout;
wire [31:0] currInstr;
wire [15:0] imm16;
wire [4:0] rd;
wire [4:0] rt;
wire [4:0] rs;
wire [31:0] target_instruction;
wire [31:0] jumpRes;
wire [31:0] sextImm16;
wire [31:0] result;




FSM FSMcontroller(.PC_WE(PC_WE),
                  .PCSrc(PCSrc),
                  .Mem_WE(Mem_WE),
                  .IR_WE(IR_WE),
                  .ALUSrcA(ALUSrcA),
                  .ALUSrcB(ALUSrcB),
                  .ALUop(ALUop),
                  .Dst(Dst),
                  .RegIn(RegIn),
                  .Reg_WE(Reg_WE),
                  .Branch(Branch),
                  .JAL(JAL),
                  .clk(clk),
                  .instruction(currInstr),
                  .raw_instruction(instruction));

// Mux for programCounter Enable input
always @(*) begin
  if (Branch == 0) begin
    PCounter_En = PC_WE;
  end
  else if (Branch == 1) begin
    PCounter_En = zero;
  end
  else begin
    PCounter_En = ~zero;
  end
end

// program counter register
register32 programCounter(.q(PC),
                          .d(nextPC),
                          .wrenable(PCounter_En),
                          .clk(clk));
// Memory block
memory sysmem(.PC(PC),
              .instruction(instruction),
              .data_out(data_out),
              .data_in(Db),
              .data_addr(ALURes),
              .clk(clk),
              .wr_en(Mem_WE));

// Register for output of data memory
register32 MDR(.q(MDRout),
               .d(data_out),
               .wrenable(1'b1),
               .clk(clk));

// Mux into Dw port of the regfile
always @ ( * ) begin
  Dw = (RegIn) ? ALURes : MDRout;
end

// Register to hold current instruction
register32 IR(.q(currInstr),
              .d(instruction),
              .wrenable(IR_WE),
              .clk(clk));

// Instruction decoder unit
instructionDecoder ID(.imm16(imm16),
                      .rd(rd),
                      .rt(rt),
                      .rs(rs),
                      .target_instruction(target_instruction),
                      .instruction(currInstr));

// Sign extend imm16
signExtend SEXT(.signExtended(sextImm16),
                .extendee(imm16));

// Concatinate for jump instructions
assign jumpRes = {PC[31:28],target_instruction,2'b00};



// Mux control logic for input to Regfile
always @ ( * ) begin
  Rtor31 = (JAL) ? 31 : rt;
  Aw = (Dst) ? rd : Rtor31;
end

// Register file part
regfile registerFile(.ReadData1(Da),
                     .ReadData2(Db),
                     .WriteData(Dw),
                     .ReadRegister1(rs),
                     .ReadRegister2(rt),
                     .WriteRegister(Aw),
                     .RegWrite(Reg_WE),
                     .Clk(clk));

always @ ( * ) begin
  // Mux input into ALU A
  ALUA = (ALUSrcA) ? Da : PC;

  // Mux input into ALUB
  if (ALUSrcB == 0) begin
    ALUB = sextImm16 << 2;
  end
  else if (ALUSrcB == 1) begin
    ALUB = sextImm16;
  end
  else if (ALUSrcB == 2) begin
    ALUB = Db;
  end
  else if (ALUSrcB == 3) begin
    ALUB = 4;
  end
  else begin
    ALUB = 32'b0;
  end
end

ALU alUnit(.result(result),
           .zero(zero),
           .operandA(ALUA),
           .operandB(ALUB),
           .command(ALUop));

register32 ALUResReg(.q(ALURes),
                     .d(result),
                     .wrenable(1'b1),
                     .clk(clk));

always @ ( * ) begin
  if(PCSrc == 0) begin
    nextPC = ALURes;
  end
  else if (PCSrc == 1) begin
    nextPC = result;
  end
  else begin
    nextPC = jumpRes;
  end
end
endmodule
