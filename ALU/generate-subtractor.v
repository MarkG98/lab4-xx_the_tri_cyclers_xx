/* A partial adder-subtractor to demonstate the `generate` block.
 *
 * Nathan Estill, Mark Goldwater, and Evan New-Schmidt
 * Olin Computer Architecture, Fall 2019
 */

`include "ALU/util.v"
`include "ALU/bitsubtractor.v"


module subtractor
#(parameter WIDTH=4)
(
    output[WIDTH-1:0] sum,
    output carryout,
    output overflow,
    input[WIDTH-1:0] a,
    input[WIDTH-1:0] b,
    input subtract
);
    wire gnd = 0;
    or overflow_patch(overflow, gnd, gnd);


    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1)
        begin:gen
            wire _cout;  // links carryout to carryin
            if (i == 0) begin
                // first
                bitSubtractor subt(
                    .sum(sum[i]),
                    .carryout(_cout),
                    .a(a[i]),
                    .b(b[i]),
                    .carryin(subtract),  // take carryin from input
                    .subtract(subtract)
                );
            end else if (i == WIDTH - 1) begin
                // last
                bitSubtractor subt(
                    .sum(sum[i]),
                    .carryout(carryout),  // send carryout to output
                    .a(a[i]),
                    .b(b[i]),
                    .carryin(gen[i-1]._cout),
                    .subtract(subtract)
                );
            end else begin
                // everything else
                bitSubtractor subt(
                    .sum(sum[i]),
                    .carryout(_cout),
                    .a(a[i]),
                    .b(b[i]),
                    .carryin(gen[i-1]._cout),
                    .subtract(subtract)
                );
            end
        end
    endgenerate
endmodule
