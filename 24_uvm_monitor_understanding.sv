UVM Monitor Understanding:
-A UVM monitor is a passive component used to capture DUT signals using a virtual interface and translate them into a sequence item format.
-Note that already we are aware that , active agent contais the three component as sequencer , driver , monitor . And Passive component contains only Monitor .
-These sequence items or transactions are broadcasted to other components like the UVM scoreboard, coverage collector, etc.
-It uses a TLM analysis port to broadcast transactions.
-uvm_monitor class declaration:    virtual class uvm_monitor extends uvm_component
-A user defined monitor has to be extended from uvm_monitor which is derived from uvm_component.
-Syntax : class <monitor_name> extends uvm_monitor;

Purpose of Monitor:
-Capture signal level information and translate it into the transaction.
-Broadcast transactions to other components using TLM port for coverage collection and checking purposes (scoreboard). It can also control them with enable/ disable knobs if required.
-Capture protocol specific information and forward it to the related scoreboard or checker where protocol check happens . 
