/* A Full-Bit Adder/Subtractor
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`include "ALU/util.v"

`include "ALU/bitadder.v"

module bitSubtractor
(
    output sum,
    output carryout,
    input a,
    input b,
    input carryin,
    input subtract  // operation is subtract
);
  wire bXORsubtract;

  // XOR the subtract command signal with a bit of b to invert it if we are subtracting
  `XOR bXORsubtractGate(bXORsubtract,b,subtract);
  // Instantiate an adder and add the bit of a with the XORed bit of b
  structuralFullAdder adder(sum, carryout, a, bXORsubtract, carryin);
endmodule
