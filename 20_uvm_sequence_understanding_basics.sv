
UVM Sequence understanding:
-UVM sequence is a container that holds data items (uvm_sequence_items) which are sent to the driver via the sequencer.
-Note: uvm_sequence class is parameterized with uvm_sequence_item.
-uvm_sequence class declaration: virtual class uvm_seqence #( type REQ = uvm_sequence_item, type RSP = REQ) extends uvm_sequence_base

uvm_sequence class structure :
  
class my_sequence extends uvm_sequence #(my_seq_item);
  `uvm_object_utils(my_sequence)

  function new(string name = "my_sequnce");
    super.new(name);
  endfunction

  task body();
    ...
  endtask
endclass :my_sequence

NOTE:  Why `uvm_object_utils is used in sequence, why `uvm_sequence_utils are not used?
`uvm_sequence_utils is a string-based sequence library that is deprecated in UVM. 

 class my_sequence extends uvm_sequence #(my_seq_item);
  `uvm_sequence_utils(my_sequence)  // Older style
  // or `uvm_object_utils(my_sequence) in newer UVM
  
  function new(string name="my_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    // Sequence logic here
  endtask
endclass 

-Note: In UVM 1.2 and later, the recommendation is to use `uvm_object_utils instead for most sequence definitions (`uvm_sequence_utils).
-Its is Officially deprecated since UVM 1.2 (IEEE 1800.2).
-Still exists in codebases for backward compatibility.
-Generates warnings when used in modern simulators.

What is the body() method and its uses/functionality in sequence ? 
  
  
  
  
