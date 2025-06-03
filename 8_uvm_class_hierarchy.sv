UVM classes have 3 major types :

UVM object
UVM transaction
UVM component

uvm_void : 
The uvm_void is the base class for all the UVM classes. It is an abstract class that does not have any data members or methods implemented. It is a generic container for objects to be created similar to void pointer in C language.
Syntax: virtual class uvm_void

uvm_object: 
The UVM object is a data structure used for testbench configuration and it is the base class available for component and sequence branch. The uvm_object provides methods like create, clone, copy, record, compare, print, etc.

uvm_report_object: 
The uvm_report_object provides reporting functionality for UVM. The message, error, or warning prints are very important for debugging purposes that are being facilitated by the uvm_report_object class.
Most of the methods in uvm_report_object are passed to an instance of uvm_report_handler that stores reporting configuration. 
Based on the configurations, uvm_report_handler decides whether to display the message or not. 
It is then passed to uvm_report_server for actual formatting and producing the messages. 
The detailed report has information for id string, verbosity level, severity, and a complete message string.
Report macros: UVM provides a set of macros that are wrappers around uvm_report_* functions as shown below.

Macros                                           Reporting functions                                Syntax
`uvm_info                                        uvm_report_info                                    `uvm_info(ID,MSG,VERBOSITY)
`uvm_warning                                     uvm_report_warning                                 `uvm_warning(ID,MSG)
`uvm_error                                       uvm_report_error                                   `uvm_error(ID,MSG)
`uvm_fatal                                       uvm_report_fatal                                   `uvm_fatal(ID,MSG)

Where, 
ID: message tag
MSG: A text message
VERBOSITY: If VERBOSITY is lower than configured verbosity for that reporter, it will be printed.
Note: `uvm_warning has UVM_NONE as a default verbosity.









