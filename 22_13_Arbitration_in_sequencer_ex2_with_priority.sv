//Arbitration in sequencer(with Priority)-Example2

//Here in Base test (With Priority is set in Sequencer)
// Experiment Test to understand below various Arbitration modes
/*
Different Types of Sequencer Arbitration modes are :
1. UVM_SEQ_ARB_FIFO
2. UVM_SEQ_ARB_WEIGHTED
3. UVM_SEQ_ARB_RANDOM
4. UVM_SEQ_ARB_STRICT_FIFO
5. UVM_SEQ_ARB_STRICT_RANDOM
6. UVM_SEQ_ARB_USER
*/

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_sequence_item.sv
// Project :  Understanding Sequencer Arbitration Concept
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
// Project :  Understanding Sequencer Arbitration Concept
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
// Project :  Understanding Sequencer Arbitration Concept
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

`endif //GUARD_MY_DRIVER

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_agent.sv
// Project :  Understanding Sequencer Arbitration Concept
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
// File    : my_env.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  environment file
// Author  : Siba Kumar Panda
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

`endif //GUARD_MY_ENV_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_test.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  my_base_test file (The base_test is setted with priority to the sequencer)
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_BASE_TEST_SV
`define GUARD_MY_BASE_TEST_SV

class my_base_test extends uvm_test;
  my_env env_o;
  my_sequence seq[5];

  `uvm_component_utils(my_base_test)
  
  function new(string name = "my_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = my_env::type_id::create("env_o", this);
  endfunction
  
  virtual task cfg_arb_mode;
  endtask
  
  task run_phase(uvm_phase phase);
    string s_name;
    super.run_phase(phase);
    phase.raise_objection(this);
    cfg_arb_mode();
    `uvm_info(get_name, $sformatf("Arbitration mode = %s", env_o.agt.seqr.get_arbitration()), UVM_LOW);
    foreach(seq[i]) begin
      automatic int j = i;
      fork
      begin
        s_name = $sformatf("seq[%0d]", j);
        seq[j] = my_sequence::type_id::create(s_name);    
        //seq[j].start(env_o.agt.seqr); 
        // Here , priority is set to the sequencer as below
        seq[j].start(env_o.agt.seqr, .this_priority((j+1)*100)); // priority is mentioned as 100, 200, 300, 400, 500 for j = 0,1,2,3,4
      end
      join_none
    end
    wait fork;
    
    phase.drop_objection(this);
  endtask
      
endclass :my_base_test
      
`endif //GUARD_MY_BASE_TEST_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_sequence.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  my_sequence File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQUENCE_SV
`define GUARD_MY_SEQUENCE_SV

class my_sequence extends uvm_sequence #(my_sequence_item);
  my_sequence_item req;
  
  `uvm_object_utils(my_sequence)
  
  function new (string name = "my_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Inside body task", UVM_LOW);
    req = my_sequence_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done();
    `uvm_info(get_type_name(), "Completed body task", UVM_LOW);
  endtask
  
endclass :my_sequence

`endif //GUARD_MY_SEQUENCE_SV      

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_arb_fifo_test.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  my_seq_arb_fifo_test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQ_ARB_FIFO_TEST_SV
`define GUARD_MY_SEQ_ARB_FIFO_TEST_SV

class my_seq_arb_fifo_test extends my_base_test;
  `uvm_component_utils(my_seq_arb_fifo_test)
    
  function new(string name = "my_seq_arb_fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task cfg_arb_mode;
    `uvm_info(get_type_name(), $sformatf("Running the my_seq_arb_fifo_test " ), UVM_MEDIUM);
    env_o.agt.seqr.set_arbitration(UVM_SEQ_ARB_FIFO);
  endtask
  
endclass :my_seq_arb_fifo_test

`endif //GUARD_MY_SEQ_ARB_FIFO_TEST_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_arb_weighted_test.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  my_seq_arb_weighted_test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQ_ARB_WEIGHTED_TEST_SV
`define GUARD_MY_SEQ_ARB_WEIGHTED_TEST_SV

class my_seq_arb_weighted_test extends my_base_test;
  `uvm_component_utils(my_seq_arb_weighted_test)
    
  function new(string name = "my_seq_arb_weighted_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task cfg_arb_mode;
    `uvm_info(get_type_name(), $sformatf("Running the my_seq_arb_weighted_test " ), UVM_MEDIUM);
    env_o.agt.seqr.set_arbitration(UVM_SEQ_ARB_WEIGHTED);
  endtask
  
endclass :my_seq_arb_weighted_test

`endif //GUARD_MY_SEQ_ARB_WEIGHTED_TEST_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_arb_random_test.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  my_seq_arb_random_test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQ_ARB_RANDOM_TEST_SV
`define GUARD_MY_SEQ_ARB_RANDOM_TEST_SV

class my_seq_arb_random_test extends my_base_test;
  `uvm_component_utils(my_seq_arb_random_test)
    
  function new(string name = "my_seq_arb_random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task cfg_arb_mode;
    `uvm_info(get_type_name(), $sformatf("Running the my_seq_arb_random_test " ), UVM_MEDIUM);
    env_o.agt.seqr.set_arbitration(UVM_SEQ_ARB_RANDOM);
  endtask
  
endclass :my_seq_arb_random_test

`endif //GUARD_MY_SEQ_ARB_RANDOM_TEST_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_arb_strict_fifo_test.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  my_seq_arb_strict_fifo_test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQ_ARB_STRICT_FIFO_TEST_SV
`define GUARD_MY_SEQ_ARB_STRICT_FIFO_TEST_SV


class my_seq_arb_strict_fifo_test extends my_base_test;
  `uvm_component_utils(my_seq_arb_strict_fifo_test)
    
  function new(string name = "my_seq_arb_strict_fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task cfg_arb_mode;
    `uvm_info(get_type_name(), $sformatf("Running the my_seq_arb_strict_fifo_test " ), UVM_MEDIUM);
    env_o.agt.seqr.set_arbitration(UVM_SEQ_ARB_STRICT_FIFO);
  endtask
  
endclass :my_seq_arb_strict_fifo_test

`endif //GUARD_MY_SEQ_ARB_STRICT_FIFO_TEST_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_arb_strict_random_test.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  my_seq_arb_strict_random_test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQ_ARB_STRICT_RANDOM_TEST_SV
`define GUARD_MY_SEQ_ARB_STRICT_RANDOM_TEST_SV

class my_seq_arb_strict_random_test extends my_base_test;
  `uvm_component_utils(my_seq_arb_strict_random_test)
    
  function new(string name = "my_seq_arb_strict_random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task cfg_arb_mode;
    `uvm_info(get_type_name(), $sformatf("Running the my_seq_arb_strict_random_test " ), UVM_MEDIUM);
    env_o.agt.seqr.set_arbitration(UVM_SEQ_ARB_STRICT_RANDOM);
  endtask
  
endclass:my_seq_arb_strict_random_test

`endif //GUARD_MY_SEQ_ARB_STRICT_RANDOM_TEST_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  package File
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
`include "my_sequence.sv"

`include "my_base_test.sv"
`include "my_seq_arb_fifo_test.sv"
`include "my_seq_arb_weighted_test.sv"
`include "my_seq_arb_random_test.sv"
`include "my_seq_arb_strict_fifo_test.sv"
`include "my_seq_arb_strict_random_test.sv"

endpackage :my_package

`endif //GUARD_MY_PACKAGE_SV
      
//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  testbench.sv
// Project :  Understanding Sequencer Arbitration Concept
// Purpose :  TB Top file
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

//import uvm_pkg::*;         // Import UVM package for base classes and utilities
`include "uvm_macros.svh"   // Include UVM macros for logging and other utilities
`include "my_package.sv"  // Include the package containing other necessary definitions
import my_package::*;    // Import the package that includes transaction and environment classes
 
module tb_top;
  
  initial begin
    run_test (""); // The individual test can be run from the command line args with args as : +UVM_TESTNAME = <test_name> in run options
    //run_test("my_seq_arb_fifo_test");
    //run_test("my_seq_arb_weighted_test");
    //run_test("my_seq_arb_random_test");
    //run_test("my_seq_arb_strict_fifo_test");
    //run_test("my_seq_arb_strict_random_test");   
  end  
endmodule:tb_top

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
1. +UVM_TESTNAME = my_seq_arb_fifo_test , means here Arbitration mode set as UVM_SEQ_ARB_FIFO (with Priority set)
      
Log File Output :
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
CPU time: 9.128 seconds to compile + .336 seconds to elab + .731 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 10 00:47 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_seq_arb_fifo_test...
UVM_INFO my_seq_arb_fifo_test.sv(21) @ 0: uvm_test_top [my_seq_arb_fifo_test] Running the my_seq_arb_fifo_test 
UVM_INFO my_base_test.sv(36) @ 0: uvm_test_top [uvm_test_top] Arbitration mode = UVM_SEQ_ARB_FIFO
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Inside body task
UVM_INFO my_driver.sv(29) @ 50: uvm_test_top.env_o.my_agt.drv [drv] addr = f92d and data = 1d95
UVM_INFO my_sequence.sv(29) @ 50: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 100: uvm_test_top.env_o.my_agt.drv [drv] addr = c6ed and data = c7af
UVM_INFO my_sequence.sv(29) @ 100: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 150: uvm_test_top.env_o.my_agt.drv [drv] addr = 252f and data = e872
UVM_INFO my_sequence.sv(29) @ 150: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 200: uvm_test_top.env_o.my_agt.drv [drv] addr = 40cc and data = 37af
UVM_INFO my_sequence.sv(29) @ 200: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 250: uvm_test_top.env_o.my_agt.drv [drv] addr = 76b4 and data = 6d4f
UVM_INFO my_sequence.sv(29) @ 250: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Completed body task
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 250: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 250: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   20
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[drv]     5
[my_seq_arb_fifo_test]     1
[my_sequence]    10
[uvm_test_top]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                  250
           V C S   S i m u l a t i o n   R e p o r t 
Time: 250 ns
CPU Time:      0.390 seconds;       Data structure size:   0.3Mb
Thu Jul 10 00:47:04 2025
Done

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
2. +UVM_TESTNAME = my_seq_arb_weighted_test , means here Arbitration mode set as UVM_SEQ_ARB_WEIGHTED (with Priority set)
      
Log File Output :
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
CPU time: 7.782 seconds to compile + .274 seconds to elab + .610 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 10 00:48 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_seq_arb_weighted_test...
UVM_INFO my_seq_arb_weighted_test.sv(21) @ 0: uvm_test_top [my_seq_arb_weighted_test] Running the my_seq_arb_weighted_test 
UVM_INFO my_base_test.sv(36) @ 0: uvm_test_top [uvm_test_top] Arbitration mode = UVM_SEQ_ARB_WEIGHTED
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Inside body task
UVM_INFO my_driver.sv(29) @ 50: uvm_test_top.env_o.my_agt.drv [drv] addr = 76b4 and data = 6d4f
UVM_INFO my_sequence.sv(29) @ 50: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 100: uvm_test_top.env_o.my_agt.drv [drv] addr = 40cc and data = 37af
UVM_INFO my_sequence.sv(29) @ 100: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 150: uvm_test_top.env_o.my_agt.drv [drv] addr = f92d and data = 1d95
UVM_INFO my_sequence.sv(29) @ 150: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 200: uvm_test_top.env_o.my_agt.drv [drv] addr = 252f and data = e872
UVM_INFO my_sequence.sv(29) @ 200: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 250: uvm_test_top.env_o.my_agt.drv [drv] addr = c6ed and data = c7af
UVM_INFO my_sequence.sv(29) @ 250: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Completed body task
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 250: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 250: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   20
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[drv]     5
[my_seq_arb_weighted_test]     1
[my_sequence]    10
[uvm_test_top]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                  250
           V C S   S i m u l a t i o n   R e p o r t 
Time: 250 ns
CPU Time:      0.350 seconds;       Data structure size:   0.3Mb
Thu Jul 10 00:48:28 2025
Done

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
3. +UVM_TESTNAME = my_seq_arb_random_test , means here Arbitration mode set as UVM_SEQ_ARB_RANDOM (with Priority set)
      
Log File Output :  
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
CPU time: 8.434 seconds to compile + .276 seconds to elab + .591 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 10 00:51 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_seq_arb_random_test...
UVM_INFO my_seq_arb_random_test.sv(21) @ 0: uvm_test_top [my_seq_arb_random_test] Running the my_seq_arb_random_test 
UVM_INFO my_base_test.sv(36) @ 0: uvm_test_top [uvm_test_top] Arbitration mode = UVM_SEQ_ARB_RANDOM
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Inside body task
UVM_INFO my_driver.sv(29) @ 50: uvm_test_top.env_o.my_agt.drv [drv] addr = 252f and data = e872
UVM_INFO my_sequence.sv(29) @ 50: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 100: uvm_test_top.env_o.my_agt.drv [drv] addr = c6ed and data = c7af
UVM_INFO my_sequence.sv(29) @ 100: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 150: uvm_test_top.env_o.my_agt.drv [drv] addr = 40cc and data = 37af
UVM_INFO my_sequence.sv(29) @ 150: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 200: uvm_test_top.env_o.my_agt.drv [drv] addr = 76b4 and data = 6d4f
UVM_INFO my_sequence.sv(29) @ 200: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 250: uvm_test_top.env_o.my_agt.drv [drv] addr = f92d and data = 1d95
UVM_INFO my_sequence.sv(29) @ 250: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Completed body task
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 250: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 250: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   20
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[drv]     5
[my_seq_arb_random_test]     1
[my_sequence]    10
[uvm_test_top]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                  250
           V C S   S i m u l a t i o n   R e p o r t 
Time: 250 ns
CPU Time:      0.330 seconds;       Data structure size:   0.3Mb
Thu Jul 10 00:51:54 2025
Done

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       
4. +UVM_TESTNAME = my_seq_arb_strict_fifo_test , means here Arbitration mode set as UVM_SEQ_ARB_STRICT_FIFO (with Priority set)
      
Log File Output :
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
CPU time: 8.386 seconds to compile + .272 seconds to elab + .571 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 10 00:52 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_seq_arb_strict_fifo_test...
UVM_INFO my_seq_arb_strict_fifo_test.sv(22) @ 0: uvm_test_top [my_seq_arb_strict_fifo_test] Running the my_seq_arb_strict_fifo_test 
UVM_INFO my_base_test.sv(36) @ 0: uvm_test_top [uvm_test_top] Arbitration mode = UVM_SEQ_ARB_STRICT_FIFO
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Inside body task
UVM_INFO my_driver.sv(29) @ 50: uvm_test_top.env_o.my_agt.drv [drv] addr = 76b4 and data = 6d4f
UVM_INFO my_sequence.sv(29) @ 50: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 100: uvm_test_top.env_o.my_agt.drv [drv] addr = 40cc and data = 37af
UVM_INFO my_sequence.sv(29) @ 100: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 150: uvm_test_top.env_o.my_agt.drv [drv] addr = 252f and data = e872
UVM_INFO my_sequence.sv(29) @ 150: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 200: uvm_test_top.env_o.my_agt.drv [drv] addr = c6ed and data = c7af
UVM_INFO my_sequence.sv(29) @ 200: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 250: uvm_test_top.env_o.my_agt.drv [drv] addr = f92d and data = 1d95
UVM_INFO my_sequence.sv(29) @ 250: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Completed body task
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 250: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 250: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   20
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[drv]     5
[my_seq_arb_strict_fifo_test]     1
[my_sequence]    10
[uvm_test_top]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                  250
           V C S   S i m u l a t i o n   R e p o r t 
Time: 250 ns
CPU Time:      0.320 seconds;       Data structure size:   0.3Mb
Thu Jul 10 00:52:46 2025
Done
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       
5. +UVM_TESTNAME = my_seq_arb_strict_random_test , means here Arbitration mode set as UVM_SEQ_ARB_STRICT_RANDOM (with Priority set)
      
Log File Output : 
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
CPU time: 7.470 seconds to compile + .247 seconds to elab + .540 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 10 00:54 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_seq_arb_strict_random_test...
UVM_INFO my_seq_arb_strict_random_test.sv(21) @ 0: uvm_test_top [my_seq_arb_strict_random_test] Running the my_seq_arb_strict_random_test 
UVM_INFO my_base_test.sv(36) @ 0: uvm_test_top [uvm_test_top] Arbitration mode = UVM_SEQ_ARB_STRICT_RANDOM
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Inside body task
UVM_INFO my_sequence.sv(23) @ 0: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Inside body task
UVM_INFO my_driver.sv(29) @ 50: uvm_test_top.env_o.my_agt.drv [drv] addr = 76b4 and data = 6d4f
UVM_INFO my_sequence.sv(29) @ 50: uvm_test_top.env_o.my_agt.seqr@@seq[4] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 100: uvm_test_top.env_o.my_agt.drv [drv] addr = 40cc and data = 37af
UVM_INFO my_sequence.sv(29) @ 100: uvm_test_top.env_o.my_agt.seqr@@seq[3] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 150: uvm_test_top.env_o.my_agt.drv [drv] addr = 252f and data = e872
UVM_INFO my_sequence.sv(29) @ 150: uvm_test_top.env_o.my_agt.seqr@@seq[2] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 200: uvm_test_top.env_o.my_agt.drv [drv] addr = c6ed and data = c7af
UVM_INFO my_sequence.sv(29) @ 200: uvm_test_top.env_o.my_agt.seqr@@seq[1] [my_sequence] Completed body task
UVM_INFO my_driver.sv(29) @ 250: uvm_test_top.env_o.my_agt.drv [drv] addr = f92d and data = 1d95
UVM_INFO my_sequence.sv(29) @ 250: uvm_test_top.env_o.my_agt.seqr@@seq[0] [my_sequence] Completed body task
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 250: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 250: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   20
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[drv]     5
[my_seq_arb_strict_random_test]     1
[my_sequence]    10
[uvm_test_top]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                  250
           V C S   S i m u l a t i o n   R e p o r t 
Time: 250 ns
CPU Time:      0.320 seconds;       Data structure size:   0.3Mb
Thu Jul 10 00:54:26 2025
Done
