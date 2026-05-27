Singleton Object in UVM Understanding :

-The singleton object is nothing but a single object for the class. 
-The same object is returned even if a user tries to create multiple new objects. 
-The class that allows creating a single object is called a singleton class.
-In UVM, the uvm_root class has only one instance. Hence, it is said to be a singleton class.

Singleton Object Usage:
-A singleton object is useful wherever it is required to create a single object and want to restrict the user to create another object. 
-For example, configuration classes can be written to behave as a singleton class.
-Note: System Verilog and UVM do not have a separate construct to create a singleton object.

A basic example code snippet to understand :
-In the below example, there are two handles for the same singleton component sc1 and sc2 and objects have been tried to create twice. 
-But on creating an object using handle sc2, separate memory will not be allotted and sc2 handle points to a memory allocated using handle sc1.  

`include "uvm_macros.svh"
import uvm_pkg::*;

class singleton_comp extends uvm_component;
  static singleton_comp s_comp;
  rand bit [7:0] addr;
  rand bit [7:0] data;
  
  `uvm_component_utils_begin(singleton_comp)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_component_utils_end
  
  function new(string name = "singleton_comp", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  static function singleton_comp create_singleton();
    if(s_comp == null) begin
      $display("creating new object as it found null");
      s_comp = new();
    end
    else $display("object already exist, separate memory will not be allocated.");
    return s_comp;
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
endclass :singleton_comp

class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  singleton_comp sc1, sc2;

  function new(string name = "base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // create singleton object
    sc1 = singleton_comp::create_singleton();
    assert(sc1.randomize());
    `uvm_info(get_type_name, $sformatf("Printing sc1 = \n%s",sc1.sprint()), UVM_LOW);
    
    // Trying to create another object but it won't be created
    sc2 = singleton_comp::create_singleton();
    `uvm_info(get_type_name, $sformatf("Printing sc2 = \n%s",sc2.sprint()), UVM_LOW);
  endfunction : build_phase
endclass :base_test

module tb_top;
  initial begin
    run_test("base_test");
  end
endmodule :tb_top

//LogFile Output using Synopsys VCS Tool
creating new object as it found null
UVM_INFO testbench.sv(46) @ 0: uvm_test_top [base_test] Printing sc1 = 
-------------------------------------------
Name            Type            Size  Value
-------------------------------------------
singleton_comp  singleton_comp  -     @349 
  addr          integral        8     'h90 
  data          integral        8     'ha6 
-------------------------------------------

object already exist, separate memory will not be allocated.
UVM_INFO testbench.sv(50) @ 0: uvm_test_top [base_test] Printing sc2 = 
-------------------------------------------
Name            Type            Size  Value
-------------------------------------------
singleton_comp  singleton_comp  -     @349 
  addr          integral        8     'h90 
  data          integral        8     'ha6 
-------------------------------------------  
