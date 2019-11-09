/* Tests a 32-bit version of the ALU.
 *
 * See also: alu8bit.v
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`timescale 1 ns / 1 ps

`include "ALU/util.v"
`include "ALU/alu.v"

// print results of each test in table form
`define VERBOSE 0

// delay before printing, after setting values
`define DELAY #4000

module testalu();
    // inputs
    reg[2:0] cmd;
    reg[31:0] a;
    reg[31:0] b;

    // outputs
    wire[31:0] result;
    wire carryout, zero, overflow;

    ALU #(.WIDTH(32)) test_alu (
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
      `define print `ifdef VERBOSE $display("%b | %b %b | %b | %b%b%b", cmd, a, b, result, carryout, overflow, zero) `endif
      `ifdef VERBOSE
      $display("cmd | a                                b                                | R                                | COZ");
      `endif
      $display("Testing Addition");
      a=32'b01100101001011001010101001111010;b=32'b00000000000000000000000000000010;cmd=3'b000; `DELAY
      `print; `check_eq(32'b01100101001011001010101001111100,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111010100010101011101010101010;b=32'b11100101101010001110010111010010;cmd=3'b000; `DELAY
      `print; `check_eq(32'b11100000001100111010000001111100,result);`check_eq(1'b1,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b01111111111111111111111111111111;b=32'b00000000000111111111110000000000;cmd=3'b000; `DELAY
      `print; `check_eq(32'b10000000000111111111101111111111,result);`check_eq(1'b0,carryout); `check_eq(1'b1,overflow); `check_eq(1'b0,zero);
      a=32'b11101001010100101011010101111101;b=32'b10011011010101010101010010110010;cmd=3'b000; `DELAY
      `print; `check_eq(32'b10000100101010000000101000101111,result);`check_eq(1'b1,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b00000000000000000000000101010110;b=32'b11111111111111111111111110111011;cmd=3'b000; `DELAY
      `print; `check_eq(32'b00000000000000000000000100010001,result);`check_eq(1'b1,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b000;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b00000000000000000000000000000000;b=32'b00000000000000000000000000000001;cmd=3'b000;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000001,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      $display("Testing Subtraction");
      a=32'b00000000001111111111000000000000;b=32'b01100001000110001110001010110100;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b10011111001001110000110101001100,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b01101001101010110101011101011101;b=32'b10111010010100001110001010101010;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b10101111010110100111010010110011,result);`check_eq(1'b0,carryout); `check_eq(1'b1,overflow); `check_eq(1'b0,zero);
      a=32'b10001010101010011100101101000100;b=32'b00011010011001010101101010000111;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b01110000010001000111000010111101,result);`check_eq(1'b1,carryout); `check_eq(1'b1,overflow); `check_eq(1'b0,zero);
      a=32'b10111100010101010010101010101100;b=32'b10010010010010010010010010010010;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b00101010000011000000011000011010,result);`check_eq(1'b1,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b1,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b00000000000000000000000000000000;b=32'b11111111111111111111111111111111;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000001,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b10100110100101100111111100001101;b=32'b10100110100101100111111100001101;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result);`check_eq(1'b1,carryout); `check_eq(1'b0,overflow); `check_eq(1'b1,zero);
      a=32'b00000000000000000000000000000000;b=32'b00000000000000000000000000000001;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b1,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b11111111111111111111111111111111;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result); `check_eq(1'b1,carryout); `check_eq(1'b0,overflow); `check_eq(1'b1,zero);
      a=32'b01111111111111111111111111111111;b=32'b11111111111111111111111111111111;cmd=3'b001;  `DELAY
      `print; `check_eq(32'b10000000000000000000000000000000,result); `check_eq(1'b0,carryout); `check_eq(1'b1,overflow); `check_eq(1'b0,zero);
      $display("Testing XOR");
      a=32'b01101110000011011001110011001101;b=32'b00011010011001010101101010000111;cmd=3'b010;  `DELAY
      `print; `check_eq(32'b01110100011010001100011001001010,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b10111100010101010010101010101100;b=32'b10010010010010010010010010010010;cmd=3'b010;  `DELAY
      `print; `check_eq(32'b00101110000111000000111000111110,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b11111111111111111111111111111111;cmd=3'b010;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b010;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      $display("Testing SLT");
      a=32'b00000000000000000000000000000000;b=32'b11111111111111111111111111111111;cmd=3'b011;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b011;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000001,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b11111111111111111111111111111111;cmd=3'b011;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111010100010101011101010101010;b=32'b11100101101010001110010111010010;cmd=3'b011; `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b10001010101010011100101101000100;b=32'b00011010011001010101101010000111;cmd=3'b011;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000001,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111101010;b=32'b00000000000000000000000000101011;cmd=3'b011;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000001,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b00000000000000000000010010011011;b=32'b00000000000000000000000000001100;cmd=3'b011;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b00000000000000000000100100010010;b=32'b11111111111111111010000011111110;cmd=3'b011;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111011011101110;b=32'b00000000000000000000000000000001;cmd=3'b011;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000001,result);`check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      $display("Testing AND");
      a=32'b01101110000011011001110011001101;b=32'b00011010011001010101101010000111;cmd=3'b100;  `DELAY
      `print; `check_eq(32'b00001010000001010001100010000101,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b10111100010101010010101010101100;b=32'b10010010010010010010010010010010;cmd=3'b100;  `DELAY
      `print; `check_eq(32'b10010000010000010010000010000000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b11111111111111111111111111111111;cmd=3'b100;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b100;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      $display("Testing NAND");
      a=32'b01101110000011011001110011001101;b=32'b00011010011001010101101010000111;cmd=3'b101;  `DELAY
      `print; `check_eq(32'b11110101111110101110011101111010,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b10111100010101010010101010101100;b=32'b10010010010010010010010010010010;cmd=3'b101;  `DELAY
      `print; `check_eq(32'b01101111101111101101111101111111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b11111111111111111111111111111111;cmd=3'b101;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b101;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      $display("Testing NOR");
      a=32'b01101110000011011001110011001101;b=32'b00011010011001010101101010000111;cmd=3'b110;  `DELAY
      `print; `check_eq(32'b10000001100100100010000100110000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b10111100010101010010101010101100;b=32'b10010010010010010010010010010010;cmd=3'b110;  `DELAY
      `print; `check_eq(32'b01000001101000101101000101000001,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b11111111111111111111111111111111;cmd=3'b110;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b110;  `DELAY
      `print; `check_eq(32'b00000000000000000000000000000000,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      $display("Testing OR");
      a=32'b01101110000011011001110011001101;b=32'b00011010011001010101101010000111;cmd=3'b111;  `DELAY
      `print; `check_eq(32'b01111110011011011101111011001111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b10111100010101010010101010101100;b=32'b10010010010010010010010010010010;cmd=3'b111;  `DELAY
      `print; `check_eq(32'b10111110010111010010111010111110,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b11111111111111111111111111111111;cmd=3'b111;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      a=32'b11111111111111111111111111111111;b=32'b00000000000000000000000000000000;cmd=3'b111;  `DELAY
      `print; `check_eq(32'b11111111111111111111111111111111,result); `check_eq(1'b0,carryout); `check_eq(1'b0,overflow); `check_eq(1'b0,zero);
      $finish();
    end
endmodule
