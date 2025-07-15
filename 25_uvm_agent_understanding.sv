UVM Agent Understanding:
-An agent is a container that holds and connects the driver, monitor, and sequencer instances. 
-The agent develops a structured hierarchy based on the protocol or interface requirement.
-uvm_agent class declaration: virtual class uvm_agent extends uvm_component 
-User-defined class declaration: The user-defined agent has to be extended from the uvm_agent component class.
   Syntax:  class <agent_name> extends uvm_agent;  

How to create a UVM agent?
-Create a user defined agent class extended from uvm_agent and register it in the factory.
-In the build_phase, instantiate driver, monitor, and sequencer, if it is an active agent. 
-Instantiate monitor alone if it is a passive agent.
-In the connect_phase, connect driver and sequencer components.   

Types of Agent :
-There are two types of agents
  1.Active agent
  2.Passive agent
  -Active Agent: An Active agent drives stimulus to the DUT. It instantiates all three components driver, monitor, and sequencer. 
  -Passive Agent: A passive agent does not drive stimulus to the DUT. It instantiates only a monitor component. It is used as a sample interface for coverage and checker purposes.

How to configure the agent as an active or passive agent???
-An agent is usually instantiated at UVM environment class. 
-So, it can be configured in the environment or any other component class where an agent is instantiated using int configuration parameter is_active as shown below.
      set_config_int("<path_to_agent>", "is_active", UVM_ACTIVE);
      set_config_int("<path_to_agent>", "is_active", UVM_PASSIVE);
-Note: By default, all agents are configured as UVM_ACTIVE.    
  
