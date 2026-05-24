uvm_config_db in UVM:

-The uvm_config_db class is derived from the uvm_resource_db class. 
-It is another layer of convenience layer on the top of uvm_resource_db that simplifies the basic interface (access methods of resource database) used for uvm_component instances.
-The below code snippet for the uvm_config_db class is taken from the uvm source code.

//uvm_config_db code Snippet

class uvm_config_db#(type T=int) extends uvm_resource_db#(T);

  static uvm_pool#(string,uvm_resource#(T)) m_rsc[uvm_component];
  static local uvm_queue#(m_uvm_waiter) m_waiters[string];

  static function void set(uvm_component cntxt,
                           string inst_name,
                           string field_name,
                           T value);

    ...
  endfunction

  static function bit get(uvm_component cntxt,
                          string inst_name,
                          string field_name,
                          inout T value);
    ...
  endfunction

...
...
endclass  

uvm_config_db methods :
  
In below, all are static functions as mentioned below except wait_modified is a static task  .

  Methods	                                                                                              Description
  
  set(uvm_component cntxt, string inst_name, string field_name, T value);	                             Create a new or update an existing field_name configuration setting based on cntxt and inst_name.
  
  bit get(uvm_component cntxt, string inst_name, string field_name, inout T value);	                   Get the value for field_name based on cntxt and inst_name. 
                                                                                                       For successful resource lookup, it returns 1 otherwise it returns 0 if it is not found in the database.
                                                                                                         
  bit exists(uvm_component cntxt, string inst_name, string field_name, bit spell_chk=0);	             Check whether field_name value is available for mentioned cntxt and inst_name.
    
  wait_modified(uvm_component cntxt, string inst_name, string field_name);	                           Wait for field_name value to be set for mentioned cntxt and inst_name.  


Where, 

uvm_component cntxt : The context is the hierarchical starting point for accessible database entry.
string inst_name    : The instance name is the hierarchical path that limits database entry accessibility.
string field_name   : The field_name is the tag or label that is used as a lookup for the database entry.
T value             : It is a value that is set in or get from the database (of parameterized type T) based on methods. Default type = int

In simple words, 
The complete scope is decided based on cntxt and insta_name as {cntxt, “.”, inst_name}.
Example: uvm_test_top.env.agent_o hierarchical path can be mentioned from test case as
cntxt = null , inst_name = env.agent_o

OR
cntxt = this ,inst_name = "env.agent_o"

Syntax for set method :

void uvm_config_db#(type T = int)::set(uvm_component cntxt,
                                        string inst_name,
                                        string field_name,
                                        T value);
Syntax for get method :

bit uvm_config_db#(type T=int)::get(uvm_component cntxt,
                                    string inst_name,
                                    string field_name,
                                    ref T value);  


uvm_config_db example code snippet:

-In the below , the control bit is stored in the database which acts as an enable condition to create an object for my_component in the component_B.
-The new resource with the name “control” of type bit is added in the resource pool from the test case.
-The resource is retrieved using the get static function which lookup in the database with the field_name as “control”. 
-If get() fails to find the “control” string field_name in the database, a fatal will be reported.
-Even though the fatal check is not mandatory, it is recommended to use it for debugging purposes.
-Once the lookup in the table is succeeded, the value stored in the resource database is updated in the local variable ctrl.
-This ctrl bit is used to control my_component object creation. 

//Code Snippet:  
uvm_config_db #(bit)::set(null, "*", "control", 1);

//where,
//uvm_component cntxt= null;
//string inst_name = "*"
//String field_name = "control";
//T value = 1;
// In component_B, 
if(!uvm_config_db #(bit)::get(this, "*", "control", ctrl))
  `uvm_fatal(get_type_name(), "get failed for resource in this scope");
  
