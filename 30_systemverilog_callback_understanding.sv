System Verilog Callback Understanding:
-The callbacks are used to alter the behavior of the component without modifying its code. 
-The verification engineer provides a set of hook methods that helps to customize the behavior depending on the requirement. 
-A simple example of callbacks can be the pre_randomize and post_randomize methods before and after the built-in randomize method call.

Callback usage:
-It allows plug-and-play mechanism to establish a reusable verification environment.
-Based on the hook method call, the user-defined code is executed instead of the empty callback method.
-Simply, callbacks are the empty methods that can be implemented in the derived class to tweak the component behavior. 
-These empty methods are called callback methods and calls to these methods are known as callback hooks.

A Simple Callback Example :
-In below example, modify_pkt is a callback method and it is being called in the pkt_sender task known as callback hook.
-The driver class drives a GOOD packet. 
-The err_driver is a derived class of the driver class and it sends a corrupted packet of type BAD_ERR1 or BAD_ERR2 depending on the inject_err bit.
-If the inject_err bit is set, then a corrupted packet will be generated otherwise a GOOD packet will be generated.  

//Callback Example using System Verilog-Example1
//-----------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_driver.sv
// Project :  Understanding System Verilog Callback
// Purpose :  Driver file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_DRIVER_SV
`define GUARD_MY_DRIVER_SV

typedef enum {GOOD, BAD_ERR1, BAD_ERR2} pkt_type;

class my_driver;
  pkt_type pkt;
  
  task pkt_sender;
    //$display("************** Initially Sending good pkt ********************");
    std::randomize(pkt) with {pkt == GOOD;};
    modify_pkt;
  endtask :pkt_sender
  
  virtual task modify_pkt; // callback method
  endtask :modify_pkt
  
endclass :my_driver

`endif //GUARD_MY_DRIVER_SV

//----------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_err_driver.sv
// Project :  Understanding System Verilog Callback
// Purpose :  Error Driver file 
//             (Error introduction via err_driver class where callback method modify_pkt is implemented.)
// Author  :  Siba Kumar Panda
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_ERR_DRIVER_SV
`define GUARD_MY_ERR_DRIVER_SV

class my_err_driver extends my_driver;
  
  task modify_pkt;
    $display("************** Now Injecting error pkt ********************");
    std::randomize(pkt) with {pkt inside {BAD_ERR1, BAD_ERR2};};
  endtask :modify_pkt
  
endclass :my_err_driver

`endif //GUARD_MY_ERR_DRIVER_SV  

//-----------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_env.sv
// Project :  Understanding System Verilog Callback
// Purpose :  Environment file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_ENV_SV
`define GUARD_MY_ENV_SV

class my_env;
  
  bit inject_err;
  my_driver     drv;
  my_err_driver drv_err;
  
  function new();
    drv = new();
    drv_err = new();
  endfunction :new
  
  task execute;
    if(inject_err) 
      drv = drv_err;
    // Sending a packet
    drv.pkt_sender();
    $display("Sending packet type = %s", drv.pkt.name());
  endtask :execute
  
endclass :my_env

`endif //GUARD_MY_ENV_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding System Verilog Callback
// Purpose :  package File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_PACKAGE_SV
`define GUARD_MY_PACKAGE_SV

package my_package;

//import uvm_pkg::*;

`include "my_driver.sv"
`include "my_err_driver.sv"
`include "my_env.sv"

endpackage :my_package

`endif //GUARD_MY_PACKAGE_SV  

//-----------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  testbench.sv
// Project :  Understanding System Verilog Callback
// Purpose :  tb_top file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////

`include "my_package.sv"  // Include the package containing other necessary definitions
import my_package::*;    // Import the package that includes transaction and environment classes

module tb_top_callback_example();
  my_env env_o;
  
  initial begin
    // Sending GOOD packet
    env_o = new();
    env_o.inject_err = 0;
    repeat(3) 
      env_o.execute;
    
    // Injecting an error
    env_o = new();
    env_o.inject_err = 1;
    repeat(10) 
      env_o.execute;
    
    // Sending GOOD packet
    env_o = new();
    env_o.inject_err = 0;
    repeat(3) 
      env_o.execute;
  end
  
endmodule :tb_top_callback_example
  
//Log File Output using Synopsys Tool
 Starting vcs inline pass...

2 modules and 0 UDP read.
recompiling package my_package
recompiling module tb_top_callback_example
Both modules done.
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./   objs/amcQw_d.o   _331_archive_1.so   SIM_l.o       rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive          /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: .282 seconds to compile + .264 seconds to elab + .271 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 18 00:53 2025
Sending packet type = GOOD
Sending packet type = GOOD
Sending packet type = GOOD
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR2
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
************** Now Injecting error pkt ********************
Sending packet type = BAD_ERR1
Sending packet type = GOOD
Sending packet type = GOOD
Sending packet type = GOOD
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.320 seconds;       Data structure size:   0.0Mb
Fri Jul 18 00:53:08 2025
Done 
