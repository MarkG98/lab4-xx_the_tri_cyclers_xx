/* Module that encompasses the logical operations for the ALU.
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`include "ALU/util.v"

module bitlogic
(
  output andout, // result of and operation
  output nandout, // result of nand operation
  output norout, // result of nor operation
  output orout, // result of or operation
  output xorout, // result of xor operation
  input A, // inputed A bit
  input B // inputed B bit
);
	// AND of A and B bits
  `AND andoutgate(andout,A,B);
  // OR of A and B bits
  `OR oroutgate(orout,A,B);
  // NOR of A and B bits
  `NOR noroutgate(norout,A,B);
  // NAND of A and B bits
  `NAND nandoutgate(nandout,A,B);
  // XOR of A and B bits
  `XOR xoroutgate(xorout,A,B);

endmodule
