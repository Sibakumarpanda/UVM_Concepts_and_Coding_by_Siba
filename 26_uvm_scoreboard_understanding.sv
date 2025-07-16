UVM Scoreboard Understanding:
-The UVM scoreboard is a component that checks the functionality of the DUT. 
-It receives transactions from the monitor using the analysis export for checking purposes.
-uvm_scoreboard class declaration:            virtual class uvm_scoreboard extends uvm_component.
-User defined scoreboard class declaration:   class <scoreboard_name> extends uvm_scoreboard;
-The user-defined scoreboard is extended from uvm_scoreboard which is derived from uvm_component.

Scoreboard Usage :
-Receive transactions from monitor using analysis export for checking purposes.
-The scoreboard has a reference model to compare with design behavior. 
-The reference model is also known as a predictor that implements design behavior so that the scoreboard can compare DUT outcome with reference model outcome for the same driven stimulus.  

How to write scoreboard code in UVM???
  
-Create a user-defined scoreboard class extended from uvm_scoreboard and register it in the factory.
-Declare an analysis export to receive the sequence items or transactions from the monitor.
-Write standard new() function. Since the scoreboard is a uvm_component. The new() function has two arguments as string name and uvm_component parent.
-Implement build_phase and create a TLM analysis export instance.
-Implement a write method to receive the transactions from the monitor.
-Implement run_phase to check DUT functionality throughout simulation time.

//Scoreboard Sample code Snippet:
class my_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(my_scoreboard)
  
  uvm_analysis_imp #(seq_item, my_scoreboard) item_collect_export;
  seq_item item_q[$];
   
  function new(string name = "my_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    item_collect_export = new("item_collect_export", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  function void write(seq_item req);
    `uvm_info(get_type_name, $sformatf("Received transaction = %s", req), UVM_LOW);
    item_q.push_back(req);
  endfunction
  
  task run_phase (uvm_phase phase);
    seq_item sb_item;
    forever begin
      wait(item_q.size > 0);
      
      if(item_q.size > 0) begin
        sb_item = item_q.pop_front();
        // Checking comparing logic
        ...        
      end
    end
  endtask
  
endclass :my_scoreboard 

UVM Scoreboad types :
-Depends on design functionality scoreboards can be implemented in two ways.
   1.In-order scoreboard
   2.Out-of-order scoreboard  
  
1. In-order scoreboard :
-The in-order scoreboard is useful for the design whose output order is the same as driven stimuli.
-The comparator will compare the expected and actual output streams in the same order. 
-They will arrive independently. Hence, the evaluation must block until both expected and actual transactions are present.  
-To implement such scoreboards, an easier way would be to implement TLM analysis FIFOs. 
-For more details visit the TLM analysis FIFO section. 
-In the below example, there are two monitors whose analysis port is connected to the scoreboard to provide input and output transactions.
// Sample code Snippet for Inorder Scoreboard
  
class inorder_sb extends uvm_scoreboard;
  `uvm_component_utils(inorder_sb)
  
  uvm_analysis_export #(txn) in_export, out_export;
  uvm_tlm_analysis_fifo #(txn) in_fifo, out_fifo;

  function new (string name = "inorder_sb" , uvm_component parent = null) ;
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    in_fifo    = new("in_fifo", this);
    out_fifo   = new("out_fifo", this);
    in_export  = new("in_export", this);
    out_export = new("out_export", this);
  endfunction

  function void connect_phase (uvm_phase phase);
    in_export.connect(in_fifo.analysis_export);
    out_export.connect(out_fifo.analysis_export);
  endfunction

  task run_phase( uvm_phase phase);
    txn in_txn;
    txn exp_txn, act_txn;
    forever begin
      in_fifo.get(in_txn);
      process_data(in_txn, exp_txn); 
      out_fifo.get(act_txn);
      if (!exp_txn.compare(act_txn)) begin
        `uvm_error(get_full_name(), $sformat("%s does not match %s", exp_txn.sprint(), act_txn.sprint()), UVM_LOW);
      end
    end
  endtask
  
  // Reference model 
  task process_data(input txn in_txn, output txn exp_txn);
    // Generate expected txn for driven stimulus
    ...
    ...
  endtask
endclass :inorder_sb
  
2. Out-of-order scoreboard :  
