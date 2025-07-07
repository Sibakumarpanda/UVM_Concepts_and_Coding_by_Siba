//Example1: Example of without using Virtual Sequence and Sequencer concept

//seq_item class
class seq_item extends uvm_sequence_item;
  core_type core;
  `uvm_object_utils(seq_item)
  
  function new(string name = "seq_item");
    super.new(name);
  endfunction
  
endclass :seq_item

//Sequencer class - core_A_sequencer
class core_A_sequencer extends uvm_sequencer #(seq_item);
  `uvm_component_utils(core_A_sequencer)
  
  function new(string name = "core_A_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass :core_A_sequencer

//Sequencer class- core_B_sequencer
class core_B_sequencer extends uvm_sequencer #(seq_item);
  `uvm_component_utils(core_B_sequencer)
  
  function new(string name = "core_B_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass: core_B_sequencer

// Driver class- base_driver
class base_driver extends uvm_driver#(seq_item);
  `uvm_component_utils(base_driver)
  
  function new(string name = "base_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase (uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      void'(req.randomize());
      drive(req);
      seq_item_port.item_done();
    end
  endtask
  
  virtual task drive(seq_item req);
    `uvm_info(get_type_name(), "Driving from base_driver", UVM_LOW);
  endtask
endclass :base_driver

// Driver class- core_A_driver
class core_A_driver extends base_driver;
  `uvm_component_utils(core_A_driver)
  
  function new(string name = "core_A_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task drive(seq_item req);
    `uvm_info(get_type_name(), "Driving from core A", UVM_LOW);
    #50; // Drive to DUT
  endtask
endclass : core_A_driver

// Driver class- core_B_driver
class core_B_driver extends base_driver;
  `uvm_component_utils(core_B_driver)
  
  function new(string name = "core_B_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task drive(seq_item req);
    `uvm_info(get_type_name(), "Driving from core B", UVM_LOW);
    #50; // Drive to DUT
  endtask
endclass :core_B_driver

//Agent Class -core_A_agent
class core_A_agent extends uvm_agent;
  core_A_driver drv_A;
  core_A_sequencer seqr_A;
  `uvm_component_utils(core_A_agent)
  
  function new(string name = "core_A_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_A = core_A_driver::type_id::create("drv_A", this);
    seqr_A = core_A_sequencer::type_id::create("seqr_A", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv_A.seq_item_port.connect(seqr_A.seq_item_export);
  endfunction
endclass :core_A_agent

//Agent Class -core_B_agent
class core_B_agent extends uvm_agent;
  core_B_driver drv_B;
  core_B_sequencer seqr_B;
  `uvm_component_utils(core_B_agent)
  
  function new(string name = "core_B_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_B = core_B_driver::type_id::create("drv_B", this);
    seqr_B = core_B_sequencer::type_id::create("seqr_B", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv_B.seq_item_port.connect(seqr_B.seq_item_export);
  endfunction
endclass :core_B_agent

//Environment class- env
class env extends uvm_env;
  core_A_agent agt_A;
  core_B_agent agt_B;
  `uvm_component_utils(env)
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt_A = core_A_agent::type_id::create("agt_A", this);
    agt_B = core_B_agent::type_id::create("agt_B", this);
  endfunction
endclass :env

// Sequence Class -core_A_seq
class core_A_seq extends uvm_sequence #(seq_item);
  seq_item req;
  `uvm_object_utils(core_A_seq)
  
  function new (string name = "core_A_seq");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(get_type_name(), "core_A_seq: Inside Body", UVM_LOW);
    req = seq_item::type_id::create("req");
    req.core = CORE_A;
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done();
  endtask
endclass :core_A_seq

// Sequence Class -core_B_seq
class core_B_seq extends uvm_sequence #(seq_item);
  seq_item req;
  `uvm_object_utils(core_B_seq)
  
  function new (string name = "core_B_seq");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(get_type_name(), "core_B_seq: Inside Body", UVM_LOW);
    req = seq_item::type_id::create("req");
    req.core = CORE_B;
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done();
  endtask
endclass :core_B_seq

// Test Class- base_test

`include "uvm_macros.svh"
import uvm_pkg::*;
typedef enum {CORE_A, CORE_B} core_type;
`include "seq_item.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "agent.sv"
`include "env.sv"
`include "sequence.sv"

class base_test extends uvm_test;
  env env_o;
  
  core_A_seq Aseq;
  core_B_seq Bseq;
  
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
    Aseq = core_A_seq::type_id::create("Aseq");
    Bseq = core_B_seq::type_id::create("Bseq");
    
    Aseq.start(env_o.agt_A.seqr_A);
    Bseq.start(env_o.agt_B.seqr_B);
    
    phase.drop_objection(this);
  endtask
endclass :base_test

module tb_top;
  initial begin
    run_test("base_test");
  end
endmodule :tb_top

//Logfile output using Cadence Xcelium Tool
[2025-07-07 08:53:43 UTC] xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
TOOL:	xrun	23.09-s001: Started on Jul 07, 2025 at 04:53:43 EDT
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
UVM_INFO sequence.sv(10) @ 0: uvm_test_top.env_o.agt_A.seqr_A@@Aseq [core_A_seq] core_A_seq: Inside Body
UVM_INFO driver.sv(38) @ 0: uvm_test_top.env_o.agt_A.drv_A [core_A_driver] Driving from core A
UVM_INFO sequence.sv(30) @ 50: uvm_test_top.env_o.agt_B.seqr_B@@Bseq [core_B_seq] core_B_seq: Inside Body
UVM_INFO driver.sv(55) @ 50: uvm_test_top.env_o.agt_B.drv_B [core_B_driver] Driving from core B
UVM_INFO /xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_objection.svh(1271) @ 100: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_report_server.svh(847) @ 100: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    7
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[core_A_driver]     1
[core_A_seq]     1
[core_B_driver]     1
[core_B_seq]     1

Simulation complete via $finish(1) at time 100 NS + 63
/xcelium23.09/tools/methodology/UVM/CDNS-1.2/sv/src/base/uvm_root.svh:543     $finish;
xcelium> exit
TOOL:	xrun	23.09-s001: Exiting on Jul 07, 2025 at 04:53:52 EDT  (total: 00:00:09)
Done
