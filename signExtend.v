module signExtend
#(parameter WIDTH=32)
(
    output[WIDTH-1:0] signExtended,
    input [15:0] extendee
);

assign signExtended = { {WIDTH-16{extendee[15]}}, extendee};

endmodule
