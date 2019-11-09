/* Demo of the partial adder-subtractor.
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */
`timescale 1 ns / 1 ps

`include "ALU/util.v"
`include "ALU/generate-subtractor.v"

`define DELAY #1000

module testSubtractor();
    // inputs
    reg[3:0] a;
    reg[3:0] b;
    reg subtract;
    // outputs
    wire[3:0] sum;
    wire cout, overflow;

    subtractor subt(
        .sum(sum),
        .carryout(cout),
        .overflow(overflow),
        .a(a),
        .b(b),
        .subtract(subtract)
    );

    initial begin
        $display("Time     | A    B    s | S    Co O");
        $display("---------|-------------|----------");

        // macro to print outputs
        `define print $display("%8t | %b %b %b | %b  %b %b", $time, a, b, subtract, sum, cout, overflow)

        subtract = 0;
        a = 'b0100;
        b = 'b0011; `DELAY
        `print;
        `check_eq(sum, 'b0111);

        subtract = 1;
        a = 'b0100;
        b = 'b0011; `DELAY
        `print;
        `check_eq(sum, 'b0001);

        $finish();

    end
endmodule
