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

uvm_resource_db methods : (All are static functions)

  Method names with arguments                                                             |             Description
  
  get_by_name(string scope, string name, bit rpterr=1)                                                  Get a resource by using both scope and name arguments. 
                                                                                                        The rpterr argument indicates whether to generate a warning or not if a resource match is not found.

  get_by_type(string scope) -	 It gets the resource by the type specified as a parameter in the class. So, ‘scope’ is the only argument for this function.
    
  set(string scope, string name, T val, uvm_object_accessor = null)-	It creates a new resource and writes/ sets val to it using name and scope as lookup parameters.
    
  set_default(string scope, string name) -	It creates a new resource using name and scope as lookup parameters without writing a new val. The resource will have its default value.
    
  set_override(string scope, string name, T val, uvm_object accessor = null); -	It creates a new resource and writes/ sets val to it using name and scope as lookup parameters.
                                                                                It will create a resource with the highest priority (currently) with a specified name and type by 
                                                                                setting it at the beginning of the queue of name map and type map.
    
  set_override_type(string scope, string name, T val, uvm_object accessor = null); -It creates a new resource and writes/ sets val to it using type and scope as lookup parameters.
                                                                                    It will create a resource with the highest priority (currently) with a specified type by 
                                                                                    setting it at the beginning of the queue of the type map. 
                                                                                    It will be a normal priority in the name map (i.e. at the end of the queue).
  set_override_name(string scope, string name, T val, uvm_object accessor = null);-	It creates a new resource and writes/ sets val to it using name and scope as lookup parameters.
                                                                                      It will create a resource with the highest priority (currently) with a specified name by setting
                                                                                      it at the beginning of the queue of type map.
                                                                                      It will be a normal priority in the type map (i.e. at the end of the queue).
    
  set_anonymous(string scope,T val, uvm_object accessor = null); -	It creates a new resource and writes/ sets val to it using the scope as a lookup parameter. 
                                                                    The resource is not updated in the name map as it has no name.
    
  bit read_by_name(input string scope, string name, inout T val, input uvm_object accessor = null); -	Find a resource by name and scope. 
                                                                                                      The value is read using output argument val. 
                                                                                                      The accessor is used for auditing. 
                                                                                                      The return bit indicates whether read_by_name is successful or not.
                                                                                                        
  bit read_by_type(input string scope, inout T val, input uvm_object accessor = null);-	Find a resource by type. The scope is used for lookup. 
                                                                                        The value is read using output argument val. The accessor is used for auditing. 
                                                                                        The return bit indicates whether read_by_type is successful or not.
                                                                                          
  bit write_by_name(input string scope, string name, inout T val, input uvm_object accessor = null);-	Write a val into the database. First lookup for the resource by name and scope. 
                                                                                                      If it is not located then add a new resource to the database and then write its value.
    
  bit write_by_type(input string scope, inout T val, input uvm_object accessor = null);	- Write a val into the database. First lookup for the resource by type.
                                                                                          If it is not located then add a new resource to the database and then write its value.
    
  m_show_msg(string id, string rtype, string action, string scope, string name, uvm_object accessor, uvm_resource#(T) rsrc);-	print resource accesses.
    
  dump(); -	It dumps all the resources into the resource pool irrespective of parameter T. It is useful for debugging purposes.
  
                                                                                                                                                                        
 uvm_resource_db example Snippet:
    
 In below , the control bit is stored in the database which acts as an enable condition to create an object for my_component in the component_B.
 The new resource with name “control” of type bit is added in the resource pool from testcase.  
 The resource is retrieved using the read_by_name static function which lookup in the database with the name as “control”. 
 If read_by_name fails to find the “control” string name in the database, a fatal will be reported. 
 Even though the fatal check is not mandatory, it is recommended to use it for debugging purposes. 
 Once the lookup in the table is succeeded, the value stored in the resource database is updated in the local variable ctrl.
 This ctrl bit is used to control my_component object creation.  
