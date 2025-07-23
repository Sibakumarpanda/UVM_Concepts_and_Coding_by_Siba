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
	
Example2: Type B1: An event is triggered before waiting for the event trigger
-The process_B task has a 10ns delay which makes sure event e1 triggers before waiting for an event trigger. 
-The wait for the event to be triggered will not be unblocked since the e1 event is triggered before. 
-Hence, statements after waiting for the trigger will not be executed.	

`include "uvm_macros.svh"
import uvm_pkg::*;

module event_example();
  uvm_event e1;
  
  task process_A();
    $display("@%0t: Before triggering event e1", $time);
    e1.trigger;
    $display("@%0t: After triggering event e1", $time);
  endtask
  
  task process_B();
    #10;
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
//LogFile Output using cadence Xcelium Tool
[2025-07-23 04:27:48 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 23, 2025 at 00:27:48 EDT
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

@0: Before triggering event e1
@0: After triggering event e1
@10: waiting for the event e1
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 23, 2025 at 00:27:57 EDT  (total: 00:00:09)
Done
	
Example3: Type C1: An event is triggered at the same time as waiting for the event trigger
-The process_A and process_B have no delay involved to ensure the triggering of an event and waiting for the event trigger to happen at the same time. 
-Since both processes are triggered at the same time, the wait_trigger method will not detect an event triggering. 
-The uvm_event provides a wait_ptrigger method to solve this race-around problem ( we can see in TypeC2 example6).
	
`include "uvm_macros.svh"
import uvm_pkg::*;
module event_example();
  uvm_event e1;
  
  task process_A();
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

//Log File Output Using Cadence Xcelium Tool
[2025-07-23 04:33:06 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 23, 2025 at 00:33:07 EDT
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

@0: Before triggering event e1
@0: After triggering event e1
@0: waiting for the event e1
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 23, 2025 at 00:33:16 EDT  (total: 00:00:09)
Done

Example4: Type A2: An event is triggered after waiting for the event trigger.
-Event is triggered and waiting for the event to be triggered via the wait_ptrigger method here.
-For example, there are two processes A and B. 
-The process_A task is used to trigger an event e1 and the process_B task is used to wait for the event using the wait_ptrigger.
-The process_A task has a 10ns delay which makes sure event e1 triggers after waiting for the event trigger. 
-The wait of the event to be triggered via the wait_ptrigger() method will be unblocked once the e1 event is triggered.	
	
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
    e1.wait_ptrigger;
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
//LOG File output using Cadence Xcelium Tool
[2025-07-23 08:21:51 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 23, 2025 at 04:21:51 EDT
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
TOOL:	xrun	23.09-s001: Exiting on Jul 23, 2025 at 04:22:00 EDT  (total: 00:00:09)
Done
	
Example5: Type B: An event is triggered before waiting for event trigger
-The process_B task has a 10ns delay which makes sure event e1 triggers before waiting for an event trigger. 
-The wait of the event to be triggered via wait() construct will not be unblocked since the e1 event is triggered before. 
-Hence, statements after waiting for the trigger (with @ operator) will not be executed.
	
`include "uvm_macros.svh"
import uvm_pkg::*;
module event_example();
  uvm_event e1;
  
  task process_A();
    $display("@%0t: Before triggering event e1", $time);
    e1.trigger;
    $display("@%0t: After triggering event e1", $time);
  endtask
  
  task process_B();
    #10;
    $display("@%0t: waiting for the event e1", $time);
    e1.wait_ptrigger;
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

//LogFile output Using cadence Xcelium Tool
[2025-07-23 08:27:18 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 23, 2025 at 04:27:18 EDT
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

@0: Before triggering event e1
@0: After triggering event e1
@10: waiting for the event e1
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 23, 2025 at 04:27:26 EDT  (total: 00:00:08)
Done
	
Example6: TypeC2: An event is triggered at the same time as waiting for the event trigger

`include "uvm_macros.svh"
import uvm_pkg::*;

module event_example();
  uvm_event e1;
  
  task process_A();
    $display("@%0t: Before triggering event e1", $time);
    e1.trigger;
    $display("@%0t: After triggering event e1", $time);
  endtask
  
  task process_B();
    $display("@%0t: waiting for the event e1", $time);
    e1.wait_ptrigger;
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
//LogFile Output Using Cadence Xcelium Tool
[2025-07-23 08:32:48 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 23, 2025 at 04:32:48 EDT
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

@0: Before triggering event e1
@0: After triggering event e1
@0: waiting for the event e1
@0: event e1 is triggered
xmsim: *W,RNQUIE: Simulation is complete.
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 23, 2025 at 04:32:56 EDT  (total: 00:00:08)
Done

Example7: TypeA3: retrieve data using wait_on and get_trigger_data.
-Event is triggered with data and waiting for the event to be triggered and retrieve data using wait_on and get_trigger_data.
-For example, there are two processes A and B. 
-The process_A task is used to trigger an event e1, sends the transaction object as data and the process_B task is used to wait for the event and retrieve data.
-The process_A task has a 10ns delay which makes sure event e1 triggers after waiting for the event trigger. 
-The wait for the event to be triggered using the wait_on method call that will be unblocked once the e1 event is triggered. 
-The get_trigger_data is used to retrieve data provided by the last call to trigger method.

`include "uvm_macros.svh"
import uvm_pkg::*;
//transaction class
class transaction extends uvm_object;
  rand bit [7:0] addr;
  rand bit [7:0] data;
  
  function new(string name = "transaction");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(transaction)
    `uvm_field_int(addr, UVM_PRINT);
    `uvm_field_int(data, UVM_PRINT);
  `uvm_object_utils_end
endclass :transaction

module event_example();
  uvm_event e1;
  
  task process_A();
    transaction tr_A = new();
    #10;
    $display("@%0t: Before triggering event e1", $time);
    assert(tr_A.randomize);
    tr_A.print();
    e1.trigger(tr_A);
    $display("@%0t: After triggering event e1", $time);
  endtask
  
  task process_B();
    uvm_object event_data;
    transaction tr_B;
    
    $display("@%0t: waiting for the event e1", $time);
    e1.wait_on();
    event_data = e1.get_trigger_data();
    $cast(tr_B, event_data);
    $display("@%0t: event e1 is triggered and data received = \n%s", $time, tr_B.sprint());
  endtask

  initial begin
    e1 = new();
    fork
      process_A();
      process_B();
    join
  end
endmodule

//LogFile Output using Synopsys VCS Tool
Starting vcs inline pass...

4 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling module event_example
All of 4 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _425_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 11.289 seconds to compile + .488 seconds to elab + .860 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 23 04:37 2025
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh(402) @ 0: reporter [UVM/RELNOTES] 
----------------------------------------------------------------
UVM-1.2.Synopsys
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
-------------------------------------
Name         Type         Size  Value
-------------------------------------
transaction  transaction  -     @336 
  addr       integral     8     'ha3 
  data       integral     8     'h8f 
-------------------------------------
@10: After triggering event e1
@10: event e1 is triggered and data received = 
-------------------------------------
Name         Type         Size  Value
-------------------------------------
transaction  transaction  -     @336 
  addr       integral     8     'ha3 
  data       integral     8     'h8f 
-------------------------------------

           V C S   S i m u l a t i o n   R e p o r t 
Time: 10 ns
CPU Time:      0.480 seconds;       Data structure size:   0.2Mb
Wed Jul 23 04:37:05 2025
Done

Example8:	



	
	
	
