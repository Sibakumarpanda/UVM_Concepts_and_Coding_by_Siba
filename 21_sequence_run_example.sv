//Sequence item or Transaction class
class seq_item extends uvm_sequence_item;
  rand int a;
  `uvm_object_utils(seq_item)
  
  function new(string name = "seq_item");
    super.new(name);
  endfunction
  
endclass :seq_item

//Sequencer Class
class sequencer extends uvm_sequencer #(seq_item);
  `uvm_component_utils(sequencer)
  
  function new(string name = "sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass : sequencer

//Driver class
class driver extends uvm_driver#(seq_item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      void'(req.randomize());
      `uvm_info(get_type_name(), "Driving logic", UVM_LOW);
      #50; // Driving delay. Assuming time taken to drive RTL signals
      seq_item_port.item_done();
    end
  endtask
endclass :driver

//agent class
class agent extends uvm_agent;
  driver drv;
  sequencer seqr;
  `uvm_component_utils(agent)
  
  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = driver::type_id::create("drv", this);
    seqr = sequencer::type_id::create("seqr", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass :agent

//env class
class env extends uvm_agent;
  agent agt;
  `uvm_component_utils(env)
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = agent::type_id::create("agt", this);
  endfunction
endclass :env

//base sequence class
class base_seq extends uvm_sequence #(seq_item);
  seq_item req;
  `uvm_object_utils(base_seq)
  
  function new (string name = "base_seq");
    super.new(name);
  endfunction

  task pre_start();
    `uvm_info(get_type_name(), "Base seq: Inside pre_start", UVM_LOW);
  endtask
  
  task pre_body();
    `uvm_info(get_type_name(), "Base seq: Inside pre_body", UVM_LOW);
  endtask
  
  virtual task pre_do(bit is_item);
    `uvm_info(get_type_name(), "Base seq: Inside pre_do", UVM_LOW);
  endtask
  
  virtual function void mid_do(uvm_sequence_item this_item);
    `uvm_info(get_type_name(), "Base seq: Inside mid_do", UVM_LOW);
  endfunction
  
  task body();
    `uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
    `uvm_do(req); // Calls all pre_do, mid_do and post_do methos.
    /*
    req = seq_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done(); */
  endtask
  
  virtual function void post_do(uvm_sequence_item this_item);
    `uvm_info(get_type_name(), "Base seq: Inside post_do", UVM_LOW);
  endfunction
  
  task post_body();
    `uvm_info(get_type_name(), "Base seq: Inside post_body", UVM_LOW);
  endtask
endclass :base_seq

//child sequence
class child_seq extends base_seq;
  `uvm_object_utils(child_seq)
  
  function new (string name = "child_seq");
    super.new(name);
  endfunction

  task pre_start();
    `uvm_info(get_type_name(), "Child seq: Inside pre_start", UVM_LOW);
  endtask
  
  task pre_body();
    `uvm_info(get_type_name(), "Child seq: Inside pre_body", UVM_LOW);
  endtask
  
  task pre_do(bit is_item);
    `uvm_info(get_type_name(), "Child seq: Inside pre_do", UVM_LOW);
  endtask
  
  function void mid_do(uvm_sequence_item this_item);
    `uvm_info(get_type_name(), "Child seq: Inside mid_do", UVM_LOW);
  endfunction
  
  task body();
    `uvm_info(get_type_name(), "Child seq: Inside Body", UVM_LOW);
     //`uvm_do(req); // Calls all pre_do, mid_do and post_do methos.
    
    /*req = seq_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done();*/
    
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize());
    finish_item(req);
  endtask
  
  function void post_do(uvm_sequence_item this_item);
    `uvm_info(get_type_name(), "Child seq: Inside post_do", UVM_LOW);
  endfunction
  
  task post_body();
    `uvm_info(get_type_name(), "Child seq: Inside post_body", UVM_LOW);
  endtask
endclass :child_seq

//base test class
class base_test extends uvm_test;
  env env_o;
  sequencer seqr;
  base_seq bseq;
  child_seq cseq;
  `uvm_component_utils(base_test)
  
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bseq = base_seq::type_id::create("bseq");
    cseq = child_seq::type_id::create("cseq");
    
    bseq.start(env_o.agt.seqr);
    $display("-----------------------------------------------------------------------------------");
    cseq.start(env_o.agt.seqr);
    $display("-----------------------------------------------------------------------------------");
    cseq.start(env_o.agt.seqr, bseq); // Comment this line Or comment above line to notice a difference.
    
    phase.drop_objection(this);
  endtask
endclass :base_test

//TB TOP Module
module tb_top;
  initial begin
    run_test("base_test");
  end
endmodule :tb_top

//Log File Output using Cadence Xcelium Tool
[2025-07-07 04:38:59 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 07, 2025 at 00:39:00 EDT
xrun: 23.09-s001: (c) Copyright 1995-2023 Cadence Design Systems, Inc.
	Top level design units:
		uvm_pkg
		$unit_0x4ccdf83b
		tb_top
Loading snapshot worklib.tb_top:sv .................... Done
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

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
UVM_INFO testbench.sv(19) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside pre_start
UVM_INFO testbench.sv(23) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside pre_body
UVM_INFO testbench.sv(35) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside Body
UVM_INFO testbench.sv(27) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside pre_do
UVM_INFO testbench.sv(31) @ 0: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside mid_do
UVM_INFO driver.sv(16) @ 0: uvm_test_top.env_o.agt.drv [driver] Driving logic
UVM_INFO testbench.sv(46) @ 50: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside post_do
UVM_INFO testbench.sv(50) @ 50: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside post_body
-----------------------------------------------------------------------------------
UVM_INFO testbench.sv(62) @ 50: uvm_test_top.env_o.agt.seqr@@cseq [child_seq] Child seq: Inside pre_start
UVM_INFO testbench.sv(66) @ 50: uvm_test_top.env_o.agt.seqr@@cseq [child_seq] Child seq: Inside pre_body
UVM_INFO testbench.sv(78) @ 50: uvm_test_top.env_o.agt.seqr@@cseq [child_seq] Child seq: Inside Body
UVM_INFO testbench.sv(70) @ 50: uvm_test_top.env_o.agt.seqr@@cseq [child_seq] Child seq: Inside pre_do
UVM_INFO testbench.sv(74) @ 50: uvm_test_top.env_o.agt.seqr@@cseq [child_seq] Child seq: Inside mid_do
UVM_INFO driver.sv(16) @ 50: uvm_test_top.env_o.agt.drv [driver] Driving logic
UVM_INFO testbench.sv(94) @ 100: uvm_test_top.env_o.agt.seqr@@cseq [child_seq] Child seq: Inside post_do
UVM_INFO testbench.sv(98) @ 100: uvm_test_top.env_o.agt.seqr@@cseq [child_seq] Child seq: Inside post_body
-----------------------------------------------------------------------------------
UVM_INFO testbench.sv(62) @ 100: uvm_test_top.env_o.agt.seqr@@bseq.cseq [child_seq] Child seq: Inside pre_start
UVM_INFO testbench.sv(66) @ 100: uvm_test_top.env_o.agt.seqr@@bseq.cseq [child_seq] Child seq: Inside pre_body
UVM_INFO testbench.sv(27) @ 100: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside pre_do
UVM_INFO testbench.sv(31) @ 100: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside mid_do
UVM_INFO testbench.sv(78) @ 100: uvm_test_top.env_o.agt.seqr@@bseq.cseq [child_seq] Child seq: Inside Body
UVM_INFO testbench.sv(70) @ 100: uvm_test_top.env_o.agt.seqr@@bseq.cseq [child_seq] Child seq: Inside pre_do
UVM_INFO testbench.sv(74) @ 100: uvm_test_top.env_o.agt.seqr@@bseq.cseq [child_seq] Child seq: Inside mid_do
UVM_INFO driver.sv(16) @ 100: uvm_test_top.env_o.agt.drv [driver] Driving logic
UVM_INFO testbench.sv(94) @ 150: uvm_test_top.env_o.agt.seqr@@bseq.cseq [child_seq] Child seq: Inside post_do
UVM_INFO testbench.sv(46) @ 150: uvm_test_top.env_o.agt.seqr@@bseq [base_seq] Base seq: Inside post_do
UVM_INFO testbench.sv(98) @ 150: uvm_test_top.env_o.agt.seqr@@bseq.cseq [child_seq] Child seq: Inside post_body
UVM_INFO /xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_objection.svh(1271) @ 150: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_report_server.svh(847) @ 150: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   30
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[base_seq]    10
[child_seq]    14
[driver]     3

Simulation complete via $finish(1) at time 150 NS + 63
/xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_root.svh:543     $finish;
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 07, 2025 at 00:39:09 EDT  (total: 00:00:09)
Done
