Example2: reset, get_threshold and get_num_waiters methods example:
-------------------------------------------------------------------------
-The set_threshold sets value as 4.
-The get_threshold and get_num_waiters methods are called when 
  The threshold is not reached.
  After reset method call
  After the threshold has reached.
-The get_threshold returns threshold value irrespective of reset and threshold reached or not. 
-The get_num_waiters show the number of processes currently waiting at the barrier. 
-In the first case, three processes are waiting at the barrier. 
-In the second case (after reset is applied), waiting at barrier processes count is reset to zero. 
-In the third case, since the threshold has reached, waiting at barrier processes count is reset to zero as set_auto_reset is turned on by default.

//Code example
`include "uvm_macros.svh"
import uvm_pkg::*;

module barrier_example2();
  uvm_barrier br;
  
  task automatic process(string name, int p_delay);
    $display("@%0t: Process %s started", $time, name);
    #p_delay;
    $display("@%0t: Process %s completed", $time, name);
    br.wait_for();
    $display("@%0t: Process %s wait_for is unblocked", $time, name);    
  endtask

  task print(int delay);
    #delay;
    $display("@%0t: threshold value for the barrier = %0d and number of waiters = %0d", $time, br.get_threshold(), br.get_num_waiters());
  endtask
  
  initial begin
    br = new("br");
    br.set_threshold(4);
    fork
      process("A", 5);
      process("B", 10);
      process("C", 20);
      print(22);
      process("D", 25);
      
      process("E", 30);
      process("F", 40);
      begin 
        #40;
        br.reset();
        $display("After reset");
      end
      print(40);
      
      process("G", 50);
      process("H", 55);
      process("I", 60);
      process("J", 70);
      begin 
        #70;
        $display("After threshold is reached");
      end
      print(73);
      
      process("K", 75);
      process("L", 80);
    join
  end
endmodule :barrier_example2

//Logfile Output using Cadence Xcelium Tool
 [2025-07-28 05:53:40 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 28, 2025 at 01:53:41 EDT
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
@0: Process K started
@0: Process L started
@5: Process A completed
@10: Process B completed
@20: Process C completed
@22: threshold value for the barrier = 4 and number of waiters = 3
@25: Process D completed
@25: Process A wait_for is unblocked
@25: Process B wait_for is unblocked
@25: Process C wait_for is unblocked
@25: Process D wait_for is unblocked
@30: Process E completed
@40: Process F completed
After reset
@40: threshold value for the barrier = 4 and number of waiters = 0
@40: Process E wait_for is unblocked
@40: Process F wait_for is unblocked
@50: Process G completed
@55: Process H completed
@60: Process I completed
@70: Process J completed
After threshold is reached
@70: Process G wait_for is unblocked
@70: Process H wait_for is unblocked
@70: Process I wait_for is unblocked
@70: Process J wait_for is unblocked
@73: threshold value for the barrier = 4 and number of waiters = 0
@75: Process K completed
@80: Process L completed
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 28, 2025 at 01:53:50 EDT  (total: 00:00:09)
Done 
