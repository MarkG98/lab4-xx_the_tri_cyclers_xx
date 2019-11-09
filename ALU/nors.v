/* Dirty little wrappers to convert from arrays to multiple-input nor gates.
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`include "ALU/util.v"

module nor32
(
  output result, //the total result of the alu
  input [31:0] r
);
nor bigboi(result,r[0],r[1],r[2],r[3],r[4],r[5],r[6],r[7],r[8],r[9],r[10],r[11],r[12],r[13],r[14],r[15],r[16],r[17],r[18],r[19],r[20],r[21],r[22],r[23],r[24],r[25],r[26],r[27],r[28],r[29],r[30],r[31]);
endmodule

module nor8
(
  output result, //the total result of the alu
  input [7:0] r
);
nor bigboi(result,r[0],r[1],r[2],r[3],r[4],r[5],r[6],r[7]);
endmodule
