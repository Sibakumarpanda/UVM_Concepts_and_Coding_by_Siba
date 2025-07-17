UVM Comparer Understanding:
-In uvm_object, we discussed print, clone, copy, compare methods, etc. 
-The compare() method compares two objects to return 1 in case of successful comparison. 
-The uvm_comparer adds up policy for the comparison and counts the number of miscompares if any.

Variables in uvm_comparer class:
  
Type                     Variables                                 Description
  
enum                     policy                                    It is an enum variable that compares the type UVM_DEEP, UVM_SHALLOW, or UVM_REFERENCE.
int unsigned             show_max  
  
