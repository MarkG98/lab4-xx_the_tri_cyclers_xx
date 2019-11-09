/* Implementation of a bit-slice ALU
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`include "ALU/util.v"
`include "ALU/multiplexer.v"

module bitmultiplexer
(
  output result, // result of the multiplexer
  input[2:0] s,  // select bit array
  input andout, // result of the and operation
  input nandout, // result of the nand operation
  input norout, // result of the or operation
  input orout, // result of the nor operation
  input xorout, // result of the xor operation
  input addsub, // result of add subtract module
  input sltout // result of the SLT operation
);
  wire bit4result;
  wire xorsltout;
  wire rightsideout;
  // 2:1 multiplexer to choose between XOR and SLT functionality based on LSB of command
  twoBitMultiplexer xorsltoutgate(xorsltout,s[0],xorout,sltout);
  // 2:1 multiplexer to choose between ADD/SUB and the output of above multiplexer based on middle bit of command
  twoBitMultiplexer rightsidegate(rightsideout, s[1],addsub,xorsltout);
  // 4:1 multiplexer to choose between AND, NAND, NOR, and OR based on s[0] and s[1]
  structuralMultiplexer bit4resultgate(bit4result,s[0],s[1],andout,nandout,norout,orout); // 4 bit multiplexer
  // 2:1 multiplexer to choose between output of 4:1 and two 2:1s for the final output which depends on MSB of command
  twoBitMultiplexer totalgate(result,s[2],rightsideout,bit4result);
endmodule
