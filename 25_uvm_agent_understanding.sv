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

-There are two ways we can do the above configuration. they are
   1. configure agent type with set_config_int
   2. configure agent type with uvm_config_db
       
 1. configure agent type with set_config_int:   
-An agent is usually instantiated at UVM environment class. 
-So, it can be configured in the environment or any other component class where an agent is instantiated using int configuration parameter is_active as shown below.
      set_config_int("<path_to_agent>", "is_active", UVM_ACTIVE);
      set_config_int("<path_to_agent>", "is_active", UVM_PASSIVE);
-Note: By default, all agents are configured as UVM_ACTIVE. 
-The set_config_int method is deprecated in uvm1.2. If you run code with uvm1.2, following UVM_WARNING is expected.
   UVM_WARNING: uvm_test_top.env_o [UVM/CFG/SET/DPR] get/set_config_* API has been deprecated. Use uvm_config_db instead.
- For better understanding , an example is created in below link ,
     Link:

2. configure agent type with uvm_config_db  
     Link:

How does the user-defined agent know whether it is an active or passive agent?

-The get_is_active() function is used to find out the type of agent. 
-The driver, sequencer instances are created if it is an active agent and monitor instance can be created by default irrespective of agent type.
-The get_is_active() function returns an enum as UVM_ACTIVE or UVM_PASSIVE of type uvm_active_passive_enum.
- For better understanding , the below code will be helpful .
   
//Active agent Sample code
class a_agent extends uvm_agent;
  driver drv;
  sequencer seqr;
  monitor_A mon_A;
  `uvm_component_utils(a_agent)
  
  function new(string name = "a_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      drv = driver::type_id::create("drv", this);
      seqr = sequencer::type_id::create("seqr", this);
      `uvm_info(get_name(), "This is Active agent", UVM_LOW);
    end
    mon_A = monitor_A::type_id::create("mon_A", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass :a_agent

//Passive agent code
class p_agent extends uvm_agent;
  monitor_B mon_B;
  `uvm_component_utils(p_agent)
  
  function new(string name = "p_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_PASSIVE) begin
      mon_B = monitor_B::type_id::create("mon_B", this);
      `uvm_info(get_name(), "This is Passive agent", UVM_LOW);
    end
  endfunction
endclass :p_agent  
   
     
   
   
