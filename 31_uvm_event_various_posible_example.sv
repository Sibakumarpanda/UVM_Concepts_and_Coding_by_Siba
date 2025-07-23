Various possible examples to understand the uvm_event concept is listed out here .
     
   1. Event is triggered using e1.trigger and waiting for the event to be triggered via the wait_trigger (e1.wait_trigger) method
      a. Type A1: An event is triggered after waiting for the event trigger
      b. Type B1: An event is triggered before waiting for the event trigger
      c. Type C1: An event is triggered at the same time as waiting for the event trigger  

   2. Event is triggered using e1.trigger and waiting for the event to be triggered via the wait_ptrigger (e1.wait_ptrigger) method      
      a. Type A2: An event is triggered after waiting for the event trigger
      b. Type B2: An event is triggered before waiting for event trigger
      c. Type C2: An event is triggered at the same time as waiting for the event trigger 

   3.  Event is triggered with data (e1.trigger(tr_A)) and waiting for the event to be triggered and retrieve data using wait_on and get_trigger_data
      a. Type A3: retrieve data using wait_on and get_trigger_data.   
      b. Type B3: retrieve data using wait_trigger_data
      c. Type C3: retrieve data using wait_ptrigger_data 

Example1: Type A1: An event is triggered after waiting for the event trigger
 -For example, there are two processes A and B. The process_A task is used to trigger an event e1 and the process_B task is used to wait for the event.
 -The process_A task has a 10ns delay which makes sure event e1 triggers after waiting for the event trigger. The wait for the event to be triggered using the wait_trigger method call that will be unblocked once the e1 event is triggered.  
   
`include "uvm_macros.svh"
import uvm_pkg::*;
module event_example();
  uvm_event e1;
  
  task process_A();
    #10;
    $display("@%0t: Before triggering event e1", $time);
    e1.trigger;
    $display("@%0t: After triggering event e1", $time);
  endtask
  
  task process_B();
    $display("@%0t: waiting for the event e1", $time);
    e1.wait_trigger;
    $display("@%0t: event e1 is triggered", $time);
  endtask

  initial begin
    e1 = new();
    fork
      process_A();
      process_B();
    join
  end
endmodule

//LogFile Output using Cadence Xcelium Tool
[2025-07-23 02:50:07 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 22, 2025 at 22:50:07 EDT
xrun: 23.09-s001: (c) Copyright 1995-2023 Cadence Design Systems, Inc.
	Top level design units:
		uvm_pkg
		$unit_0x4ccdf83b
		event_example
Loading snapshot worklib.event_example:sv .................... Done
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

@0: waiting for the event e1
@10: Before triggering event e1
@10: After triggering event e1
@10: event e1 is triggered
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 22, 2025 at 22:50:14 EDT  (total: 00:00:07)
Done
