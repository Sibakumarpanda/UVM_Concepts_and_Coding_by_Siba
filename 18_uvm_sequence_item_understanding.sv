Sequence Items in UVM Understanding:

-All user-defined sequence items are extended from the uvm_sequence_item class as it leverages generating stimulus and has control capabilities for the sequence-sequencer mechanism.
-uvm_sequence_item is derived from the uvm_transaction class.
-It supports all methods like copy, compare, clone, print, etc as discussed in the UVM object section.  

//uvm_sequence_item example Sample code:
  
class my_seq_item extends uvm_seqeunce_item;
  rand int        value;
  rand color_type colors;
  rand byte       data[4];
  rand bit [7:0]  addr;
  
  `uvm_object_utils_begin(my_seq_item)
    `uvm_field_int(value, UVM_ALL_ON)
    `uvm_field_string(names, UVM_ALL_ON)
    `uvm_field_enum(color_type, colors, UVM_ALL_ON)
    `uvm_field_sarray_int(data, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "my_seq_item");
    super.new(name);
  endfunction
  
endclass  :my_seq_item

  
