/* Implementation of a bit-slice ALU specifc for LSB
 *
 * Lacks
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */
`ifndef _bitalulsb_v
`define _bitalulsb_v

`include "ALU/util.v"
`include "ALU/bitsubtractor.v"
`include "ALU/bitlogic.v"
`include "ALU/bitmultiplexer.v"

module bitalulsb
(
  output result, //the total result of the alu
  output carryout, // the carryout of the alu
  input a, // the bit of that part of a
  input b, // the bit of that part of b
  input[2:0] s, // select bits
  input sltout // the SLT bit
);
  wire addsubout;
  wire carryout;
  wire andout;
  wire nandout;
  wire norout;
  wire orout;
  wire xorout;
  bitSubtractor addsubgate(addsubout,carryout,a,b,s[0],s[0]);
  bitlogic logicoutgate(andout,nandout,norout,orout,xorout,a,b);
  bitmultiplexer resultgate(result,s[2:0],andout,nandout,norout,orout,xorout,addsubout,sltout);
endmodule

`endif
