/* Implementation of a bit-slice ALU.
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`include "ALU/util.v"
`include "ALU/bitsubtractor.v"
`include "ALU/bitlogic.v"
`include "ALU/bitmultiplexer.v"

module bitalu
(
  output result, //the total result of the alu
  output carryout, // the carryout of the alu
  output addsubout,
  input a, // the bit of that part of a
  input b, // the bit of that part of b
  input carryin, //previous carryin
  input[2:0] s, // select bits
  input sltout
);
  wire addsubout;
  wire carryout;
  wire andout;
  wire nandout;
  wire norout;
  wire orout;
  wire xorout;
  wire sltgnd = 1'b0;
  // Initialize 1-bit full adder/subtractor and put in the least significant bit of the command as the subtract control signal
  bitSubtractor addsubgate(addsubout,carryout,a,b,carryin,s[0]);
  // Calculate all "boolean logic" outputs
  bitlogic logicoutgate(andout,nandout,norout,orout,xorout,a,b);
  //Based on the command use multiplexer to assign result to the correct ouput bit
  bitmultiplexer resultgate(result,s[2:0],andout,nandout,norout,orout,xorout,addsubout,sltout);
endmodule
