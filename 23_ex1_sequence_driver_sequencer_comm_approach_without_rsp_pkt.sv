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

//LogFile Output using Synopsys VCS Tool:




