UVM Pool Concept Understanding:

-The uvm_pool is a parameterized class that implements a pool data structure same as System Verilog associative array and it can be allocated based on demand. 
-The items in the pool can be shared across different verification components as pass by reference. 
-On copying the uvm_pool object, it copies the class handle instead of copying an entire associative array.
-uvm_pool class declaration:  class uvm_pool # (type KEY = int, T = uvm_void) extends uvm_object

uvm_pool class Methods :
  
  Methods                                                            Description

  function new ( string name = “” )                                  Creates pool for the given name 

  static function T get_global ( KEY key )                          Returns the specified item instance from the global item pool.  
