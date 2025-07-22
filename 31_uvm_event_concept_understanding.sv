UVM Event Understanding:

-The event mechanism provides synchronization between processes. 
-The UVM event provides additional flexibility over the System Verilog event like maintaining the number of event waiters and setting callbacks.
-uvm_event class declaration:
   virtual class uvm_event_base extends uvm_object
   class uvm_event#(type T=uvm_object) extends uvm_event_base;
     
-For UVM 1.2, the uvm_event_base class is an abstract wrapper class over the System Verilog event construct and the uvm_event class is an extension of the uvm_event_base class.
-For UVM1.1d, an abstract uvm_event_base class does not exist. The uvm_event class is directly derived from the uvm_object class.
-The events provide synchronization between processes by triggering an event from one process and waiting for that event in another process to be triggered. 
-The UVM event can also pass data when it is triggered that makes it different from the SV event.
     
uvm_event_base class method                               
  
Type                Methods                         Description

function            new                            Creates a new object for the event
  
task                wait_on                        Waits for the event to be activated for the first time until the event is reset. This task returns immediately if the event has already been triggered.  

task                wait_off                       For an already triggered event, this task waits for an event to be turned ‘off’ via a call to reset function.  
