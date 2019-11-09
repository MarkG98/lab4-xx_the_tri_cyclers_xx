// utilites for multiple files
`ifndef _util_h_
`define _util_h_

// delayed gate primitives
`define NOT not
`define NAND nand
`define AND and
`define NOR nor
`define OR or
`define XOR xor

// non-breaking assertions

// Check if a value/expression is true
`define check(expr) \
    if (!(expr)) $display("WARNING: check '%s' failed.", "expr")

// Check if two values are equal
`define check_eq(exp, test) \
    if (!(exp == test)) $display("WARNING: equality check failed for %s.\n\tEXPECTED:\t%b\n\tGOT:\t\t%b", "exp == test", exp, test)

`endif
