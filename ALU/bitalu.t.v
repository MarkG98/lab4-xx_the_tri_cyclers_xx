// Adder testbench
`include "bitalu.v"

module testbitalu();
    reg a, b, carryin;
    reg[2:0] s;
    wire result,carryout;

    bitalu alubitter (result,carryout, a, b, carryin,s);


    initial begin
      $dumpfile("alu-dump.vcd");
      $dumpvars();
      $display("a b |  S  | C | O C | E");
      a=1;b=1;carryin=0;s[2]=0;s[1]=0;s[0]=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 0", a, b, s[2],s[1],s[0], carryin, result, carryout);
      a=0;b=1;carryin=1;s[2]=0;s[1]=0;s[0]=1; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], carryin, result, carryout);
      a=1;b=0;carryin=0;s[2]=0;s[1]=1;s[0]=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], carryin, result, carryout);
      a=1;b=0;carryin=0;s[2]=0;s[1]=1;s[0]=1; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 0",1a, b, s[2],s[1],s[0], carryin, result, carryout);
      a=1;b=1;carryin=0;s[2]=1;s[1]=0;s[0]=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], carryin, result, carryout);
      a=0;b=1;carryin=0;s[2]=1;s[1]=0;s[0]=1; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], carryin, result, carryout);
      a=0;b=0;carryin=0;s[2]=1;s[1]=1;s[0]=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], carryin, result, carryout);
      a=1;b=0;carryin=0;s[2]=1;s[1]=1;s[0]=1; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], carryin, result, carryout);
      $finish();
    end
endmodule
