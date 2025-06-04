Factory Overriding :
Based on the requirement, the behavior of the testbench can be changed by substituting one class with another when it is constructed. 
It is the process that allows an object of one type to be overridden with an object of its derived type without changing the testbench structure.   
This facility of the uvm factory allows users to override the class without editing or recompiling the code.

How factory overriding happens?
A factory can be thought of as a look-up table and a factory component wrapper class can be accessed using type_id which is used in create method and returns a resultant handle. 
Using the polymorphism concept, the factory override mechanism returns a derived type handle using a base type handle. 
This means when the create method is being called for the base class type, uvm_factory will return a pointer to an object of a derived class type.  
Note: The factory override ways are applicable for both uvm components and uvm objects.  

Factory overriding ways are: 
  1. Type Override      (set_type_override_by_type , set_type_override_by_name)
  2. Instance Override  (set_inst_override_by_type  )

Type override in UVM factory:
In a type override, a substitute component class type is created instead of an original component class in the testbench hierarchy. This applies to all instances of that component type.

Methods of type override in UVM factory:
  
set_type_override_by_type , Synatx :  function void set_type_override_by_type (uvm_object_wrapper original_type,
                                                                               uvm_object_wrapper override_type,
                                                                                bit replace = 1)
set_type_override_by_name  , Synatx : function void set_type_override_by_name (string original_type_name,
                                                                               string override_type_name,
                                                                               bit replace = 1)
