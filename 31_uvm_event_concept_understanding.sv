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
     
uvm_event_base class method :                               
  
Type                Methods                         Description

function            new                            Creates a new object for the event
  
task                wait_on                        Waits for the event to be activated for the first time until the event is reset. This task returns immediately if the event has already been triggered.  

task                wait_off                       For an already triggered event, this task waits for an event to be turned ‘off’ via a call to reset function.  

task                wait_trigger                   Waits for the event to be triggered   

task                wait_ptrigger                  Waits for a persistent trigger of the event. The trigger views as persistent within a given time slice to avoid a race condition. 

function            is_on                          Returns 1 if an event has triggered.  

function            is_off                         Returns 1 if an event has not been triggered.

function            get_trigger_time               To get time at which event was last triggered. The time reruns 0 if an event has been reset or not triggered.

function            reset                          Resets event to its off state. No callbacks are called during reset.  

function            get_num_waiters                Returns the number of processes waiting on that event.   

function            cancel                         Decrement the number of waiters at the event. 

uvm_event class methods :
   
Type               Methods                         Description 

function           new                             Creates a new object for the event  

function           trigger                         Triggers the event for resuming all waiting processes. It also has an optional data argument to provide trigger-specific information.   

function           get_trigger_data                Gets the data information provided by the last trigger function call if any. 

task               wait_trigger_data               This method calls uvm_event_base::wait_trigger followed by get_trigger_data.  

task               wait_ptrigger_data              This method calls uvm_event_base::wait_ptrigger followed by get_trigger_data.

function           add_callback                    Registers a callback cb object with the event. It may include pre-trigger and post_trigger functionality

function           delete_callback                 Unregisters the given callback cb from the event.  


Various examples with to understand the uvm_event concept : All examples can be found in below link .
   Link : https://github.com/Sibakumarpanda/UVM_Concepts_and_Coding_by_Siba/blob/main/31_uvm_event_various_posible_example.sv
  
   1. Event is triggered using e1.trigger and waiting for the event to be triggered via the wait_trigger (e1.wait_trigger) method
      a. Type A1: An event is triggered after waiting for the event trigger
      b. Type B1: An event is triggered before waiting for the event trigger
      c. Type C1: An event is triggered at the same time as waiting for the event trigger  

   2. Event is triggered using e1.trigger and waiting for the event to be triggered via the wait_ptrigger (e1.wait_ptrigger) method      
      a. Type A2: An event is triggered after waiting for the event trigger
      b. Type B2: An event is triggered before waiting for event trigger
      c. Type C2: An event is triggered at the same time as waiting for the event trigger 

   3.  Event is triggered with data (e1.trigger(tr_A)) and waiting for the event to be triggered and retrieve data using wait_on and get_trigger_data
      a. Type A3: retrieve data using wait_on and get_trigger_data.   
      b. Type B3: retrieve data using wait_trigger_data
      c. Type C3: retrieve data using wait_ptrigger_data 
     
