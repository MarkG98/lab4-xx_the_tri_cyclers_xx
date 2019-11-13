// test bench for sign extend16to32
`timescale 1 ns / 1 ps
`include "signExtend.v"



module testSignExtend16to32 ();
    // inputs
    reg[15:0] extendee;

    // outputs
    wire[29:0] results;

    signExtend #(30) SE (
      .signExtended(results),
      .extendee(extendee)
    );

    initial begin

    `define print $display("%b | %b", extendee, results)
    $display("Imm16            | Extended Imm16");
    extendee=16'b1111111111111111; # 10
    `print;
    extendee=16'b0111010010001011; # 10
    `print;
    extendee=16'b1000111111111111; # 10
    `print;
    extendee=16'b1110001001001110; # 10
    `print;
    extendee=16'b0000110011100101; # 10
    `print;
    extendee=16'b0011111001010011; # 10
    `print;
    extendee=16'b1110000110010110; # 10
    `print;
    extendee=16'b1000011010101010; # 10
    `print;
    extendee=16'b0000001001110010; # 10
    `print;
    end
endmodule // testSignExtend16to32
