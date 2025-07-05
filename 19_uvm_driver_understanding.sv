UVM Driver understanding:
-The driver interacts with DUT. 
-It drives randomized transactions or sequence items to DUT as a pin-level activity using an interface. 
-The driver has to be extended from uvm_component names as uvm_driver. 
-The transaction or sequence items are retrieved from the sequencer and the driver drives them to the design using the interface handle. 
-An interface handle can be retrieved from the configuration database which was already set in the top-level hierarchy.
-The uvm_driver class is a parameterized class of type REQ sequence_item and RSP sequence item.
-RSP sequence item is optional. 
-Usually, the REQ and RSP sequence item has the same class type. They can be different if it is declared specifically.

uvm_driver class declaration:    class uvm_driver #( type REQ = uvm_sequence_item, type RSP = REQ ) extends uvm_component  

How to write the driver code?
  
-Create a user-defined driver class extended from uvm_driver and register it in the factory.
-Declare virtual interface handle to retrieve actual interface handle using configuration database in the build_phase.
-Write standard new() function. Since the driver is a uvm_component. The new() function has two arguments as string name and uvm_component parent.
-Implement build_phase and get interface handle from the configuration database.
-Implement run_phase to get the sequence items and drive them to the DUT using a virtual interface handle.  

//UVM Driver Sample code Snippet :
class driver extends uvm_driver#(seq_item);
  virtual add_if vif;
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Not set at top level");
  endfunction
  
  task run_phase (uvm_phase phase);
    // Get the sequence_item and drive it to DUT
  endtask
endclass
  


  
  
