How to write a sequence using uvm_sequence_base Methods ???
-The randomized sequence items can be driven to the driver using pre-defined methods call present in the uvm_sequence_base class. 
-There are two approaches with a set of uvm_sequence_base methods by which sequence can send sequence items and retrieve response from the driver (if applicable).
- It can be done using existing methods from the base class.
-Approach A: Using wait_for_grant(), send_request(), wait_for_item_done() etc
-Approach B: Using start_item/finish_item methods

Approach A : Using wait_for_grant(), send_request(), wait_for_item_done() etc.
- The below methods are defined in the uvm_sequence_base class which is derived from the uvm_sequence_item class.

Type                                        Method                                                                             Description

function                                    create_item                                                                        This creates and initializes request items or sequences and initializes using the factory.
  
task                                        wait_for_grant                                                                     This task issues a request to the current sequencer and it returns when the sequencer has granted the sequence. 
                                                                                                                               Hence, it is a blocking method that waits for a grant from the sequencer.
  
function                                    send_request(uvm_sequence_item request, bit rerandomize = 0)                      Send request items to the driver via the sequencer. If rerandomize = 1, the item will be randomized before sent to the driver. 

task                                        wait_for_item_done()                                                              This task will block until the driver calls put or item_done. It is an optional call.
                                                                                                                                 
                                            get_response (RSP)                                                               This is optional in case the driver sends back any response
                                              
Steps to use : 
- Create a seq_item using create() method
- wait_for_grant
- Randomize seq_item
- send_request(req)
- wait_for_item_done()
- get_response (rsp)                                                                                                                                 

//Sample code using Approach A:
class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)
  
   function new (string name = "my_sequence")
     super.new(name);
   endfunction

   task body();
     req = seq_item::type_id::create("req");
     wait_for_grant();
     assert(req.randomize());
     send_request(req);
     wait_for_item_done();
     get_respose(rsp);
   endtask
endclass :my_sequence

Approach B: Using start_item/finish_item methods :
-The start_item and finish_item tasks are also defined in the uvm_sequence_base class. 
-Both methods initiate the operation of sequence items. 
-Note: There should be no simulation time consumed between start_item and finish_item call.  

  Methods                                                     Description

  start_item(req)                                             It blocks until the sequencer grants the sequence and the sequence_item access to the driver. 
    
  finish_item(req)                                           It blocks the driver until it finishes the transfer protocol for the sequence item.

 Steps to use: 
 - Create a seq_tem using create() method
 - start_item(req)
 - Randomize seq_item
 - finish_item(req)
    
//Sample code using Approach B:
class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)
  
   function new (string name = "my_sequence")
     super.new(name);
   endfunction

   task body();
     req = seq_item::type_id::create("req");
     start_item(req);
     assert(req.randomize());
     finish_item(req);
   endtask
endclass  :my_sequence 

NOTE:    
-Approach B is the same as approach A. 
-The start_item(req) method internally calls wait_for_grant() method to get grant from the sequencer. 
-The finish_item(req) method internally calls send_request() and wait_for_item_done() methods. 
-Hence, start_item and finish_item methods act as wrapper methods over them.    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
