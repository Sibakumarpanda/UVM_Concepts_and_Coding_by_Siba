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
