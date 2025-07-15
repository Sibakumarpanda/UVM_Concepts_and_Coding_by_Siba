Example1: Using get_next_item and item_done methods in the driver (Without RSP packet )

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_item.sv
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
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
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
// Purpose :  my_sequencer file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////


`ifndef GUARD_MY_SEQUENCER_SV
`define GUARD_MY_SEQUENCER_SV

class my_sequencer extends uvm_sequencer #(my_seq_item);
  `uvm_component_utils(my_sequencer)
  
  function new(string name = "my_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction  
endclass :my_sequencer

`endif //GUARD_MY_SEQUENCER_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_driver.sv
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
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
      `uvm_info(get_type_name(), "After get_next_item call", UVM_LOW);
      #50; // Driving delay. Assuming time taken to drive RTL signals
      seq_item_port.item_done();
      `uvm_info(get_type_name(), "After item_done call", UVM_LOW);
    end
  endtask
  
endclass :my_driver

`endif //GUARD_MY_DRIVER_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_agent.sv
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
// Purpose :  Agent file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_AGENT_SV
`define GUARD_MY_AGENT_SV

class my_agent extends uvm_agent;
  
  my_driver drv;
  my_sequencer seqr;
  
  `uvm_component_utils(my_agent)
  
  function new(string name = "my_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = my_driver::type_id::create("drv", this);
    seqr = my_sequencer::type_id::create("seqr", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass :my_agent

`endif //GUARD_MY_AGENT_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_environment.sv
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
// Purpose :  my_environment file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_ENVIRONMENT_SV
`define GUARD_MY_ENVIRONMENT_SV

class my_environment extends uvm_agent;
  
  my_agent agt;
  
  `uvm_component_utils(my_environment)
  
  function new(string name = "my_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = my_agent::type_id::create("agt", this);
  endfunction
  
endclass :my_environment

`endif //GUARD_MY_ENVIRONMENT_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_seq.sv
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
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
    `uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
    //req = seq_item::type_id::create("req");
    // or
    $cast(req, create_item(my_seq_item::get_type(), m_sequencer, "req"));
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    `uvm_info(get_type_name(), "Before wait_for_item_done", UVM_LOW);
    wait_for_item_done();
    `uvm_info(get_type_name(), "After wait_for_item_done", UVM_LOW);
  endtask
  
endclass : my_base_seq

`endif //GUARD_MY_BASE_SEQ_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_test.sv
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
// Purpose :  my_base_test file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_BASE_TEST_SV
`define GUARD_MY_BASE_TEST_SV

class my_base_test extends uvm_test;
  
  my_environment env_o;
  my_base_seq    bseq;

  `uvm_component_utils(my_base_test)
  
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = my_environment::type_id::create("env_o", this);
  endfunction
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bseq = my_base_seq::type_id::create("bseq");    
    bseq.start(env_o.agt.seqr);
    phase.drop_objection(this);
  endtask
  
endclass :my_base_test

`endif //GUARD_MY_BASE_TEST_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
// Purpose :  package File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_PACKAGE_SV
`define GUARD_MY_PACKAGE_SV

package my_package;

import uvm_pkg::*;
`include "my_seq_item.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
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
// Project :  Understanding Sequence-Driver-Sequencer handshake Mechanism
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
/////////////////////////////////////////////////////////////////////////////////////////
//LogFile Output using Synopsys VCS Tool:
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
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _426_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 15.522 seconds to compile + .506 seconds to elab + .997 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 14 23:56 2025
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
UVM_INFO my_base_seq.sv(24) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [my_base_seq] Base seq: Inside Body
UVM_INFO my_base_seq.sv(31) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [my_base_seq] Before wait_for_item_done
UVM_INFO my_driver.sv(27) @ 0: uvm_test_top.env_o.agt.drv [my_driver] After get_next_item call
UVM_INFO my_driver.sv(30) @ 50: uvm_test_top.env_o.agt.drv [my_driver] After item_done call
UVM_INFO my_base_seq.sv(33) @ 50: uvm_test_top.env_o.agt.seqr@@bseq [my_base_seq] After wait_for_item_done
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 50: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 50: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    8
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[my_base_seq]     3
[my_driver]     2

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                   50
           V C S   S i m u l a t i o n   R e p o r t 
Time: 50 ns
CPU Time:      0.510 seconds;       Data structure size:   0.2Mb
Mon Jul 14 23:56:04 2025
Done



