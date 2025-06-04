Concept of UVM Factory:
The UVM factory is used to create UVM objects and components. 
This is commonly known as factory registration. 
The factory registration for UVM objects and components are lightweight proxies to the actual objects and components.

Guidelines for writing class for uvm_object/ uvm_component:
  1.Factory registration
  2.Default constructor new()
  3.Component and object creation
    
1. Factory registration:
All uvm_component and uvm_object must be registered with the factory using a pre-defined factory registration macro.
    
Factory registration for uvm_object:
  
class my_sequence extends uvm_sequence #(seq_item);
  // factory registration for sequence
  `uvm_object_utils(my_sequence)
  ...
  ...
endclass

// For parameterized class
class param_obj #(int WIDTH = 16, ID = 0) extends uvm_object;
  typedef param_obj #(int WIDTH, ID) obj_p;
  `uvm_object_param_utils(obj_p)
  ...
  ...
endclass

Factory registration for uvm_component:  

class my_driver extends uvm_driver;
  // factory registration for driver component
  `uvm_component_utils(my_driver)
  ...
  ...
endclass

// For parameterized class
class param_env #(int WIDTH = 32, ID = 0) extends uvm_env;
  typedef param_env #(int WIDTH, ID) env_p;
  `uvm_component_param_utils(env_p)
  ...
  ...
endclass  
  
2. Default constructor new() :
The uvm_component and uvm_object constructors are virtual methods i.e. they have fixed prototype template defined that has to be followed.
  
Constructor for uvm_object:
The default constructor has a single argument as the name denotes an instance name for an object.

class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)

  // default constructor for sequence
  function new(string name = "my_sequence")
    super.new(name);
  endclass
  ...
  ...
endclass

Constructor for uvm_component :
The default constructor has two arguments: name and parent
The name denotes an instance name for an object.
The parent denotes the handle to its parent. 
In the constructor, the parent argument is null and the actual parent can be provided while creating an object.
The parent is null if it is a top-level component and all other derived components provide the actual parent.
All derived classes must call super.new() methods.
Default arguments provide an initial assignment. 
Later, it is reassigned with other values on calling the create() method of the uvm_component_registry wrapper class.
  
class my_driver extends uvm_driver;
  `uvm_component_utils(my_driver)

  // default constructor for sequence
  function new(string name = "my_driver", uvm_component parent = null)
    super.new(name, parent);
  endclass
  ...
  ...
endclass    
  
