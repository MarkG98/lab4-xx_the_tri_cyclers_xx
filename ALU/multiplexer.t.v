// Multiplexer testbench
`timescale 1 ns / 1 ps
`include "util.v"
`include "ALU/multiplexer.v"

`define DELAY #1000

module testMultiplexer();

  wire out;  // test output
  reg A0, A1, I0, I1, I2, I3;  // test inputs

  // behavioralMultiplexer multiplexer (out, A0, A1, I0, I1, I2, I3);
  structuralMultiplexer multiplexer (out, A0, A1, I0, I1, I2, I3);

  initial begin
    $dumpfile("multiplexer-dump.vcd");
    $dumpvars();
    // Test pattern stimulus
    $display("Time    | A0 A1 | I0 I1 I2 I3 | Out");
    $display("--------|-------|-------------|----");
    `define print $display("%6t | %b  %b  | %b  %b  %b  %b  | %b", $time, A0, A1, I0, I1, I2, I3, out)
    // $monitor("%6t | %b  %b  | %b  %b  %b  %b  | %b", $time, A0, A1, I0, I1, I2, I3, out);

    // input 0
    A0=0; A1=0; I0=0; I1=0; I2=0; I3=0; `DELAY  // selected input low
    `print;
    `check_eq(0, out);
    A0=0; A1=0; I0=1; I1=0; I2=0; I3=0; `DELAY  // selected input high
    `print;
    `check_eq(1, out);
    A0=0; A1=0; I0=0; I1=1; I2=1; I3=1; `DELAY  // raise all other inputs
    `print;
    `check_eq(0, out);
    // input 1
    A0=1; A1=0; I0=0; I1=0; I2=0; I3=0; `DELAY
    `print;
    `check_eq(0, out);
    A0=1; A1=0; I0=0; I1=1; I2=0; I3=0; `DELAY
    `print;
    `check_eq(1, out);
    // input 2
    A0=0; A1=1; I0=0; I1=0; I2=0; I3=0; `DELAY
    `print;
    `check_eq(0, out);
    A0=0; A1=1; I0=0; I1=0; I2=1; I3=0; `DELAY
    `print;
    `check_eq(1, out);
    // input 3
    A0=1; A1=1; I0=0; I1=0; I2=0; I3=0; `DELAY
    `print;
    `check_eq(0, out);
    A0=1; A1=1; I0=0; I1=0; I2=0; I3=1; `DELAY
    `print;
    `check_eq(1, out);
    $finish();	// End simulation
  end

endmodule
