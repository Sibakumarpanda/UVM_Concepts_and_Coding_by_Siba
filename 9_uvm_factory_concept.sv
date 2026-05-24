////////////////////////////////
  Concept of UVM Factory
////////////////////////////////
-The UVM factory is used to create UVM objects and components. 
-This is commonly known as factory registration. 
-The factory registration for UVM objects and components are lightweight proxies to the actual objects and components.
-Guidelines for writing class for uvm_object/ uvm_component:
  1.Factory registration
  2.Default constructor new()
  3.Component and object creation
    
///////////////////////////////    
  1. Factory registration:
///////////////////////////////    
-All uvm_component and uvm_object must be registered with the factory using a pre-defined factory registration macro.
-Factory registration for uvm_object:
  
class my_sequence extends uvm_sequence #(seq_item);
  // factory registration for sequence
  `uvm_object_utils(my_sequence)
  ...
  ...
endclass :my_sequence

// For parameterized class
class param_obj #(int WIDTH = 16, ID = 0) extends uvm_object;
  typedef param_obj #(int WIDTH, ID) obj_p;
  `uvm_object_param_utils(obj_p)
  ...
  ...
endclass :param_obj

Factory registration for uvm_component:  

class my_driver extends uvm_driver;
  // factory registration for driver component
  `uvm_component_utils(my_driver)
  ...
  ...
endclass :my_driver

// For parameterized class
class param_env #(int WIDTH = 32, ID = 0) extends uvm_env;
  typedef param_env #(int WIDTH, ID) env_p;
  `uvm_component_param_utils(env_p)
  ...
  ...
endclass  :param_env
  
/////////////////////////////////////  
  2. Default constructor new() :
/////////////////////////////////////  
-The uvm_component and uvm_object constructors are virtual methods i.e. they have fixed prototype template defined that has to be followed.
-Constructor for uvm_object: The default constructor has a single argument as : name  (it denotes an instance name for an object)

class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)  
  function new(string name = "my_sequence") // default constructor for my_sequence class
    super.new(name);
  endclass
  ...
  ...
endclass :my_sequence

-Constructor for uvm_component :The default constructor has two arguments: name and parent
-Here The name : instance name for an object , parent : handle to its parent. 
-In the constructor, the parent argument is null and the actual parent can be provided while creating an object.
-The parent is null if it is a top-level component and all other derived components provide the actual parent.
-All derived classes must call super.new() methods.
-Default arguments provide an initial assignment. 
-Later, it is reassigned with other values on calling the create() method of the uvm_component_registry wrapper class.
  
class my_driver extends uvm_driver;
  `uvm_component_utils(my_driver)  
  function new(string name = "my_driver", uvm_component parent = null) // default constructor for my_driver class
    super.new(name, parent);
  endclass
  ...
  ...
endclass  :my_driver  
    
///////////////////////////////////////  
  3. Component and object creation :
///////////////////////////////////////    
-The create() method of the wrapper class is used to create objects for the uvm_object and uvm_component class.
-Since uvm_object is created in run time.so uvm objects are created in the run_phase. (Note that uvm_object are dynamic in nature )
-But , uvm_component is created in the build_phase. (Note that uvm_component are static in nature )
-The build_phase is used to create component instances and build component hierarchy.
-Syntax for Object creation:    <instance_name> = <type>::<type_id>::create("<name>")
-Syntax for Component creation: <instance_name> = <type>::<type_id>::create("<name>", <parent>)  
-Example:
class my_env extends uvm_env;
  `uvm_component_utils(my_env)
  mycomponent compA;
  param_component #(.WIDTH(8), .ID(1)) compB; 
  function new(string name = "my_env", uvm_component parent = null) // default constructor for the component that is environment
    super.new(name, parent);
  endclass  
  function void build_phase(uvm_phase phase); //Component Creation will be done in build_phase 
    super.build_phase(phase);
    // component creation
    compA = mycomponent::type_id::create("compA", this); 
    compB = param_component #(8, 1)::type_id::create("compB", this); 
  endfunction

 //Object Creation will be done in run_phase ,since object is created in run time   
  task run_phase(uvm_phase phase);
    mysequence seqA;
    param_sequence #(.WIDTH(8), .ID(1)) seqB; 
    seqA = mysequence::type_id::create("seqA"); // object creation
    seqB = param_sequence #(8,1)::type_id::create("seqB");
    ...
    ...
  endtask
endclass  :my_env
    
//////////////////////////////////////////////////////
   Summary : Why is factory registration required?
///////////////////////////////////////////////////////    
-In UVM based testbench, it is valid to use a new() function to create class objects, but factory registration has its benefits.
-Overriding :The UVM factory allows an object of one type to be overridden with an object of its derived type without changing the testbench structure. 
-This is known as the UVM factory override mechanism. This is applicable for uvm objects and components.
-Overally , we can remember the main advantages of UVM Factoy mechanism as:
   1. Factory Registartion
   2. Creation of oject and component with type_id create () method
   3. Overriding: Object of one type can be overrided qith object of its derived type (type and inst override)
