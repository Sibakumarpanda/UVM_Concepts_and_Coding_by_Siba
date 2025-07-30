//Command line Processor Methods :Example1:

`include "uvm_macros.svh"
import uvm_pkg::*;
class my_test extends uvm_test;
  uvm_cmdline_processor clp;
  bit [31:0] addr;
  string clp_addr_str;
  string clp_pattern_str;
  string pattern;
  `uvm_component_utils(my_test)
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    clp = uvm_cmdline_processor::get_inst();
    addr = clp.get_arg_value("+ADDR=", clp_addr_str) ? clp_addr_str.atohex(): 32'hF;
    pattern = clp.get_arg_value("+PATTERN=", clp_pattern_str) ? clp_pattern_str: "Hello";
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_full_name(), $sformatf("addr = %0h, pattern = %s", addr, pattern), UVM_LOW)
  endfunction
endclass :my_test

//tb_top module
module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule :tb_top

NOTE- For this example we need to use “Run Options” while running the code.
      In EDA Playground , left hand side bar , we can use in run options as : -access +rw +ADDR=AA +PATTERN=World
  
//LogFile Ouput using Cadence Xcelium Tool
  
[2025-07-30 02:26:17 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' '+ADDR=AA' '+PATTERN=World' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 29, 2025 at 22:26:18 EDT
xrun: 23.09-s001: (c) Copyright 1995-2023 Cadence Design Systems, Inc.
	Top level design units:
		uvm_pkg
		$unit_0x4ccdf83b
		tb_top
Loading snapshot worklib.tb_top:sv .................... Done
SVSEED default: 1
xcelium> source /xcelium23.09/tools/xcelium/files/xmsimrc
xcelium> source /xcelium23.09/tools//methodology/UVM/CDNS-1.2/sv/files/tcl/uvm_sim.tcl
xcelium> run
UVM_INFO /xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_root.svh(412) @ 0: reporter [UVM/RELNOTES] 
----------------------------------------------------------------
CDNS-UVM-1.2 (23.09-s001)
(C) 2007-2014 Mentor Graphics Corporation
(C) 2007-2014 Cadence Design Systems, Inc.
(C) 2006-2014 Synopsys, Inc.
(C) 2011-2013 Cypress Semiconductor Corp.
(C) 2013-2014 NVIDIA Corporation
----------------------------------------------------------------

  ***********       IMPORTANT RELEASE NOTES         ************

  You are using a version of the UVM library that has been compiled
  with `UVM_NO_DEPRECATED undefined.
  See http://www.eda.org/svdb/view.php?id=3313 for more details.

  You are using a version of the UVM library that has been compiled
  with `UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR undefined.
  See http://www.eda.org/svdb/view.php?id=3770 for more details.

      (Specify +UVM_NO_RELNOTES to turn off this notice)

UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO testbench.sv(25) @ 0: uvm_test_top [uvm_test_top] addr = aa, pattern = World
UVM_INFO /xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    3
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1
[uvm_test_top]     1

Simulation complete via $finish(1) at time 0 FS + 231
/xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_root.svh:543     $finish;
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 29, 2025 at 22:26:23 EDT  (total: 00:00:05)
Done  
