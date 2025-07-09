Arbitration in Sequencer Understanding:
-The uvm_sequencer has a built-in mechanism to arbitrate within concurrently running sequences over the sequencer. 
-Based on the arbitration algorithm, the sequencer sends sequence_item to the driver for the granted sequence.
-Each sequence sends sequence_items also do have its own id that differentiates from other sequences.
-To set a particular arbitration mechanism, the set_arbitration function is used and it is defined in the uvm_sequencer_base class.

set_arbitration method :
-It is used to specify the arbitration mode or mechanism for the sequencer.
-Decleration : function void set_arbitration( UVM_SEQ_ARB_TYPE val )
-Any one of the below arbitration modes or algorithms can be selected.
-For example: <sequencer_name>.set_arbitration(UVM_SEQ_ARB_RANDOM);

 Different Arbitration algorithms in uvm_sequencer :
  
  

  
  
