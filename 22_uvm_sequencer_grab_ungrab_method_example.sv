Experiment on Grab and ungrab methods example :

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_sequence_item.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  Sequence item file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
 
`ifndef GUARD_MY_SEQUENCE_ITEM_SV
`define GUARD_MY_SEQUENCE_ITEM_SV
 
class my_sequence_item extends uvm_sequence_item;
  rand bit[15:0] addr;
  rand bit[15:0] data;
  `uvm_object_utils(my_sequence_item)
  function new(string name = "my_sequence_item ");
    super.new(name);
  endfunction
endclass : my_sequence_item
 
`endif //GUARD_MY_SEQUENCE_ITEM_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_sequencer.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  sequencer file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQUENCER_SV
`define GUARD_MY_SEQUENCER_SV
 
class my_sequencer extends uvm_sequencer #(my_sequence_item);
  `uvm_component_utils(my_sequencer)
  
  function new(string name = "my_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass:my_sequencer

`endif //GUARD_MY_SEQUENCER_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_driver.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  driver file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////


`ifndef GUARD_MY_DRIVER_SV
`define GUARD_MY_DRIVER_SV

class my_driver extends uvm_driver#(my_sequence_item);
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
      `uvm_info(get_name, $sformatf("addr = %0h and data = %0h", req.addr, req.data), UVM_LOW);
      seq_item_port.item_done();
    end
  endtask
endclass :my_driver

`endif //GUARD_MY_DRIVER_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_agent.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  agent file
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
  
endclass:my_agent

`endif //GUARD_MY_AGENT_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_env.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  environment file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////


`ifndef GUARD_MY_ENV_SV
`define GUARD_MY_ENV_SV
 
class my_env extends uvm_agent;
  my_agent agt;
  `uvm_component_utils(my_env)
  
  function new(string name = "my_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = my_agent::type_id::create("my_agt", this);
  endfunction
  
endclass:my_env

`endif //GUARD_MY_ENV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_A.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  sequence file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
 
`ifndef GUARD_MY_SEQ_A_SV
`define GUARD_MY_SEQ_A_SV

class my_seq_A extends uvm_sequence #(my_sequence_item);
  my_sequence_item req;
  `uvm_object_utils(my_seq_A)
  
  function new (string name = "my_seq_A");
    super.new(name);
  endfunction

  task body();
    req = my_sequence_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
     `uvm_info(get_type_name(), $sformatf("Running my_seq_A Sequence  " ), UVM_MEDIUM);
    `uvm_info(get_type_name(), $sformatf("%0t: seq_item is sent", $time), UVM_LOW);
    wait_for_item_done();
  endtask
endclass :my_seq_A

`endif //GUARD_MY_SEQ_A_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_B.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  sequence file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
 
`ifndef GUARD_MY_SEQ_B_SV
`define GUARD_MY_SEQ_B_SV


class my_seq_B extends uvm_sequence #(my_sequence_item);
  my_sequence_item req;
  `uvm_object_utils(my_seq_B)
  
  function new (string name = "my_seq_B");
    super.new(name);
  endfunction
  
  
  task body();
    //grab(m_sequencer); //we can use like this also , it will work
      grab();
      req = my_sequence_item::type_id::create("req");
      wait_for_grant();
      assert(req.randomize());
      send_request(req);
      `uvm_info(get_type_name(), $sformatf("Running my_seq_B Sequence  " ), UVM_MEDIUM);
      `uvm_info(get_type_name(), $sformatf("%0t: my_sequence_item is sent", $time), UVM_LOW);
      wait_for_item_done();
      //ungrab(m_sequencer);
      ungrab();
  endtask
  
endclass :my_seq_B

`endif //GUARD_MY_SEQ_B_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_C.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  sequence file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
 
`ifndef GUARD_MY_SEQ_C_SV
`define GUARD_MY_SEQ_C_SV


class my_seq_C extends uvm_sequence #(my_sequence_item);
  my_sequence_item req;
  `uvm_object_utils(my_seq_C)
  
  function new (string name = "my_seq_C");
    super.new(name);
  endfunction

  task body();
    req = my_sequence_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    `uvm_info(get_type_name(), $sformatf("Running my_seq_C Sequence  " ), UVM_MEDIUM);
    `uvm_info(get_type_name(), $sformatf("%0t: seq_item is sent", $time), UVM_LOW);
    wait_for_item_done();
  endtask
endclass :my_seq_C

`endif //GUARD_MY_SEQ_C_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_test.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  Base Test file file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////


`ifndef GUARD_MY_BASE_TEST_SV
`define GUARD_MY_BASE_TEST_SV


class my_base_test extends uvm_test;
  my_env env_o;
  my_seq_A seq_a;
  my_seq_B seq_b;
  my_seq_C seq_c;

  `uvm_component_utils(my_base_test)
  
  function new(string name = "my_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = my_env::type_id::create("env_o", this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
   
    uvm_top.print_topology();
    
  endfunction
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    seq_a = my_seq_A::type_id::create("seq_a");
    seq_b = my_seq_B::type_id::create("seq_b"); 
    seq_c = my_seq_C::type_id::create("seq_c"); 
    
    `uvm_info(get_type_name(), $sformatf("Running my_base_test " ), UVM_MEDIUM);
    
    fork
      repeat(3) seq_a.start(env_o.agt.seqr);
      repeat(3) seq_b.start(env_o.agt.seqr);
      repeat(3) seq_c.start(env_o.agt.seqr);
    join
    phase.drop_objection(this);
  endtask
  
endclass :my_base_test

`endif //GUARD_MY_BASE_TEST_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  package file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
 
`ifndef GUARD_MY_PACKAGE_SV
`define GUARD_MY_PACKAGE_SV

package my_package;
 
import uvm_pkg::*;
`include "my_sequence_item.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_agent.sv"
`include "my_env.sv"
`include "my_seq_A.sv"
`include "my_seq_B.sv"
`include "my_seq_C.sv"
`include "my_base_test.sv"

endpackage :my_package

`endif //GUARD_MY_PACKAGE_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  testbench.sv
// Project :  Understanding Sequencer method grab and ungrab
// Purpose :  top tb file and test class file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
 
 
//import uvm_pkg::*; // Import UVM package for base classes and utilities
`include "uvm_macros.svh" // Include UVM macros for logging and other utilities
 
`include "my_package.sv" // Include the package containing other necessary definitions
 import my_package::*;  // Import the package that includes transaction and environment classes


module tb_top;
  initial begin
    run_test("my_base_test");
  end
endmodule :tb_top
////////////////////////////////////////////////////////////////////////////////
NOTE: The log shows that a seq_B grab request is pushed in the front of the arbitration queue. Hence, seq_B requests are serviced earlier and followed by other requests.

//Log File output using Synopsys VCS Tool
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
CPU time: 8.697 seconds to compile + .275 seconds to elab + .578 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 11 08:54 2025
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
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
--------------------------------------------------------------
Name                       Type                    Size  Value
--------------------------------------------------------------
uvm_test_top               my_base_test            -     @336 
  env_o                    my_env                  -     @349 
    my_agt                 my_agent                -     @359 
      drv                  my_driver               -     @369 
        rsp_port           uvm_analysis_port       -     @388 
        seq_item_port      uvm_seq_item_pull_port  -     @378 
      seqr                 my_sequencer            -     @398 
        rsp_export         uvm_analysis_export     -     @407 
        seq_item_export    uvm_seq_item_pull_imp   -     @525 
        arbitration_queue  array                   0     -    
        lock_queue         array                   0     -    
        num_last_reqs      integral                32    'd1  
        num_last_rsps      integral                32    'd1  
--------------------------------------------------------------

UVM_INFO my_base_test.sv(45) @ 0: uvm_test_top [my_base_test] Running my_base_test 
UVM_INFO my_seq_B.sv(30) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq_b [my_seq_B] Running my_seq_B Sequence  
UVM_INFO my_seq_B.sv(31) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq_b [my_seq_B] 0: my_sequence_item is sent
UVM_INFO my_driver.sv(30) @ 50: uvm_test_top.env_o.my_agt.drv [drv] addr = 9e9a and data = 9bc9
UVM_INFO my_seq_B.sv(30) @ 50: uvm_test_top.env_o.my_agt.seqr@@seq_b [my_seq_B] Running my_seq_B Sequence  
UVM_INFO my_seq_B.sv(31) @ 50: uvm_test_top.env_o.my_agt.seqr@@seq_b [my_seq_B] 50: my_sequence_item is sent
UVM_INFO my_driver.sv(30) @ 100: uvm_test_top.env_o.my_agt.drv [drv] addr = a63a and data = 2792
UVM_INFO my_seq_B.sv(30) @ 100: uvm_test_top.env_o.my_agt.seqr@@seq_b [my_seq_B] Running my_seq_B Sequence  
UVM_INFO my_seq_B.sv(31) @ 100: uvm_test_top.env_o.my_agt.seqr@@seq_b [my_seq_B] 100: my_sequence_item is sent
UVM_INFO my_driver.sv(30) @ 150: uvm_test_top.env_o.my_agt.drv [drv] addr = ce88 and data = 50d1
UVM_INFO my_seq_A.sv(26) @ 150: uvm_test_top.env_o.my_agt.seqr@@seq_a [my_seq_A] Running my_seq_A Sequence  
UVM_INFO my_seq_A.sv(27) @ 150: uvm_test_top.env_o.my_agt.seqr@@seq_a [my_seq_A] 150: seq_item is sent
UVM_INFO my_driver.sv(30) @ 200: uvm_test_top.env_o.my_agt.drv [drv] addr = 7621 and data = 84c
UVM_INFO my_seq_C.sv(27) @ 200: uvm_test_top.env_o.my_agt.seqr@@seq_c [my_seq_C] Running my_seq_C Sequence  
UVM_INFO my_seq_C.sv(28) @ 200: uvm_test_top.env_o.my_agt.seqr@@seq_c [my_seq_C] 200: seq_item is sent
UVM_INFO my_driver.sv(30) @ 250: uvm_test_top.env_o.my_agt.drv [drv] addr = 3612 and data = 9d66
UVM_INFO my_seq_A.sv(26) @ 250: uvm_test_top.env_o.my_agt.seqr@@seq_a [my_seq_A] Running my_seq_A Sequence  
UVM_INFO my_seq_A.sv(27) @ 250: uvm_test_top.env_o.my_agt.seqr@@seq_a [my_seq_A] 250: seq_item is sent
UVM_INFO my_driver.sv(30) @ 300: uvm_test_top.env_o.my_agt.drv [drv] addr = 40cc and data = 37af
UVM_INFO my_seq_C.sv(27) @ 300: uvm_test_top.env_o.my_agt.seqr@@seq_c [my_seq_C] Running my_seq_C Sequence  
UVM_INFO my_seq_C.sv(28) @ 300: uvm_test_top.env_o.my_agt.seqr@@seq_c [my_seq_C] 300: seq_item is sent
UVM_INFO my_driver.sv(30) @ 350: uvm_test_top.env_o.my_agt.drv [drv] addr = 20f8 and data = 9838
UVM_INFO my_seq_A.sv(26) @ 350: uvm_test_top.env_o.my_agt.seqr@@seq_a [my_seq_A] Running my_seq_A Sequence  
UVM_INFO my_seq_A.sv(27) @ 350: uvm_test_top.env_o.my_agt.seqr@@seq_a [my_seq_A] 350: seq_item is sent
UVM_INFO my_driver.sv(30) @ 400: uvm_test_top.env_o.my_agt.drv [drv] addr = 9986 and data = 40f0
UVM_INFO my_seq_C.sv(27) @ 400: uvm_test_top.env_o.my_agt.seqr@@seq_c [my_seq_C] Running my_seq_C Sequence  
UVM_INFO my_seq_C.sv(28) @ 400: uvm_test_top.env_o.my_agt.seqr@@seq_c [my_seq_C] 400: seq_item is sent
UVM_INFO my_driver.sv(30) @ 450: uvm_test_top.env_o.my_agt.drv [drv] addr = b880 and data = 9906
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 450: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 450: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   32
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[UVMTOP]     1
[drv]     9
[my_base_test]     1
[my_seq_A]     6
[my_seq_B]     6
[my_seq_C]     6

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                  450
           V C S   S i m u l a t i o n   R e p o r t 
Time: 450 ns
CPU Time:      0.330 seconds;       Data structure size:   0.3Mb
Fri Jul 11 08:54:08 2025
Done
