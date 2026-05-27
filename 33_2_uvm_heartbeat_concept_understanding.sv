UVM Heartbeat Concept Understanding:
-The UVM Heartbeat acts as a watchdog timer that provides a flexible way for the environment to ensure that their descendants are alive. 
-The uvm_heartbeat class is derived from uvm_object and it is associated with a specific objection object.

UVM Heartbeat Usage :
-The UVM heartbeat can detect simulation hang or lock-up conditions at an early stage rather than the expiry of the global simulation timeout. 
-Thus, it can save the simulation time and terminate it at an early state. 
-The lock-up may happen due to FSM issues, race around conditions between two communicating modules waiting for the response for transmitted packet or
  packet is not being transmitted, etc.  

UVM Heartbeat Working :
-The uvm_heartbeat monitor activity for an objection object. 
-The UVM Heartbeat detects testbench activity for registered components based on raises or drops objections on that objection object during the heartbeat monitor window. 
-If the heartbeat monitor does not see any activity in that window, FATAL is issued and simulation is terminated.
-Note: The UVM 1.1d has an objection object of type uvm_callbacks_objection which is derived from uvm_objection class.
-UVM 1.2 has an objection object of uvm_objection class. 
  
uvm_heartbeat Methods :
  
Method                    Definition                                              Description

  new                     function new (string name,                              The uvm_heartbeat constructor creates a new heartbeat instance associated with cntxt.
                                        uvm_component cntxt,                      name: instance name for uvm_heartbeat.
                                          uvm_objection objection = null )        cntxt: Specifies context where heartbeat objections will be monitored. 
                                                                                         The ‘this’ keyword is usually passed
                                                                                  objection: Represents the objections that are being monitored by heartbeat. 
                                                                                  It is optional. It can be null but it must be set before activation of the heartbeat monitor.  





.

