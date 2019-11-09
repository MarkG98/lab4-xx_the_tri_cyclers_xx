// Multiplexer circuit

`include "ALU/util.v"

module behavioralMultiplexer
(
    output out,
    input address0, address1,
    input in0, in1, in2, in3
);
    // Join single-bit inputs into a bus, use address as index
    wire[3:0] inputs = {in3, in2, in1, in0};
    wire[1:0] address = {address1, address0};
    assign out = inputs[address];
endmodule

module twoBitMultiplexer
(
    output out,
    input address,
    input in0, in1
);
    wire i0_select, i1_select;
    wire address_not;
    `NOT select_not_g(address_not, address);
    `AND i0_and_g(i0_select, in0, address_not);
    `AND i1_and_g(i1_select, in1, address);
    `OR or_g(out, i0_select, i1_select);
endmodule

module structuralMultiplexer
(
    output out,
    input address0, address1,
    input in0, in1, in2, in3
);
    wire sub_0, sub_1;
    twoBitMultiplexer m0(sub_0, address0, in0, in1);
    twoBitMultiplexer m1(sub_1, address0, in2, in3);

    twoBitMultiplexer m2(out, address1, sub_0, sub_1);  // multiplexer of multiplexers
endmodule
