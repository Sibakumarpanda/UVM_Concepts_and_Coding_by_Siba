Example4: set_auto_reset method example
-------------------------------------------
-The set_auto_reset method is turned off by passing the value argument as 0. 
-Once the threshold is reached, the number of waiters is 0 and no further processes are blocked until it is reset at 50-time units.
//Code example:
`include "uvm_macros.svh"
import uvm_pkg::*;

module barrier_example4();
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
    br.set_auto_reset(0);
    fork
      process("A", 5);
      process("B", 10);
      process("C", 20);
      process("D", 25);
      process("E", 30);
      process("F", 35);
      begin 
        #40;
        $display("@%0t: number of waiters = %0d", $time, br.get_num_waiters());
      end
      begin 
        #50;
        br.reset();
        $display("@%0t: After reset", $time);
      end
      process("F", 50);
      begin 
        #50;
        $display("@%0t: number of waiters = %0d", $time, br.get_num_waiters());
      end
      
    join
  end
endmodule :barrier_example4

//LogFile output using Cadence Xcelium Tool
[2025-07-28 06:06:43 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 28, 2025 at 02:06:44 EDT
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
@0: Process F started
@5: Process A completed
@10: Process B completed
@20: Process C completed
@25: Process D completed
@25: Process A wait_for is unblocked
@25: Process B wait_for is unblocked
@25: Process C wait_for is unblocked
@25: Process D wait_for is unblocked
@30: Process E completed
@30: Process E wait_for is unblocked
@35: Process F completed
@35: Process F wait_for is unblocked
@40: number of waiters = 0
@50: After reset
@50: Process F completed
@50: number of waiters = 1
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 28, 2025 at 02:06:53 EDT  (total: 00:00:09)
Done
