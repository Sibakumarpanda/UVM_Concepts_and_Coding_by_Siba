// Callback Example using UVM-Ex2(Callback used in Sequence )
//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_seq_item.sv
// Project :  Understanding UVM Callback
// Purpose :  Sequence item File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_SEQ_ITEM_SV
`define GUARD_MY_SEQ_ITEM_SV

typedef enum {GOOD, BAD_ERR1, BAD_ERR2} pkt_type;

class my_seq_item extends uvm_sequence_item;
  
  rand bit[15:0] addr;
  rand bit[15:0] data;
  pkt_type pkt;
  
  `uvm_object_utils_begin(my_seq_item)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(data,UVM_ALL_ON)
    `uvm_field_enum(pkt_type,pkt,UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "my_seq_item");
    super.new(name);
  endfunction:new  
  constraint pkt_c {pkt == GOOD;};  
endclass : my_seq_item
`endif //GUARD_MY_SEQ_ITEM_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_sequencer.sv
// Project :  Understanding UVM Callback
// Purpose :  Sequencer File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_SEQUENCER_SV
`define GUARD_MY_SEQUENCER_SV

class my_sequencer extends uvm_sequencer #(my_seq_item);
  
  `uvm_component_utils(my_sequencer)
  `uvm_register_cb(my_sequencer,my_callback)
  
  function new(string name = "my_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new
  
endclass :my_sequencer

`endif //GUARD_MY_SEQUENCER_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_driver.sv
// Project :  Understanding UVM Callback
// Purpose :  Driver File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

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
      `uvm_info(get_full_name(),$sformatf("Driving pkt = \n%s", req.sprint()),UVM_LOW);
      #50; // Driving delay. Assuming time taken to drive RTL signals
      seq_item_port.item_done();
    end
  endtask
  
endclass :my_driver

`endif //GUARD_MY_DRIVER_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_agent.sv
// Project :  Understanding UVM Callback
// Purpose :  Agent File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_AGENT_SV
`define GUARD_MY_AGENT_SV

class my_agent extends uvm_agent;
  `uvm_component_utils(my_agent)  
  my_driver drv;
  my_sequencer seqr;
    
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

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_env.sv
// Project :  Understanding UVM Callback
// Purpose :  Environment File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_ENV_SV
`define GUARD_MY_ENV_SV

class my_env extends uvm_agent;
  
  `uvm_component_utils(my_env)
  
  my_agent agt;
  
  function new(string name = "my_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = my_agent::type_id::create("agt", this);
  endfunction
  
endclass :my_env
`endif //GUARD_MY_ENV_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_callback.sv
// Project :  Understanding UVM Callback
// Purpose :  Callback File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_CALLBACK_SV
`define GUARD_MY_CALLBACK_SV

class my_callback extends uvm_callback;
  `uvm_object_utils(my_callback)
  
  function new(string name = "my_callback");
    super.new(name);
  endfunction :new
   
  virtual task modify_pkt(ref my_seq_item req);
  endtask :modify_pkt
  
endclass :my_callback

`endif //GUARD_MY_CALLBACK_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_sequence_callback.sv
// Project :  Understanding UVM Callback
// Purpose :  Sequence callback File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_SEQUENCE_CALLBACK_SV
`define GUARD_MY_SEQUENCE_CALLBACK_SV

class my_sequence_callback extends my_callback;
  
  `uvm_object_utils(my_sequence_callback)
  
  function new(string name = "my_sequence_callback");
    super.new(name);
  endfunction :new
  
  task modify_pkt(ref my_seq_item req); // callback method implementation
    `uvm_info(get_full_name(),"Inside modify_pkt method: Injecting error in the seq item",UVM_LOW);
    req.pkt = BAD_ERR1;
    req.addr = 16'hFFFF;
    req.print();
  endtask :modify_pkt
  
endclass :my_sequence_callback

`endif //GUARD_MY_SEQUENCE_CALLBACK_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_bae_seqence.sv
// Project :  Understanding UVM Callback
// Purpose :  Base sequence File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_BASE_SEQUENCE_SV
`define GUARD_MY_BASE_SEQUENCE_SV

class my_base_sequence extends uvm_sequence #(my_seq_item);
  
  `uvm_object_utils(my_base_sequence)
  
  my_seq_item req;
  my_sequencer seqr_h; // Provided sequencer hierarchy from base_test before starting the sequence.
    
  function new (string name = "my_base_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
    req = my_seq_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    `uvm_do_obj_callbacks(my_sequencer,my_callback,seqr_h,modify_pkt(req));
    
    send_request(req);
    wait_for_item_done();
  endtask :body
  
endclass :my_base_sequence

`endif //GUARD_MY_BASE_SEQUENCE_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_test.sv
// Project :  Understanding UVM Callback
// Purpose :  Base Test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_BASE_TEST_SV
`define GUARD_MY_BASE_TEST_SV

class my_base_test extends uvm_test;
  
  `uvm_component_utils(my_base_test)
  
  my_env            env_o;
  my_base_sequence  bseq;

  function new(string name = "my_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = my_env::type_id::create("env_o", this);
  endfunction :build_phase
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bseq = my_base_sequence::type_id::create("bseq");
    bseq.seqr_h = env_o.agt.seqr;
    bseq.start(env_o.agt.seqr);
    phase.drop_objection(this);
  endtask :run_phase
  
endclass :my_base_test

`endif //GUARD_MY_BASE_TEST_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_err_test.sv
// Project :  Understanding UVM Callback
// Purpose :  Error Test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_ERR_TEST_SV
`define GUARD_MY_ERR_TEST_SV

class my_err_test extends my_base_test;
  
  `uvm_component_utils(my_err_test)
  
  my_sequence_callback seq_cb;
  
  
  function new(string name = "my_err_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq_cb = my_sequence_callback::type_id::create("seq_cb", this);
  endfunction :build_phase
  
  function void end_of_elaboration();
    super.end_of_elaboration();
    uvm_callbacks#(my_sequencer, my_callback)::add(env_o.agt.seqr,seq_cb);
  endfunction : end_of_elaboration
  
endclass :my_err_test

`endif //GUARD_MY_ERR_TEST_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding UVM Callback
// Purpose :  package File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_PACKAGE_SV
`define GUARD_MY_PACKAGE_SV

package my_package;
import uvm_pkg::*;

`include "my_seq_item.sv"
`include "my_callback.sv"
`include "my_sequence_callback.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_agent.sv"
`include "my_env.sv"
`include "my_base_sequence.sv"
`include "my_base_test.sv"
`include "my_err_test.sv"

endpackage :my_package
`endif //GUARD_MY_PACKAGE_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  testbench.sv
// Project :  Understanding UVM Callback
// Purpose :  tb_top File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
//import uvm_pkg::*;         // Import UVM package for base classes and utilities
`include "uvm_macros.svh"   // Include UVM macros for logging and other utilities
`include "my_package.sv"  // Include the package containing other necessary definitions
import my_package::*;    // Import the package that includes transaction and environment classes
module tb_top;
  initial begin
    //run_test("my_base_test");
    //run_test("my_err_test");
    run_test();
  end
endmodule :tb_top

//LogFile output using Synopsys VCs Tool (with +UVM_TESTNAME =my_base_test)
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
CPU time: 8.228 seconds to compile + .282 seconds to elab + .515 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 19 09:32 2025
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
UVM_INFO my_base_sequence.sv(26) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [my_base_sequence] Base seq: Inside Body
UVM_INFO my_driver.sv(27) @ 0: uvm_test_top.env_o.agt.drv [uvm_test_top.env_o.agt.drv] Driving pkt = 
---------------------------------
Name    Type         Size  Value 
---------------------------------
req     my_seq_item  -     @578  
  addr  integral     16    'he157
  data  integral     16    'h96b 
  pkt   pkt_type     32    GOOD  
---------------------------------

UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 50: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 50: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    5
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[my_base_sequence]     1
[uvm_test_top.env_o.agt.drv]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                   50
           V C S   S i m u l a t i o n   R e p o r t 
Time: 50 ns
CPU Time:      0.350 seconds;       Data structure size:   0.2Mb
Sat Jul 19 09:32:55 2025
Done

//LogFile output using Synopsys VCs Tool (with +UVM_TESTNAME =my_err_test)

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
CPU time: 7.876 seconds to compile + .261 seconds to elab + .522 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 19 09:34 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_err_test...
UVM_INFO my_base_sequence.sv(26) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [my_base_sequence] Base seq: Inside Body
UVM_INFO my_sequence_callback.sv(22) @ 0: reporter [seq_cb] Inside modify_pkt method: Injecting error in the seq item
-----------------------------------
Name    Type         Size  Value   
-----------------------------------
req     my_seq_item  -     @580    
  addr  integral     16    'hffff  
  data  integral     16    'h96b   
  pkt   pkt_type     32    BAD_ERR1
-----------------------------------
UVM_INFO my_driver.sv(27) @ 0: uvm_test_top.env_o.agt.drv [uvm_test_top.env_o.agt.drv] Driving pkt = 
-----------------------------------
Name    Type         Size  Value   
-----------------------------------
req     my_seq_item  -     @580    
  addr  integral     16    'hffff  
  data  integral     16    'h96b   
  pkt   pkt_type     32    BAD_ERR1
-----------------------------------

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
[my_base_sequence]     1
[seq_cb]     1
[uvm_test_top.env_o.agt.drv]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                   50
           V C S   S i m u l a t i o n   R e p o r t 
Time: 50 ns
CPU Time:      0.310 seconds;       Data structure size:   0.2Mb
Sat Jul 19 09:34:01 2025
Done
