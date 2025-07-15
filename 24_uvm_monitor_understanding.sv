UVM Monitor Understanding:
-A UVM monitor is a passive component used to capture DUT signals using a virtual interface and translate them into a sequence item format.
-Note that already we are aware that , active agent contais the three component as sequencer , driver , monitor . And Passive component contains only Monitor .
-These sequence items or transactions are broadcasted to other components like the UVM scoreboard, coverage collector, etc.
-It uses a TLM analysis port to broadcast transactions.
-uvm_monitor class declaration:    virtual class uvm_monitor extends uvm_component
-A user defined monitor has to be extended from uvm_monitor which is derived from uvm_component.
-Syntax : class <monitor_name> extends uvm_monitor;

Purpose of Monitor:
-Capture signal level information and translate it into the transaction.
-Broadcast transactions to other components using TLM port for coverage collection and checking purposes (scoreboard).
-It can also control them with enable/ disable knobs if required.
-Capture protocol specific information and forward it to the related scoreboard or checker where protocol check happens . 

How to create a UVM monitor???
  
-Create a user-defined monitor class extended from uvm_monitor and register it in the factory.
-Declare virtual interface handle to retrieve actual interface handle using configuration database in the build_phase.
-Declare analysis port to broadcast the sequence items or transactions.
-Write standard new() function. Since the monitor is a uvm_component. The new() function has two arguments as string name and uvm_component parent.
-Implement build_phase and get interface handle from the configuration database.
-Implement run_phase to sample DUT interface using a virtual interface handle and translate into transactions. 
-The write() method sends transactions to the collector component. 

//UVM_Monitor code Snippet
 class my_monitor extends uvm_monitor;
  // declaration for the virtual interface, analysis port, and monitor sequence item.
   seq_item mon_item;
   virtual add_if vif;
   
  uvm_analysis_port #(seq_item) item_collect_port;
  `uvm_component_utils(my_monitor)
  
  // constructor
  function new(string name = "my_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collect_port = new("item_collect_port", this);
    mon_item = new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Not set at top level");
  endfunction
  
  task run_phase (uvm_phase phase);
    forever begin
      // Sample DUT information and translate into transaction
      item_collect_port.write(mon_item);
    end
  endtask
endclass :my_monitor

 
