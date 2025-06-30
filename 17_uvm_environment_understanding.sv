UVM Environment Understanding:
-An environment provides a well-mannered hierarchy and container for agents, scoreboards and other verification components including other environment classes that are helpful in reusing block-level environment components at the SoC level. 
-The user-defined env class has to be extended from the uvm_env class.

Class Declaration :                    virtual class uvm_env extends uvm_component;
User-defined env class declaration :   class <env_name> extends uvm_env;
  
How to create a UVM env?
