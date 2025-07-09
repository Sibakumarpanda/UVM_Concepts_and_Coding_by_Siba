Arbitration in Sequencer Understanding:
-The uvm_sequencer has a built-in mechanism to arbitrate within concurrently running sequences over the sequencer. 
-Based on the arbitration algorithm, the sequencer sends sequence_item to the driver for the granted sequence.
-Each sequence sends sequence_items also do have its own id that differentiates from other sequences.
-To set a particular arbitration mechanism, the set_arbitration function is used and it is defined in the uvm_sequencer_base class.

set_arbitration method :
-It is used to specify the arbitration mode or mechanism for the sequencer.
-Decleration : function void set_arbitration( UVM_SEQ_ARB_TYPE val)
-Any one of the below arbitration modes or algorithms can be selected.
-For example: <sequencer_name>.set_arbitration(UVM_SEQ_ARB_RANDOM);

 Different Arbitration algorithms in uvm_sequencer :

 Algorithms                                              Description

 UVM_SEQ_ARB_FIFO                                        This is the default sequencer arbitration algorithm. It grants requests in FIFO order.

 UVM_SEQ_ARB_WEIGHTED                                    Grant requests randomly by weight
  
 UVM_SEQ_ARB_RANDOM                                      Grant requests randomly regardless of their priorities. 

 UVM_SEQ_ARB_STRICT_FIFO                                 Grant requests at the highest priority in FIFO order.  
  
 UVM_SEQ_ARB_STRICT_RANDOM                               Grant requests randomly at the highest priority.

 UVM_SEQ_ARB_USER                                        Grant requests based on user-defined function user_priority_arbitration written in the user-defined sequencer.

get_arbitration method:
-The get_arbitration function returns the current arbitration mode or algorithm set for the sequencer.
-Decleration :  function UVM_SEQ_ARB_TYPE get_arbitration()
 
user_priority_arbitration :
-The sequencer will call the user_priority_arbitration function when arbitration mode is set to UVM_SEQ_ARB_USER using the set_arbitration function. 
-The user-defined sequencer can override the user_priority_arbitration method to implement a customized arbitration policy.
-Decleration :  virtual function integer user_priority_arbitration(integer avail_sequences[$]) 

Examples to understand Sequencer Arbitration Mode:
 1. Different arbitration mode execution (Without any priority to the sequencer - Controlled in my_base_test)
     Link:
 2. Different arbitration mode execution (With priority to the sequencer - Controlled in my_base_test) 
     Link: 
 
