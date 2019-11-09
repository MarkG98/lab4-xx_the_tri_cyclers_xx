/* Implementation of a 32-bit ALU that supports a subset of the MIPS standard.
 *
 * | Op   | Command |
 * |------|---------|
 * | ADD  | `b000`  |
 * | SUB  | `b001`  |
 * | XOR  | `b010`  |
 * | SLT  | `b011`  |
 * | AND  | `b100`  |
 * | NAND | `b101`  |
 * | NOR  | `b110`  |
 * | OR   | `b111`  |
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`include "ALU/util.v"
`include "ALU/bitalu.v"
`include "ALU/nors.v"

// Module for detecting overflow in a adder/subtractor
module overflowDetector
(
    output overflow,  // sum most-significant bit
    input a_msb,  // a input most-significant bit
    input b_msb,  // b input most-significant bit
    input sum_msb,  // sum most-significant bit
    input subtract  // operation is a subtract
);
    // overflow detection for addition is NOT(XOR(a[3], b[3])) AND XOR(a[3], s[3])
    wire ab_xor;
    wire ab_nxor;
    wire as_xor;

    wire corrected_b;
    `XOR b_corrector(corrected_b, b_msb, subtract);

    // NOT(XOR(A, B))
    `XOR ab_xor_g(ab_xor, a_msb, corrected_b);
    `NOT ab_nxor_g(ab_nxor, ab_xor);
    // XOR(B, S)
    `XOR as_xor_g(as_xor, a_msb, sum_msb);
    // combine with and
    `AND and_g(overflow, ab_nxor, as_xor);
endmodule

// Set less-than module for chained adders/subtractors
module SLT
(
    output slt,
    input overflow,
    input sum_msb
);
    `XOR xor_g(slt, overflow, sum_msb);
endmodule

// Determines if the result of ADD or SUB operation is zero
module zeroDetector
#(parameter WIDTH=8)
(
    output zero,
    input[WIDTH:0] inputs
);
    genvar i;
    generate
        for (i=1; i<WIDTH; i=i*2) begin:layer

        end
    endgenerate
endmodule

// Silences flags if the ALU is not in ADD or SUB mode
module flagGuard
(
  output c1NORc2ANDflag,
  input c1,
  input c2,
  input flag
);

  wire c1NORc2;

  `NOR c1NORc2Gate(c1NORc2,c1,c2);
  `AND c1NORc2ANDflagGate(c1NORc2ANDflag,c1NORc2,flag);

endmodule

// Top level ALU module
module ALU
#(parameter WIDTH=32)
(
    output[WIDTH-1:0]  result,
    output        carryout,
    output        zero,
    output        overflow,
    input[WIDTH-1:0]   operandA,
    input[WIDTH-1:0]   operandB,
    input[2:0]    command
);
    wire overflow_wire, slt_wire, zero_wire, carryout_wire;
    wire flag_guard_wire;
    wire MSBsub;


    wire subtract_sig = command[0];
    wire slt_out;

    // fill in the inner ALU slices
    genvar i;
    generate
        overflowDetector odetector(
            .overflow(overflow_wire),
            .a_msb(operandA[WIDTH-1]),
            .b_msb(operandB[WIDTH-1]),
            .sum_msb(MSBsub),
            .subtract(subtract_sig)
        );
        // Determine if in add or subtract mode and block overflow if not
        flagGuard flag_guard_overflow(overflow,command[2],command[1],overflow_wire);

        // Calculate SLT output
        SLT slt_detector(slt_out, overflow_wire, MSBsub);


        // WARNING: this isn't fully parameterized
        if (WIDTH == 32) begin
          // Calculate zero flag and apply flag guard (32-bit)
          nor32 zero_detector(zero_wire, result);
        end
        else if (WIDTH  == 8) begin
          // Calculate zero flag and apply flag guard (8-bit)
          nor8 zero_detector(zero_wire, result);
        end
        flagGuard flag_guard_zero(zero,command[2],command[1],zero_wire);

        for (i = 0; i < WIDTH; i = i+1)
        begin:gen
            wire _cout;
            wire _subout;


            // generate all ALU slices
            if (i == 0) begin
                // first (LSB)
                bitalu slice(
                    .result(result[i]),
                    .carryout(_cout),
                    .addsubout(_subout),
                    .a(operandA[i]),
                    .b(operandB[i]),
                    .carryin(subtract_sig),  // set carryin for first slice to subtract line (used to invert the second value)
                    .s(command),
                    .sltout(slt_out)
                );
            end else if (i == WIDTH - 1) begin
                // last (MSB)
                bitalu slice(
                    .result(result[i]),
                    .carryout(carryout_wire),
                    .addsubout(MSBsub),  // hook last carryout to ALU carryout
                    .a(operandA[i]),
                    .b(operandB[i]),
                    .carryin(gen[i - 1]._cout),
                    .s(command),
                    .sltout(1'b0)
                );
            end else begin
                // everything else
                bitalu slice(
                    .result(result[i]),
                    .carryout(_cout),
                    .addsubout(_subout),
                    .a(operandA[i]),
                    .b(operandB[i]),
                    .carryin(gen[i - 1]._cout),
                    .s(command),
                    .sltout(1'b0)
                );
            end
        end
    endgenerate
    // Apply flag guard to carryout
    flagGuard flag_guard_carryout(carryout,command[2],command[1],carryout_wire);
endmodule
