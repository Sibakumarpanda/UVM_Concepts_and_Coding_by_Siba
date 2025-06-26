
UVM Test Understanding:
-The test is at the top of the hierarchical component that initiates the environment component construction. 
-It is also responsible for the testbench configuration and stimulus generation process. 
-Based on the features and functionalities of the design mentioned in the verification plan, tests are written. 
-The user-defined test class is derived from uvm_test.
-Class Declarations:  virtual class uvm_test extends uvm_component
-The test includes environment class, configurations, and start sequences over sequencers. 
-It is recommended to have a base test that includes all testbench settings including an instance of the environment class, create configurations, etc and varieties of tests as per the verification test plan.
-This can be extended from the base test to avoid repeating the same code in every test. The derived tests can also set configurations based on test requirements.  

Steps to write a test case:
-Create a user-defined test class extended from uvm_test and register it in the factory.
-Declare environment, sequence handle, and configuration objects based on the requirement.
-Write standard new() function. Since the test is a uvm_component. The new() function has two arguments as string name and uvm_component parent.
-Implement build_phase to create instances of environment, sequence classes, and set configurable objects in the configurable database.
-Implement run_phase to start sequences on required sequencers with raise/drop objection callbacks.  
