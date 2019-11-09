/* Tests an 8-bit version of the alu
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`timescale 1 ns / 1 ps

`include "ALU/util.v"
`include "ALU/alu.v"

module testalu();
    // inputs
    reg[2:0] cmd;
    reg[7:0] a;
    reg[7:0] b;

    // outputs
    wire[7:0] result;
    wire carryout, zero, overflow;

    ALU #(.WIDTH(8)) test_alu (
        .result(result),
        .carryout(carryout),
        .zero(zero),
        .overflow(overflow),
        .operandA(a),
        .operandB(b),
        .command(cmd)
    );


    initial begin
    //   $dumpfile("alu-dump.vcd");
    //   $dumpvars();
      `define DELAY #1000
      `define print $display("%b | %b %b | %b | %b%b%b", cmd, a, b, result, carryout, overflow, zero)
      $display("cmd | a        b        | R        | COZ");
      a='b01111010;b='b00000010;cmd='b000; `DELAY
      `print; `check_eq('b01111100,result);
      a='b11111010;b='b11100010;cmd='b000; `DELAY
      `print; `check_eq('b11011100,result);
      a='b01111111;b='b00011100;cmd='b000; `DELAY
      `print; `check_eq('b10011011,result);
      a='b11101101;b='b10010010;cmd='b000; `DELAY
      `print; `check_eq('b01111111,result);
      a='b00110000;b='b01100100;cmd='b001; `DELAY
      `print; `check_eq('b11001100,result);
      a='b01101101;b='b10111010;cmd='b001; `DELAY
      `print; `check_eq('b10110011,result);
      a='b10000100;b='b00010111;cmd='b001; `DELAY
      `print; `check_eq('b01101101,result);
      a='b10111100;b='b10010010;cmd='b001; `DELAY
      `print; `check_eq('b00101010,result);
      a='b11000011;b='b10100101;cmd='b010; `DELAY
      `print;`check_eq('b01100110,result);
      a='b11000110;b='b00100101;cmd='b011; `DELAY
      `print; `check_eq('b00000001,result);
      a='b01000000;b='b00111111;cmd='b011; `DELAY
      `print; `check_eq('b00000000,result);
      a='b11111111;b='b01111111;cmd='b011; `DELAY
      `print; `check_eq('b00000001,result);
      a='b11101111;b='b11110111;cmd='b011; `DELAY
      `print; `check_eq('b00000001,result);
      a='b10101010;b='b11001100;cmd='b100; `DELAY
      `print; `check_eq('b10001000,result);
      a='b01101001;b='b01010101;cmd='b101; `DELAY
      `print; `check_eq('b10111110,result);
      a='b00001111;b='b11001100;cmd='b110; `DELAY
      `print; `check_eq('b00110000,result);
      a='b10000111;b='b01100110;cmd='b111; `DELAY
      `print; `check_eq('b11100111,result);
      $finish();
    end
endmodule
