UVM Queue Concept Understanding:
-The uvm_queue class builds a dynamic queue that to be allotted on-demand basis and passed by reference.
-uvm_queue class declaration:   class uvm_queue #( type T = int ) extends uvm_object

uvm_queue class Methods :

  Methods                                                           Description

  function new ( string name = “” )                                Creates a new queue for the given name  

    static function T get_global ( int index )                      Returns the specified item instance from the global item queue.  
  
