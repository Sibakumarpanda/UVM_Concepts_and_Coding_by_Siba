How to write a sequence ???
-An intention is to create a seq_item, randomize it and then send it to the driver. 
-To perform this operation any one of the following approaches is followed in the sequence.
  1.Using macros like `uvm_do , `uvm_create, `uvm_send etc
  2.Using existing methods from the base class
    a. Using wait_for_grant(), send_request(), wait_for_item_done() etc
    b. Using start_item/finish_item methods.
-Let’s discuss the macro-based approach in UVM sequence macro and existing methods approach in the uvm_sequence_base class methods section
