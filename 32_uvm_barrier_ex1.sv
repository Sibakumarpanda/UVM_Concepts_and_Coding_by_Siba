Example1: A basic uvm_barrier example with set_threshold method :
-In the below examples, the process task has two arguments string name and p_delay.
-The name argument denotes process name and p_delay indicates delay time taken by the process to complete. Total 10 processes are forked with different execution delay time.
-The processes will wait till the threshold being reached which is set by the set_threshold method to proceed further as demonstrated below

`include "uvm_macros.svh"
import uvm_pkg::*;

module barrier_example();
  uvm_barrier br;
  
  task automatic process(string name, int p_delay);
    $display("@%0t: Process %s started", $time, name);
    #p_delay;
    $display("@%0t: Process %s completed", $time, name);
    br.wait_for();
    $display("@%0t: Process %s wait_for is unblocked", $time, name);    
  endtask
  
  initial begin
    br = new("br");
    br.set_threshold(4);
    fork
      process("A", 5);
      process("B", 10);
      process("C", 20);
      process("D", 25);
      
      process("E", 30);
      process("F", 40);
      process("G", 50);
      process("H", 55);
      
      process("I", 60);
      process("J", 70);
    join
  end
endmodule
  
//LogFile Output using Cadence Xcelium Tool
  [2025-07-24 06:44:32 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 24, 2025 at 02:44:33 EDT
xrun: 23.09-s001: (c) Copyright 1995-2023 Cadence Design Systems, Inc.
	Top level design units:
		uvm_pkg
		$unit_0x4ccdf83b
		barrier_example
Loading snapshot worklib.barrier_example:sv .................... Done
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

@0: Process A started
@0: Process B started
@0: Process C started
@0: Process D started
@0: Process E started
@0: Process F started
@0: Process G started
@0: Process H started
@0: Process I started
@0: Process J started
@5: Process A completed
@10: Process B completed
@20: Process C completed
@25: Process D completed
@25: Process A wait_for is unblocked
@25: Process B wait_for is unblocked
@25: Process C wait_for is unblocked
@25: Process D wait_for is unblocked
@30: Process E completed
@40: Process F completed
@50: Process G completed
@55: Process H completed
@55: Process E wait_for is unblocked
@55: Process F wait_for is unblocked
@55: Process G wait_for is unblocked
@55: Process H wait_for is unblocked
@60: Process I completed
@70: Process J completed
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 24, 2025 at 02:44:42 EDT  (total: 00:00:09)
Done
