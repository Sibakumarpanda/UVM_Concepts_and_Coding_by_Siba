UVM Command Line Processor/Arguments understanding (CLP/CLA):

-With increasing complexity in the design and verification environment, the compilation time has also increased which also affects the verification timeline. 
-Hence, there is a requirement to optimize it which can consider new configurations or parameters without forcing a recompilation. 
-We have seen how a function or task behaves based on passing arguments. 
-Similarly, UVM provides an interface to provide command-line arguments that provide flexibility to avoid testbench recompilation with the help 
 of the ‘uvm_cmdline_processor’ class. 
-It allows running a test with different configurations.
-The uvm_cmdline_processor class provides setting various UVM variables from the command line such as components 
 verbosity and configurations for integral types and strings.

uvm_cmdline_processor Methods :
-Few methods of the command line processor and built-in command-line arguments are discussed here.

Type                             Methods                                       Description  

function                         get_inst                                      Returns a singleton instance of the UVM command line processor  

function                         get_args                                      Returns a queue with all command-line arguments   

function                         get_plusargs                                  Returns a queue with all plus arguments   

function                         get _uvmargs                                  Returns a queue with all uvm arguments   

function                         get_args_value                                Finds the first argument which matches the ‘match’ argument and 
                                                                               returns the suffix of the argument   

Built-in command line arguments in UVM: 
   
Command line arguments                         Description  
   
+UVM_TESTNAME                                  +UVM_TESTNAME = allows the user to specify uvm_test component and create it via UVM factory.   

+UVM_VERBOSITY                                 +UVM_VERBOSITY = allows the user to specify the initial verbosity for all the components.  

+UVM_TIMEOUT                                   +UVM_TIMEOUT= allows the user to change the global timeout of the UVM framework  

System functions for command line arguments in SystemVerilog :
  
-Similar to uvm_cmdline_processor  class methods, System Verilog also provides some system functions.

System Functions                             Description

$test$plusargs()                             Searches in the list of arguments for specified user strings. For a successful match, 
                                             it returns a non-zero integer otherwise returns zero. 
  
$value$plusargs()                           Get the value for the specified user string in the variable.  
                                            For a successful match for the given string, it returns a non-zero integer and 
                                            store value in the variable otherwise returns zero.  
  

  
