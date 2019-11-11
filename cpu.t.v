`include "cpu.v"

module cpuTest ();
  reg clk;

  cpu CPU(.clk(clk));

  reg init_data = 0;

  reg signed [31:0] temp;

  integer f,f1,i;

  initial begin
    // Put text dump (hex) into the first parameter in the below function
    $readmemh("asmtests/addiANDsw", CPU.sysmem.mem, 0);
    if (init_data) begin
    // Put the data dump (hex) into the first parameter in the below function
      $readmemh("asmtests", CPU.sysmem.mem, 2048);
    end

    $dumpfile("cpu.vcd");
    $dumpvars();

    clk = 0; # 5
    repeat(4) begin
      clk = 1; #10 clk = 0; # 10;
    end
    # 2000 $finish();


    f = $fopen("datamem.csv","w");
      for (i = 0; i<4096; i=i+1) begin
        temp <= CPU.sysmem.mem[i]; # 5
        $fwrite(f,"%d,\n", temp);
      end
    $fclose(f);

    f1 = $fopen("regmem.csv","w");
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[1]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[2]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[3]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[4]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[5]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[6]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[7]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[8]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[9]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[10]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[11]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[12]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[13]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[14]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[15]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[16]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[17]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[18]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[19]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[20]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[21]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[22]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[23]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[24]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[25]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[26]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[27]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[28]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[29]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[30]._reg_out); # 5
        $fwrite(f1,"%d,\n", CPU.registerFile.genblock[31]._reg_out); # 5
    $fclose(f1);

  end

endmodule //cpuTest
