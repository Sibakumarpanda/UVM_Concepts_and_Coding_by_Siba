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

Syntax without field macros :    `uvm_object_utils(<class Type>)
Syntax with field macros:        `uvm_object_utils_begin(<class_type>)
                                      `uvm_field_*(<arg>, <flag>)
                                 `uvm_object_utils_end
-Below field macros are commonly used for data methods (copy, compare, pack, unpack, print, clone, etc) for scalar/dynamic class properties. The complete list can be studied from the UVM reference document.
  
`uvm_field_* macros : The `uvm_field_* macros implement data methods for scalar properties.

    `uvm_field_* macros                          |                                        Description
      `uvm_field_int                                                                      Implements data methods for any packed integral property.
      `uvm_field_string                                                                   Implements data methods for a string property.
      `uvm_field_real                                                                     Implements data methods for any real property.
      `uvm_field_enum                                                                     Implements data methods for an enumerated property.
      `uvm_field_event                                                                    Implements data methods for an event property.
      `uvm_field_object                                                                   Implements data methods for an uvm_object based property.
        
`uvm_field_sarray_* macros : The `uvm_field_sarray* macros implement data methods for one-dimensional static array properties.

   `uvm_field_sarray_* macros                      |                                       Description
    `uvm_field_sarray_int                                                                  Implements data methods for 1D static integral array.
    `uvm_field_sarray_string                                                               Implements data methods for 1D static string array.
    `uvm_field_sarray_enum                                                                 Implements data methods for 1D static enum array. 
    `uvm_field_sarray_object                                                               Implements data methods for 1D static uvm_object based object array.  
      
`uvm_field_array_* macros : The `uvm_field_array* macros implement data methods for one-dimensional dynamic array properties.

   `uvm_field_array_* macros                        |                                       Description
       `uvm_field_array_int                                                                 Implements data methods for 1D dynamic integral array.  
       `uvm_field_array_string                                                              Implements data methods for 1D dynamic string array.
       `uvm_field_array_enum                                                                Implements data methods for 1D dynamic enum array.
       `uvm_field_array_object                                                              Implements data methods for 1D dynamic uvm_object based object array.

`uvm_field_* macro flags:
         
        flag                        |                       Description
        UVM_DEFAULT                                         Use default flag settings
        UVM_ALL_ON                                          Set all operations/method ON
        UVM_NO_COPY                                         Do not copy this field
        UVM_NOCOMPARE                                       Do not compare this field
        UVM_NOPRINT                                         Do not print this field
        UVM_NOPACK                                          Do not pack or unpack this field 
        UVM_ABSTRACT                                        Use the abstract setting in the policy class for this abstract field.
        UVM_REFERENCE                                       For object types, operate only on the handle (e.g. no deep copy) 
        UVM_PHYSICAL                                        Use a physical setting in policy class for this field.
        UVM_READONLY                                        Do not allow setting of this field from the set_*_local methods or during <apply_config_settings> operation.


 NOTE: A radix can be specified for printing and recording by OR’ing one of the following constants in the <flag> argument. 
       Hex is the default radix for integral types if it is not specified.

        flag                     |                          Description 
        UVM_BIN                                             Print/record the field in binary (base-2).
        UVM_HEX                                             Print/record the field in hexadecimal (base-16).
        UVM_DEC                                             Print/record the field in decimal (base-10).
        UVM_OCT                                             Print/record the field in octal (base-8).
        UVM_TIME                                            Print/record the field in time format
        UVM_STRING                                          Print/record the field in string format
        UVM_UNSIGNED                                        Print/record the field in unsigned decimal (base-10)

Sample code Template with `uvm_object_utils :
         
typedef enum{RED, GREEN, BLUE} color_type;
          
class my_object extends uvm_object;
   int        o_var;
   string     o_name;  
   byte       data[4];
   bit [7:0]  addr;
   color_type colors;
  
  `uvm_object_utils(my_object)
  
  function new(string name = "my_object");
    super.new(name);
  endfunction
  
endclass :my_object   

Sample code Template with `uvm_object_utils_begin and `uvm_object_utils_end  : 
          
typedef enum{RED, GREEN, BLUE} color_type;
          
class my_object extends uvm_object;
   rand int        value;  
   rand byte       data[4];
   rand bit [7:0]  addr;
   rand color_type colors;
   string          names;
  
  `uvm_object_utils_begin(my_object)
    `uvm_field_int(value, UVM_ALL_ON)
    `uvm_field_string(names, UVM_ALL_ON)
    `uvm_field_enum(color_type, colors, UVM_ALL_ON)
    `uvm_field_sarray_int(data, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "my_object");
    super.new(name);
  endfunction
  
endclass :my_object
          

         
