Example3: cancel method example
--------------------------------
-The cancel method decrements the waiter count by one as shown in the below example. 
-Before calling the cancel method, the number of waiters count = 3 and after calling the cancel method, the number of waiters count = 2.

Code example:
`include "uvm_macros.svh"
import uvm_pkg::*;
module barrier_example3();
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
      begin 
        #20;
        $display("@%0t: Before cancel: number of waiters = %0d", $time, br.get_num_waiters());
        br.cancel();
        $display("@%0t: After cancel: number of waiters = %0d", $time, br.get_num_waiters());
      end
      
      process("D", 25);
      process("E", 30);
      begin 
        #30;
        $display("@%0t: number of waiters = %0d", $time, br.get_num_waiters());
      end
    join
  end
endmodule :barrier_example3

// Log File Output using Cadence Xcelium Tool
[2025-07-28 06:00:21 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 28, 2025 at 02:00:22 EDT
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
@5: Process A completed
@10: Process B completed
@20: Process C completed
@20: Before cancel: number of waiters = 3
@20: After cancel: number of waiters = 2
@25: Process D completed
@30: Process E completed
@30: number of waiters = 0
@30: Process A wait_for is unblocked
@30: Process B wait_for is unblocked
@30: Process C wait_for is unblocked
@30: Process D wait_for is unblocked
@30: Process E wait_for is unblocked
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 28, 2025 at 02:00:30 EDT  (total: 00:00:08)
Done
