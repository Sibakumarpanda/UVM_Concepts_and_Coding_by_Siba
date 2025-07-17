UVM Printer Understanding:
-The uvm_printer class provides flexibility to print uvm_objects in different formats. 
-We have discussed the print() method using `uvm_field_* macro or write do_print() method if utils_begin/ end macros are not used.
-The UVM printer provides four built-in printers.
  1.uvm_printer
  2.uvm_table_printer
  3.uvm_tree_printer
  4.uvm_line_printer

UVM Printer Classes:
  
Printer classes               Global instances                                                            Description

uvm_printer                   uvm_printer uvm_default_printer = uvm_default_table_printer                Provides base printer functionality  
uvm_table_printer             uvm_table_printer uvm_default_table_printer = new()                       Prints the object in a tabular form  
uvm_tree_printer              uvm_tree_printer uvm_default_tree_printer = new()                         Prints the object in a tree form  
uvm_line_printer              uvm_line_printer uvm_default_line_printer = new()                        Prints the information in a single line   

UVM printer knobs:
-The uvm_printer_knobs class provides extra feasibility for printer settings for all printer types.
-Decleration: uvm_printer_knobs knobs = new
-Some variables declared in the uvm_printer_knobs class.
-size: Controls whether to print the field’s size.
-depth: Indicates recursive depth while printing an object. 

UVM printer Methods with description:

virtual function void print_field (
                      string      name,
                      uvm_bitstream_t value, 
                      int             size,
                      uvm_radix_enum  radix = UVM_NORADIX, byte scope_separator = “.”,
                      string type_name = “” )  
Description:
-Prints an integral fields upto 4096 bits
-Name: field name
-Value: field value
-Size: number of bits of the field
-Radix: radix to use for printing
-scope_separator: To find the leaf name of the field.  
  
