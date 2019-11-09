//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

`include "Regfile/regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire  	endtest;    	// Set High to signal test completion
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Variables
  integer i; // looping variable

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1:
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1 Failed");
  end

  // Test Case 2:
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  //   (Fails with example register file, but should pass with yours)
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
    dutpassed = 0;
    $display("Test Case 2 Failed");
  end

  // ---------------------------------------------------------------------------
  // The following test cases test if the Enable is broken/ignored
  // ---------------------------------------------------------------------------

  // Test Case 3:
  //    Write '1' to all of the registers with RegWrite set to '1' and then write
  //    '20' to all the registers with RegWrite set to '0' and check if any of
  //    them are not '1' after doing so.
  for (i = 1; i < 32; i = i + 1) begin
    WriteRegister = i;
    WriteData = 32'd1;
    RegWrite = 1;
    ReadRegister1 = i;
    ReadRegister2 = i;
    #5 Clk=1; #5 Clk=0;
  end

  for (i = 1;i < 32; i = i + 1) begin
    WriteRegister = i;
    WriteData = 32'd20;
    RegWrite = 0;
    ReadRegister1 = i;
    ReadRegister2 = i;
    #5 Clk=1; #5 Clk=0;

    if((ReadData1 !== 1) || (ReadData2 !== 1)) begin
      dutpassed = 0;
      $display("Test Case 3 Failed");
    end
  end

  // ---------------------------------------------------------------------------
  // The following test for a broken decoder, where all registers are written to.
  // ---------------------------------------------------------------------------

  // Test Case 4:
  //    Writes '443' to register 1 and '648' to register 2 and makes sure
  //    register 1 still reads '443'.
  WriteRegister = 5'd1;
  WriteData = 32'd443;
  RegWrite = 1;
  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0;

  WriteRegister = 5'd2;
  WriteData = 32'd648;
  RegWrite = 1;
  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 443) || (ReadData2 !== 443)) begin
    dutpassed = 0;
    $display("Test Case 4 Failed");
  end

  // ---------------------------------------------------------------------------
  // The following tests for register zero acting as a regular register.
  // ---------------------------------------------------------------------------

  // Test Case 5:
  //    Writes '342' to register zero and verifys that it is still 32'0 using
  //    ReadData1 and ReadData2.
  WriteRegister = 5'd0;
  WriteData = 32'd342;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 0) || (ReadData2 !== 0)) begin
    dutpassed = 0;
    $display("Test Case 5 Failed");
  end

  // ---------------------------------------------------------------------------
  // The following tests for port 2 being broken and always reading register 14.
  // ---------------------------------------------------------------------------

  // Test Case 6:
  //    Writes the register index to each register and then reads each register
  //    expecting to see the index. If it does not, then the test has failed.
  for (i = 0; i < 32; i = i + 1) begin
    WriteRegister = i;
    WriteData = i;
    RegWrite = 1;
    ReadRegister1 = i;
    ReadRegister2 = i;
    #5 Clk=1; #5 Clk=0;
  end

  for (i = 0;i < 32; i = i + 1) begin
    ReadRegister1 = i;
    ReadRegister2 = i;

    if((ReadData1 !== i) || (ReadData2 !== i)) begin
      dutpassed = 0;
      $display("Test Case 6 Failed");
    end
  end

  // ---------------------------------------------------------------------------
  // More test cases.
  // ---------------------------------------------------------------------------

  // Test Case 7:
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  WriteRegister = 5'd31;
  WriteData = 32'd1;
  RegWrite = 1;
  ReadRegister1 = 5'd31;
  ReadRegister2 = 5'd31;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 !== 1) || (ReadData2 !== 1)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 7 Failed");
  end

  // ---------------------------------------------------------------------------
  // Detects perfect register
  // ---------------------------------------------------------------------------

  // Top level report of working register. Checks the end state of the dutpassed
  // flag after all tests are run.
  if (dutpassed !== 1) begin
    $display("\nREGISTER FILE FAILED\n");
  end
  else begin
    $display("\nREGISTER FILE PASSED\n");
  end

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
