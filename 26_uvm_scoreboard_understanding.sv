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
  
