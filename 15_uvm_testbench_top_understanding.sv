UVM TB Top: (Its Job and Functionality)

-The testbench top is a static container that has an instantiation of DUT and interfaces. 
-The interface instance connects with DUT signals in the testbench top. 
-The clock is generated and initially reset is applied to the DUT.
-It is also passed to the interface handle. 
-An interface is stored in the uvm_config_db using the set method and it can be retrieved down the hierarchy using the get method. 
-UVM testbench top is also used to trigger a test using run_test() call.

// Code Snippet example 
`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;
  bit clk;
  bit reset;
  always #5 clk = ~clk;
  
  initial begin
    clk = 0;
    reset = 1;
    #5; 
    reset = 0;
  end
  add_if vif(clk, reset);
  
  // Instantiate design top
  adder DUT(.clk(vif.clk),
            .reset(vif.reset),
            .in1(vif.ip1),
            .in2(vif.ip2),
            .out(vif.out)
           );
  
  initial begin
    // set interface in config_db
    uvm_config_db#(virtual add_if)::set(uvm_root::get(), "*", "vif", vif);
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  initial begin
    run_test("base_test");
  end
endmodule  
