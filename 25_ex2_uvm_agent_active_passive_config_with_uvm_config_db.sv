Example2: configure agent type with uvm_config_db
//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_item.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  my_seq_item file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQ_ITEM_SV
`define GUARD_MY_SEQ_ITEM_SV

class my_seq_item extends uvm_sequence_item;
  rand bit[15:0] addr;
  rand bit[15:0] data;
  
  `uvm_object_utils(my_seq_item)
  
  function new(string name = "my_seq_item");
    super.new(name);
  endfunction
  
endclass :my_seq_item

`endif //GUARD_MY_SEQ_ITEM_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_sequencer.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  my_sequencer file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_SEQUENCER_SV
`define GUARD_MY_SEQUENCER_SV

class my_sequencer extends uvm_sequencer #(my_seq_item);
  `uvm_component_utils(my_sequencer)
  
  function new(string name = "sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass :my_sequencer

`endif //GUARD_MY_SEQUENCER_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_driver.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  Driver file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_DRIVER_SV
`define GUARD_MY_DRIVER_SV

class my_driver extends uvm_driver#(my_seq_item);
  `uvm_component_utils(my_driver)
  
  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      void'(req.randomize());
      #50; // Driving delay. Assuming time taken to drive RTL signals
      seq_item_port.item_done();
    end
  endtask
  
endclass :my_driver

`endif //GUARD_MY_DRIVER_SV
//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_monitor.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  Monitor file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_MONITOR_SV
`define GUARD_MY_MONITOR_SV

class monitor_A extends uvm_monitor;
  `uvm_component_utils(monitor_A)
  
  function new(string name = "monitor_A", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass :monitor_A

class monitor_B extends uvm_monitor;
  `uvm_component_utils(monitor_B)
  
  function new(string name = "monitor_B", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass :monitor_B

`endif //GUARD_MY_MONITOR_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_agent.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  Agent file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_AGENT_SV
`define GUARD_MY_AGENT_SV

class a_agent extends uvm_agent;
  
  my_driver drv;
  my_sequencer seqr;
  monitor_A mon_A;
  
  `uvm_component_utils(a_agent)
  
  function new(string name = "a_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      drv = my_driver::type_id::create("drv", this);
      seqr = my_sequencer::type_id::create("seqr", this);
      `uvm_info(get_name(), "This is Active agent", UVM_LOW);
    end
    mon_A = monitor_A::type_id::create("mon_A", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass :a_agent

class p_agent extends uvm_agent;
  
  monitor_B mon_B;
  
  `uvm_component_utils(p_agent)
  
  function new(string name = "p_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_PASSIVE) begin
      mon_B = monitor_B::type_id::create("mon_B", this);
      `uvm_info(get_name(), "This is Passive agent", UVM_LOW);
    end
  endfunction
  
endclass :p_agent

`endif //GUARD_MY_AGENT_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_environment.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  my_environment file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_ENVIRONMENT_SV
`define GUARD_MY_ENVIRONMENT_SV

class my_environment extends uvm_agent;
  a_agent agt_a; // Active agent
  p_agent agt_p; // Passive agent
  `uvm_component_utils(my_environment)
  
  function new(string name = "my_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agt_a = a_agent::type_id::create("agt_a", this);
    agt_p = p_agent::type_id::create("agt_p", this);
    //set_config_int("agt_p", "is_active", UVM_PASSIVE); // Configure p_agent as passive agent
    uvm_config_db #(uvm_active_passive_enum)::set(this, "agt_p", "is_active", UVM_PASSIVE); // Configure p_agent as passive agent
   
  endfunction
  
endclass :my_environment

`endif //GUARD_MY_ENVIRONMENT_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_seq.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  my_base_seq file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_BASE_SEQ_SV
`define GUARD_MY_BASE_SEQ_SV

class my_base_seq extends uvm_sequence #(my_seq_item);
  my_seq_item req;
  `uvm_object_utils(my_base_seq)
  
  function new (string name = "my_base_seq");
    super.new(name);
  endfunction

  task body();
    req = my_seq_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done();
  endtask
  
endclass :my_base_seq

`endif //GUARD_MY_BASE_SEQ_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_test.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  my_base_test file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_BASE_TEST_SV
`define GUARD_MY_BASE_TEST_SV

class my_base_test extends uvm_test;
  my_environment env_o;
  my_base_seq bseq;
  
  `uvm_component_utils(my_base_test)
  
  function new(string name = "my_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = my_environment::type_id::create("env_o", this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology(); 
  endfunction
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bseq = my_base_seq::type_id::create("bseq");    
    bseq.start(env_o.agt_a.seqr);
    phase.drop_objection(this);
  endtask
  
endclass :my_base_test

`endif //GUARD_MY_BASE_TEST_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  package File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_PACKAGE_SV
`define GUARD_MY_PACKAGE_SV

package my_package;

import uvm_pkg::*;
`include "my_seq_item.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_environment.sv"
`include "my_base_seq.sv"
`include "my_base_test.sv"

endpackage :my_package
`endif //GUARD_MY_PACKAGE_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  testbench.sv
// Project :  Understanding Active and passive agent configuration with uvm_config_db
// Purpose :  tb_top file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
//import uvm_pkg::*;         // Import UVM package for base classes and utilities
`include "uvm_macros.svh"   // Include UVM macros for logging and other utilities
`include "my_package.sv"  // Include the package containing other necessary definitions
import my_package::*;    // Import the package that includes transaction and environment classes

module tb_top;
  initial begin
    run_test("my_base_test");
  end
endmodule :tb_top

//LogFile Output Using Synopsys
Starting vcs inline pass...

5 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling package my_package
recompiling module tb_top
All of 5 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _425_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 14.178 seconds to compile + .448 seconds to elab + .892 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 15 08:24 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_base_test...
UVM_INFO my_agent.sv(30) @ 0: uvm_test_top.env_o.agt_a [agt_a] This is Active agent
UVM_INFO my_agent.sv(57) @ 0: uvm_test_top.env_o.agt_p [agt_p] This is Passive agent
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
--------------------------------------------------------------
Name                       Type                    Size  Value
--------------------------------------------------------------
uvm_test_top               my_base_test            -     @336 
  env_o                    my_environment          -     @349 
    agt_a                  a_agent                 -     @359 
      drv                  my_driver               -     @382 
        rsp_port           uvm_analysis_port       -     @401 
        seq_item_port      uvm_seq_item_pull_port  -     @391 
      mon_A                monitor_A               -     @550 
      seqr                 my_sequencer            -     @411 
        rsp_export         uvm_analysis_export     -     @420 
        seq_item_export    uvm_seq_item_pull_imp   -     @538 
        arbitration_queue  array                   0     -    
        lock_queue         array                   0     -    
        num_last_reqs      integral                32    'd1  
        num_last_rsps      integral                32    'd1  
    agt_p                  p_agent                 -     @368 
      mon_B                monitor_B               -     @566 
--------------------------------------------------------------

UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 50: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 50: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    6
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[UVMTOP]     1
[agt_a]     1
[agt_p]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                   50
           V C S   S i m u l a t i o n   R e p o r t 
Time: 50 ns
CPU Time:      0.470 seconds;       Data structure size:   0.2Mb
Tue Jul 15 08:24:19 2025
Done
