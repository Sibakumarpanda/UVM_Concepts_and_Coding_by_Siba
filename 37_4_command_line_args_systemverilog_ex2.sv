//System functions for command line arguments in SystemVerilog, Example2:

module cmd_line_args_example;
  bit [31:0] addr_1, addr_2;
  string pattern;
 
  initial begin
    // +ADDR argument uses $test$plusargs and $value$plusargs
    if($test$plusargs("ADDR="))
      void'($value$plusargs("ADDR=%0h", addr_1));
    else
      addr_1 = 'hF;
    
    if($test$plusargs("PATTERN="))
      void'($value$plusargs("PATTERN=%s", pattern));
    else
      pattern = "Hello";
    
    $display("address = %0h, pattern = %s", addr_1, pattern);
    
    if($test$plusargs("ENABLE"))
      $display("You have successfully received ENABLE as argument");
    
    // +ADDR argument uses $value$plusargs only
    if($value$plusargs("ADDR=%0h", addr_2))
      $display("You have successfully received %0h value for ADDR argument", addr_2);
  end
endmodule :cmd_line_args_example

NOTE:
-For the above example , while running we need to pass the run options. 
-In EDA playground , in left hand bar section we can use the run option as : -access +rw +ADDR=AA +PATTERN=World +ENABLE  
  
//LogFile output using Cadence Xcelium Tool

[2025-07-30 02:41:48 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' '+ADDR=AA' '+PATTERN=World' '+ENABLE' design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 29, 2025 at 22:41:49 EDT
xrun: 23.09-s001: (c) Copyright 1995-2023 Cadence Design Systems, Inc.
	Top level design units:
		cmd_line_args_ex
Loading snapshot worklib.cmd_line_args_ex:sv .................... Done
xcelium> source /xcelium23.09/tools/xcelium/files/xmsimrc
xcelium> run
address = aa, pattern = World
You have successfully received ENABLE as argument
You have successfully received aa value for ADDR argument
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 29, 2025 at 22:41:50 EDT  (total: 00:00:01)
Done
