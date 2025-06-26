Passing interface handle down the hierarchy in UVM:
  
-The axi_inf interface handle is stored or set in the configuration database with field_name as axi_interface from env class. 
-Down the hierarchy, it is retrieved or gets in the driver class using the same field_name.

set method call:
  
class env extends uvm_env;
    interface axi_if axi3_inf (clk , reset);
  ...
  `uvm_component_utils(env)

  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual axi_if)::set(null, "*", "axi_interface", axi3_inf );
    ...
  endfunction
  ...
  ...
endclass  

get method call:
      
class my_driver extends uvm_agent;
   virtual interface axi_if axi3_vif;;
  ...
  `uvm_component_utils(my_driver )
   
  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual axi_if)::get(this, "*", "axi_interface", axi3_vif)
    ...
  endfunction
  ...
  ...
endclass      
