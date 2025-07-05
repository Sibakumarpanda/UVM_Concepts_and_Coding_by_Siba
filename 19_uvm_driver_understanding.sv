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
class my_driver extends uvm_driver#(seq_item);
  virtual add_if vif;
  `uvm_component_utils(my_driver)
  
  function new(string name = "my_driver", uvm_component parent = null);
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
endclass :my_driver
  
How to get sequence items from the sequencer?
-TLM (Transaction Level Modelling) interface is used by the driver of type uvm_seq_item_pull_port to accept a series of REQ sequence items from the sequencer.
-The driver can provide optional RSP sequence items back to the sequencer if required. The details can be more discussed at Sequence-Driver-Sequencer communication section.
-UVM driver methods: There are two ways to interact with the sequencer as below.
    1. Using get_next_item/ try_next_item and item_done methods
    2. Using get and put methods

1. Using get_next_item/ try_next_item and item_done methods:
-Let’s first understand get_next_item, try_next_item and item_done methods

Type                                     Methods                                  Description  
  
task                                     get_next_item (output REQ item )         It is a blocking method that blocks until the REQ item is available in the sequencer’s request FIFO.

task                                     try_next_item  (output REQ item )        It is a non-blocking method that returns the handle of the REQ item if it is available in the sequencer’s request FIFO 
                                                                                  otherwise, it returns null.
  
function                                 item_done  (RSP item = null)            It is a non-blocking method that has to be called after get_next_item or successful try_next_item to complete the 
                                                                                 driver-sequencer handshake. 
                                                                                 It may pass the RSP sequence item as an argument to place it in the sequencer’s response FIFO.
                                                                                 If no argument or null pointer is passed to the item_done function, it can also complete the driver-sequencer handshake. 
                                                                                   
// Sample code Snippet: In run_phase of driver using get_next_item and item_done
 task run_phase (uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    // Driving logic
    ...
    seq_item_port.item_done();
  end
endtask  
                                                                                   
NOTE: In this approach, get_next_item or successful try_next_item retrieves the REQ sequence item to drive it to the DUT using the virtual interface handle. 
      The item_done method has to be called once driving logic is completed.
                                                                                   
2. Using get and put methods:

Methods                    Description

get                        It is a blocking method that blocks until a REQ item is available in the sequencer’s request FIFO. 
                           Any further calls to get() without put() call will result in a pointer for the next REQ item.  
                             
peek                       It is a blocking method that blocks until a REQ item is available in the sequencer’s request FIFO. 
                           Any further calls to peek() without put() or item_done() call will result in a pointer for the same REQ item.

put                        It is a non-blocking method that is used to place RSP item in the sequencer’s response FIFO. 
                           The put() is not connected to the driver-sequencer handshake mechanism. Hence, it can be called at any time.

// Sample code Snippet: In run_phase of driver using get and put method
task run_phase (uvm_phase phase);
  forever begin
    seq_item_port.get(req);
    // Driving logic
    ...
    seq_item_port.put(rsp_item);
  end
endtask 

Difference between get_next_item/ item_done and get/ put approach?
  
 1.The item_done must be called after get_next_item() or successful try_next_item() call, then only the next sequence item can be requested. 
   Whereas, get() call can request another request item even if the put() method is not called.
 2.The put() call must be called with the RSP sequence item as an argument whereas it is optional for item_done() call. 
 3.In the case of get_next_item/ item_done approach, wait_for_item_done task (uvm_sequence_base class method) gets unblocked when item_done is called from the 
   driver once transactions are driven to the DUT using a virtual interface. 
   In the case of get/put approach, the wait_for_item_done gets unblocked when a put method is called from the driver where a driver has had any time to process and drive the sequence item.
 4.Since the sequence writer has to remember the handle of the response item, the get/put approach is more complicated to implement than the get_next_item/ item_done approach.  




  
  
  
