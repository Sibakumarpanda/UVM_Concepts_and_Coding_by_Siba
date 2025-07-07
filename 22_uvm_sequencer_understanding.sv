UVM Sequencer Understanding:

-The sequencer is a mediator who establishes a connection between sequence and driver.
-Ultimately, it passes transactions or sequence items to the driver so that they can be driven to the DUT.
-uvm_sequencer class declaration: class uvm_sequencer #( type REQ  = uvm_sequence_item, RSP = REQ ) extends uvm_sequencer_param_base #(REQ, RSP)  
-A user-defined sequencer is recommended to extend from the parameterized base class “uvm_sequencer” which is parameterized by request (REQ) and response (RSP) item types. 
-Response item usage is optional. So, mostly sequencer class is extended from a base class that has only a REQ item.  
- declaration :  class my_sequencer extends uvm_sequencer #(data_item, data_rsp); // with rsp
                 class my_sequencer extends uvm_sequencer #(data_item);           // without rsp  
-TLM (Transaction Level Modelling) interface is used by sequencer and driver to pass transactions. 
-seq_item_export and seq_item_port TLM connect methods are defined in uvm_sequencer and uvm_driver class. The details are discussed in the sequence-driver-sequencer handshake section.    
//Sample code Snippet:
class my_sequencer extends uvm_sequencer #(data_item);
  `uvm_component_utils(my_sequencer)

  function new (string name, uvm_component parent);
    super.new(name, parent); 
  endfunction
endclass  :my_sequencer

  
