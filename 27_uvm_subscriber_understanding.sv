UVM Subscriber Understanding:
-The uvm_subscriber class provides an analysis export that connects with the analysis port. 
-As the name suggests, it subscribes to the broadcaster i.e. analysis port to receive broadcasted transactions.
-Means, we can say monitor(analysis port),present inside agent  to subscriber(analysis export) connection will be done . Basically this subscribe class is used for Functional covergae purpose.
-The uvm_subscriber is derived from uvm_component and adds up the analysis_export port in the class.
-The user-defined subscriber is derived from uvm_subscriber that must define the write method.
-A write method is a pure virtual method that is declared in the uvm_subscriber class. The analysis_export provides access to the write method by outside components.
-Since uvm_subscriber has built-in analysis_export, it is generally used to implement a functional coverage monitor.
-The below is the uvm_scriber class defination.
  
virtual class uvm_subscriber #(type T=int) extends uvm_component;

  typedef uvm_subscriber #(T) this_type;
  uvm_analysis_imp #(T, this_type) analysis_export;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_imp", this);
  endfunction
  
  pure virtual function void write(T t);
    
endclass
    
-In the below code, a functional coverage monitor is created by extending the uvm_subscriber class.  
  
 //Sample code
class func_cov extends uvm_subscriber #(seq_item);
  covergroup cg;
  ...
  endgroup

  function void write (seq_item req);
    ...
    cg.sample();
  endfunction
endclass :func_cov

// Env class connects broadcaster and subscriber class using analysis port connection.
class env extends uvm_env;
  `uvm_component_utils(env)
  agent agt;
  func_cov fc;
 
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = agent::type_id::create("agt", this);
    fc = func_cov::type_id::create("fc", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agt.mon.item_collect_port.connect(fc.analysis_export); // Here, Monitor behaves as a broadcaster.
  endfunction
endclass :env

  
