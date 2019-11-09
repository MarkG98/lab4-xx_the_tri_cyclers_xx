//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

`include "Regfile/register.v"
`include "Regfile/multiplexers.v"
`include "Regfile/decoders.v"

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);

  // Output of decoder which selects register to write to
  wire[31:0] register_selector;

  // Instantiate decoder to control which register is written to
  decoder1to32 Decoder
  (
    .out(register_selector),
    .enable(RegWrite),
    .address(WriteRegister)
  );

  // Wire for output of zero register
  wire[31:0] zeroRegOutput;

  // Instantiate zero register
  register32zero ZeroRegister
  (
    .q(zeroRegOutput),
    .d(WriteData),
    .wrenable(register_selector[0]),
    .clk(Clk)
  );

  // Generate remaining 31 registers
  genvar i;
  generate
    for (i=1; i<32; i=i+1)
    begin:genblock
      wire[31:0] _reg_out;
      register32 Register
      (
        .q(_reg_out),
        .d(WriteData),
        .wrenable(register_selector[i]),
        .clk(Clk)
      );
    end
  endgenerate

  // First read register
  mux32to1by32 ReadMux1
  (
    .out(ReadData1),
    .address(ReadRegister1),
    .input0(zeroRegOutput),
    .input1(genblock[1]._reg_out),
    .input2(genblock[2]._reg_out),
    .input3(genblock[3]._reg_out),
    .input4(genblock[4]._reg_out),
    .input5(genblock[5]._reg_out),
    .input6(genblock[6]._reg_out),
    .input7(genblock[7]._reg_out),
    .input8(genblock[8]._reg_out),
    .input9(genblock[9]._reg_out),
    .input10(genblock[10]._reg_out),
    .input11(genblock[11]._reg_out),
    .input12(genblock[12]._reg_out),
    .input13(genblock[13]._reg_out),
    .input14(genblock[14]._reg_out),
    .input15(genblock[15]._reg_out),
    .input16(genblock[16]._reg_out),
    .input17(genblock[17]._reg_out),
    .input18(genblock[18]._reg_out),
    .input19(genblock[19]._reg_out),
    .input20(genblock[20]._reg_out),
    .input21(genblock[21]._reg_out),
    .input22(genblock[22]._reg_out),
    .input23(genblock[23]._reg_out),
    .input24(genblock[24]._reg_out),
    .input25(genblock[25]._reg_out),
    .input26(genblock[26]._reg_out),
    .input27(genblock[27]._reg_out),
    .input28(genblock[28]._reg_out),
    .input29(genblock[29]._reg_out),
    .input30(genblock[30]._reg_out),
    .input31(genblock[31]._reg_out)
  );

  // Second read register
  mux32to1by32 ReadMux2
  (
    .out(ReadData2),
    .address(ReadRegister2),
    .input0(zeroRegOutput),
    .input1(genblock[1]._reg_out),
    .input2(genblock[2]._reg_out),
    .input3(genblock[3]._reg_out),
    .input4(genblock[4]._reg_out),
    .input5(genblock[5]._reg_out),
    .input6(genblock[6]._reg_out),
    .input7(genblock[7]._reg_out),
    .input8(genblock[8]._reg_out),
    .input9(genblock[9]._reg_out),
    .input10(genblock[10]._reg_out),
    .input11(genblock[11]._reg_out),
    .input12(genblock[12]._reg_out),
    .input13(genblock[13]._reg_out),
    .input14(genblock[14]._reg_out),
    .input15(genblock[15]._reg_out),
    .input16(genblock[16]._reg_out),
    .input17(genblock[17]._reg_out),
    .input18(genblock[18]._reg_out),
    .input19(genblock[19]._reg_out),
    .input20(genblock[20]._reg_out),
    .input21(genblock[21]._reg_out),
    .input22(genblock[22]._reg_out),
    .input23(genblock[23]._reg_out),
    .input24(genblock[24]._reg_out),
    .input25(genblock[25]._reg_out),
    .input26(genblock[26]._reg_out),
    .input27(genblock[27]._reg_out),
    .input28(genblock[28]._reg_out),
    .input29(genblock[29]._reg_out),
    .input30(genblock[30]._reg_out),
    .input31(genblock[31]._reg_out)
  );

endmodule
