
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

//uvm_test Example :Generic Code Snippet

class my_test extends uvm_test;
  env env_o;
  base_seq bseq;
  `uvm_component_utils(my_test)
  
  // constructor
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction

  //run_phase
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bseq = base_seq::type_id::create("bseq");
        
    repeat(10) begin 
      #5; bseq.start(env_o.agt.seqr);
    end
    
    phase.drop_objection(this);
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
  endtask
endclass  :my_test

Execution of the test :
-The test execution is a time-consuming activity that runs sequence or sequences for DUT functionality. 
-On executing the test, it builds a complete UVM testbench structure in the build_phase and time consuming activities are performed in the run_phase with the help of sequences. 
-It is mandatory to register tests in the UVM factory otherwise, the simulation will terminate with UVM_FATAL (test not found).

run_test() task :
-The run_test task is a global task declared in the uvm_root class and responsible for running a test case.  
-Declaration:  virtual task run_test (string test_name = "")
1. The run_test task starts the phasing mechanism that executes phases in a pre-defined order.
2. It is called in the initial block of the testbench top and accepts test_name as a string.
-Example :
  // initial block in tb_top module we are writting as below.
initial begin
  run_test("my_test");
end
3. Passing an argument to the run_test task causes recompilation while executing different tests. 
- To avoid it, UVM provides an alternative way using the +UVM_TESTNAME command-line argument. 
- In this case, the run_test task does not require passing any argument in the initial block of the testbench top.  
- For example : 
// initial block of tb_top
initial begin 
  run_test();
end
- With passing command line args : (Passing command line argument to the simulator)
 +UVM_TESTNAME = my_test
4. After execution of all phases, run_test finally calls $finish task for simulator exit.  
  

















  
  
