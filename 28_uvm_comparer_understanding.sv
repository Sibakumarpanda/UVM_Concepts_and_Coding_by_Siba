UVM Comparer Understanding:
-In uvm_object, we discussed print,copy, clone,compare methods etc. 
-The compare() method compares two objects to return 1 in case of successful comparison. 
-The uvm_comparer adds up policy for the comparison and counts the number of miscompares if any.

Variables in uvm_comparer class:
  
Type                     Variables                                 Description
  
enum                     policy                                    It is an enum variable that compares the type UVM_DEEP, UVM_SHALLOW, or UVM_REFERENCE.
  
int unsigned             show_max
  
int                      verbosity                                 Sets verbosity for message prints. Default verbosity = UVM_LOW  
  
uvm_severity             sev                                       Sets severity for message prints. Default sev = UVM_INFO  
  
bit                      abstract                                  Provides a filtering mechanism for fields.
  
bit                      physical                                  Provides a filtering mechanism for fields. 
  
string                   miscompares                               Holds the last set of miscompares during a comparison. 
                                                                   The miscompares string resets to an empty string on starting a comparison
  
bit                      check_type                                Verifies types of two comparing objects having type given by uvm_object::get_type_name. 
  
int unsigned             result                                    Stores number of miscompares for the given comparison. 
                                                                   It is recommended to clear this variable before starting a new comparison otherwise, 
                                                                   the end result might be incorrect.  
  
Note: The physical and abstract bit setting distinguish objects between two different classes of fields.

Methods and their description in uvm_comparer class :
                                                    
virtual function bit compare_field
                (string            name,
                uvm_bitstream_t    lhs, 
                uvm_bitstream_t    rhs,
                int                size,
                uvm_radix_enum radix = UVM_NORADIX)  
Description: 
-It Compares two integral values.
-name: used to store and print miscompare.
-lhs and rhs: used to compare left-hand and right-hand side objects
-size: indicates number of bis to compare. (size <= 4096)
-radix: used for reporting purposes. Default radix = HEX.

virtual function bit compare_field_int
                (string                name,
                uvm_integral_t  lhs, uvm_integral_t  rhs,
                int               size,
                uvm_radix_enum radix = UVM_NORADIX) 
  
Description:
-It is the same as compare_field except arguments are small integers having size <= 64.
-If compare_field calls compare_field_int automatically if the size argument has a value less than or equal to 64  
  
virtual function bit compare_field_real
                     (string  name,
                      real      lhs,
                      real      rhs) 

Description:
-It is the same as compare_field except arguments are real numbers .

virtual function bit compare_string 
                     (string name,
                      string lhs,
                      string rhs)  

Description:
-It is the same as compare_field except arguments are string variables.  

virtual function bit compare_object 
                      (string         name,
                      uvm_object lhs,
                      uvm_object rhs)  
Description:
-Compares two class objects using a policy variable having deep, shallow or reference comparison.

function void print_msg
              (string msg)
  
Description:
-Prints a message that appends error count to miscompares string.   
  
