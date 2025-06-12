uvm_resource_db in UVM:

-The uvm_resource_db is a type-parameterized class that is a convenience layer on the top of a resource database. 
-This convenience layer provides simplified access to the low-level database and it adds no new functionality. 
-Hence, uvm_resource_db is not derived from the uvm_resource class. 
-The below code snippet for the uvm_resource_db class is taken from the uvm source code.
-The uvm_resource_db class is not instantiated.
-It operates resources and the resource pool using a set of static functions. Hence, they must be called using scope resolution (::) operator.
-For example: uvm_resource_db #(int)::set(…);
-If +UVM_RESOURCE_DB_TRACE is provided as a command-line argument, it displays all resource database accesses (write and read).
  
//Code Snippet  
class uvm_resource_db #(type T=uvm_object);

  typedef uvm_resource #(T) rsrc_t;

  protected function new();
  endfunction

  static function rsrc_t get_by_name(string scope, string name,
                                     bit rpterr=1);
    return rsrc_t::get_by_name(scope, name, rpterr);
  endfunction
  static function void set(input string scope, input string name,
                           T val, input uvm_object accessor = null);
    rsrc_t rsrc = new(name, scope);
    rsrc.write(val, accessor);
    rsrc.set();
    ...    
    ...
  endfunction

  ...
  ...
endclass  
