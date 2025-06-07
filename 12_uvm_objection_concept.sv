UVM Objection Concept:

-It provides a mechanism to coordinate status information between two or more components, objects. 
-The uvm_objection class is extended from uvm_report_object.
-The objection deals with the concept of raise and drop objection which means the internal counter is increment and decrement respectively. 
-Each participating component and object may raise or drop objections asynchronously. 
-When all objections are dropped, the counter value will become zero. 
-The objection has to be raised before starting any process and drop it once it is completed.
  
Decleration :  
class uvm_objection extends uvm_report_object  

UVM Objection Usage:
-UVM phasing mechanism uses objections to coordinate with each other and the phase should be ended when all objections are dropped. 
-They can be used in all UVM phases.
-It allows proceeding for the “End of test”. 
-The simulation time-consuming activity happens in the run phase. 
-If all objections dropped for run phases, it means simulation activity is completed. Then , The test can be ended after executing the next phase that is clean up phases.
-Objections are generally used in components and sequences.
-Other objects can also use them but they must use a component or sequence object context.

Where to place raise and drop objection ???
task reset_phase( uvm_phase phase);
  phase.raise_objection(this);
  ...
  phase.drop_objection(this);
endtask

task run_phase(uvm_phase phase);
  phase.raise_objection(this, "Raised Objection");
  ...
  phase.drop_objection(this, "Dropped Objection");
endtask

Methods in uvm_objection :
  
Methods                                                                                                   Description  
raise_objection (uvm_object obj = null, string description = ” “, int count = 1)                          Raises number of objections for corresponding object with default count = 1  
drop_objection (uvm_object obj = null, string description = ” “, int count = 1)                           Drops number of objections for corresponding object with default count = 1
  set_drain_time (uvm_object obj=null, time drain)                                                        Sets drain time for corresponding objects

Where , Drain Time: The amount of wait time between all objections has been dropped and calling all_dropped() callback is called drain time.
    
Callback Hooks: 
The callback methods are defined in the uvm_objection_callback class which is derived from the uvm_callback class.
  
Callback Hooks                                                            Description    
raised                                                                    Called when an objection is raised for this component or its derived classes.  
dropped                                                                   Called when an objection is dropped for this component or its derived classes.
all_dropped                                                               Called when all objections are dropped for this component and its derived classes.
    
UVM Objections Examples: (Below examples helps to understand intention and it provide clarity for the objection mechanism.Not the full code containing sequnce/sequencer/driver mechanism)
  1. An objection can be used in the test class component (In the run_phase)
  2. An objection can be used in the sequence class (Either in body tasks or pre_body/ post_body tasks) 
