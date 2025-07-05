Writting Sequence using UVM Sequence Macros:

-Based on the requirement few macros can be used while writing a sequence. (Using macros like `uvm_do , `uvm_create, `uvm_send etc)

Macros                                                      Description
  
  `uvm_do (seq/item)                                         On calling this macro, create, randomize and send to the driver will be executed  

  `uvm_do_with (seq/item, constraints)                       It is the same as `uvm_do but additionally, constraints can be defined while randomizing               

  `uvm_do_pri(seq/item, priority)                            It is the same as `uvm_do but additionally, the mentioned priority is considered.

  `uvm_do_pri_with(seq/item, constraints, priority)          It is a combination of `uvm_do_with and `uvm_do_pri

  `uvm_create(seq/item)                                      This creates a sequence or item
