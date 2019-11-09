// Adder testbench
`include "ALU/bitalulsb.v"

module testbitalu();
    reg a, b, carryin,sltout;
    reg[2:0] s;
    wire result,carryout;

    bitalulsb alubitter (result,carryout, a, b, s, sltout);


    initial begin
      $dumpfile("alu-dump.vcd");
      $dumpvars();
      $display("a b |  S  |SL | O C | E");
      a=1;b=1;s[2]=0;s[1]=0;s[0]=0;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 0", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=0;b=1;s[2]=0;s[1]=0;s[0]=0;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=1;b=0;s[2]=0;s[1]=0;s[0]=0;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=0;b=0;s[2]=0;s[1]=0;s[0]=0;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 0", a, b, s[2],s[1],s[0], sltout, result, carryout);

      a=0;b=1;s[2]=0;s[1]=0;s[0]=1;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=1;b=0;s[2]=0;s[1]=0;s[0]=1;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=1;b=1;s[2]=0;s[1]=0;s[0]=1;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=0;b=0;s[2]=0;s[1]=0;s[0]=1;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);

      a=1;b=0;s[2]=0;s[1]=1;s[0]=0;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=0;b=0;s[2]=0;s[1]=1;s[0]=1;sltout=1; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=1;b=1;s[2]=1;s[1]=0;s[0]=0;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=0;b=1;s[2]=1;s[1]=0;s[0]=1;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=0;b=0;s[2]=1;s[1]=1;s[0]=0;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      a=1;b=0;s[2]=1;s[1]=1;s[0]=1;sltout=0; #1000
      $display("%b %b | %b%b%b | %b | %b %b | 1", a, b, s[2],s[1],s[0], sltout, result, carryout);
      $finish();
    end
endmodule
