UVM Object:
-The uvm_object class is the base class for all uvm hierarchical classes such as uvm_report_object, uvm_component, uvm_transaction, uvm_sequence_item, uvm_sequence etc. 
-It serves as an important role to define a set of methods such as create, copy, print, clone, compare, record, etc.

UVM Utility Macros and field macros:
-We have seen how the ‘create’ method works in the UVM factory section that the ‘create’ method allocates memory for the object and returns a handle of the same type.
-The `uvm_object_utils or `uvm_object_utils_begin.....`uvm_object_utils_end (called Utility macros) are used to register an uvm_object and other derived types like uvm_transaction, uvm_sequece_items in the UVM factory. 
-UVM field macros provide an implementation for methods like create, copy, print, clone, compare, record, etc. 
-There are different `uvm_field_* macros available for various data type variables for registration in the factory. 
-The `uvm_field_* macro accepts at least two arguments as arg (instance name of the variable that is compatible with `uvm_field_* macro) and flag (act as a control mechanism to add corresponding data methods).
-The new() method is important to define with the corresponding class name as an augment.
-Note: During compilation time, these UVM automation macros expand the complete code available for the corresponding macros.
