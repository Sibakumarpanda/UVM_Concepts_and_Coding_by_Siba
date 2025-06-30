UVM Environment Understanding:
-An environment provides a well-mannered hierarchy and container for agents, scoreboards and other verification components .
-The other verif component includes other environment classes that are helpful in reusing block-level environment components at the SoC level. 
-The user-defined env class has to be extended from the uvm_env class.

Class Declaration :                    virtual class uvm_env extends uvm_component;
User-defined env class declaration :   class <env_name> extends uvm_env;
  
Steps for how to create a UVM env?
  
-Create a user-defined env class extended from uvm_env and register it in the factory.
-In the build_phase, instantiate the agent, other verification components and use the configuration database to set/get configuration variables.
-In the connect_phase, connect the monitor, scoreboard and other functional coverage components using the TLM interface.  


UVM Environment
An environment provides a well-mannered hierarchy and container for agents, scoreboards, and other verification components including other environment classes that are helpful in reusing block-level environment components at the SoC level. The user-defined env class has to be extended from the uvm_env class.

UVM Environment block diagram
uvm_env class hierarchy
uvm_env hierarchy
Class Declaration

virtual class uvm_env extends uvm_component;
User-defined env class declaration

class <env_name> extends uvm_env;
How to create a UVM env?
Steps:

Create a user-defined env class extended from uvm_env and register it in the factory.
In the build_phase, instantiate the agent, other verification components, and use the configuration database to set/get configuration variables.
In the connect_phase, connect the monitor, scoreboard, and other functional coverage components using the TLM interface.
  
// UVM Environment Sample example :
  
class my_env extends uvm_env;
  `uvm_component_utils(my_env)
  agent agt;
  scoreboard sb;
  func_cov fcov;
 
  function new(string name = "my_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = agent::type_id::create("agt", this);
    sb = scoreboard::type_id::create("sb", this);
    fcov = func_cov::type_id::create("fcov", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    // connect agent and scoreboard using TLM interface    
    // Ex. agt.mon.item_collect_port.connect(sb.item_collect_export);
  endfunction
  
endclass :my_env

//How to instantiate multiple env in top_env:
  
class top_env extends uvm_env;
  my_env env_o[3];
  `uvm_component_utils(top_env)
 
  function new(string name = "top_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach(env_o[i])
      env_o[i] = my_env::type_id::create("$sformatf("env_o_%0d", i)", this);
  endfunction
  ...
endclass : top_env 
  
