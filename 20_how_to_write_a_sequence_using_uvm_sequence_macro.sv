Writting Sequence using UVM Sequence Macros:
-Based on the requirement few macros can be used while writing a sequence. (Using macros like `uvm_do , `uvm_create, `uvm_send etc)

Macros                                                      Description
  
  `uvm_do (seq/item)                                         On calling this macro, create, randomize and send to the driver will be executed  

  `uvm_do_with (seq/item, constraints)                       It is the same as `uvm_do but additionally, constraints can be defined while randomizing               

  `uvm_do_pri(seq/item, priority)                            It is the same as `uvm_do but additionally, the mentioned priority is considered.

  `uvm_do_pri_with(seq/item, constraints, priority)          It is a combination of `uvm_do_with and `uvm_do_pri

  `uvm_create(seq/item)                                      This creates a sequence or item

  `uvm_send(seq/item)                                       It directly sends seq/item without creating and randomizing it. 
                                                            So, make sure the seq/item is created and randomized first.

  `uvm_rand_send(seq/item)                                 It directly sends a randomized seq/item without creating it. So, make sure the seq/item is created first.

  `uvm_rand_send_with(seq/item)                            It directly sends a randomized seq/item with constraints but without creating it. So, make sure seq/item is created first 

  `uvm_send_pri(seq/item, Priority)                        It is the same as `uvm_send but additionally. priority is also considered. 

  `uvm_rand_send_pri(seq/item, Priority)                   It is combination of `uvm_rand_send and `uvm_send_pri

  `uvm_rand_send_pri_with(seq/item, Priority)             It is a combination of `uvm_rand_send_with and `uvm_send_pri. 

  Note:
  - `uvm_do macro call does not invoke pre_body and post_body methods
  -A sequence macro call is not recommended to use because it takes more time to execute on the simulator which results in slow simulation.  


UVM Sequence macro examples :

// 1. Using `uvm_do sample example :
class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)
  
   function new (string name = "my_sequence")
     super.new(name);
   endfunction

   task body();
     `uvm_do(req);
   endtask
endclass :my_sequence

class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)
  
   function new (string name = "my_sequence")
     super.new(name);
   endfunction

   task body();
     `uvm_do(seq1); // calling seq1
     `uvm_do(seq2); // calling seq2
   endtask
endclass :my_sequence 

//2. Using `uvm_do_with sample example :
class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)
  
   function new (string name = "my_sequence")
     super.new(name);
   endfunction

   task body();
     `uvm_do_with(req, {req.<variable> == 0;}); // any constraint
   endtask
endclass : my_sequence  

//3. Using `uvm_create and `uvm_send Sample example :
class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)
  
   function new (string name = "my_sequence")
     super.new(name);
   endfunction

   task body();
     `uvm_create(req);
      assert(req.randomize());
     `uvm_send(req);
   endtask
endclass :my_sequence  

//4. Using `uvm_rand_send Sample example :
class my_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(my_sequence)
  
   function new (string name = "my_sequence")
     super.new(name);
   endfunction

   task body();
     `uvm_create(req);
     `uvm_rand_send(req);
   endtask
endclass :my_sequence    
