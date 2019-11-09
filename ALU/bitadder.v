/* A Full-Bit Adder
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`include "ALU/util.v"

module structuralFullAdder
(
    output sum,
    output carryout,
    input a,
    input b,
    input c
);
    wire nC, nA, nB;
    wire alfa;
    wire beta;
    wire charlie;
    wire delta;
    wire echo;
    wire foxtrot;
    wire golf;
    `NOT Cinv(nC, c);
    `NOT Ainv(nA,a);
    `NOT Binv(nB,b);
    `XOR alfagate(alfa, a, b);
    `XOR betagate(beta, b, c);
    `AND charliegate(charlie, a, b);
    `AND deltagate(delta, c, alfa);
    `AND echogate(echo, beta, nA);
    `NOT foxtrotgate(foxtrot, beta);
    `AND golfgate(golf, a, foxtrot);
    `OR carryoutgate(carryout, charlie, delta);
    `OR sumgate(sum, echo, golf);

endmodule
