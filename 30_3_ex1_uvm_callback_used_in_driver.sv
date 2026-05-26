//Callback Example using UVM-Ex1 , (Callback used in Driver Component )
//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_driver.sv
// Project :  Understanding UVM Callback
// Purpose :  Driver File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_DRIVER_SV
`define GUARD_MY_DRIVER_SV
typedef enum {GOOD, BAD_ERR1, BAD_ERR2} pkt_type;
pkt_type pkt;

class my_driver extends uvm_component;
  
  `uvm_component_utils(my_driver)
  `uvm_register_cb(my_driver,my_callback) // callback registration
  
  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name,parent);
  endfunction :new
  
  task run_phase(uvm_phase phase); 
    super.run_phase(phase);
    drive();
    `uvm_do_callbacks(my_driver,my_callback,modify_pkt()); // callback hook
    `uvm_info(get_full_name(),$sformatf("Driven pkt is %s", pkt.name()),UVM_LOW);
  endtask : run_phase
  
  task drive();
    `uvm_info(get_full_name(),"Inside drive method",UVM_LOW);
    std::randomize(pkt) with {pkt == GOOD;};
  endtask :drive
  
endclass :my_driver
`endif // GUARD_MY_DRIVER_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_env.sv
// Project :  Understanding UVM Callback
// Purpose :  Environment File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_ENV_SV
`define GUARD_MY_ENV_SV

class my_env extends uvm_env;
  `uvm_component_utils(my_env)
  
  my_driver drv;
  
  function new(string name = "my_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = my_driver::type_id::create("drv", this);
  endfunction :build_phase
  
endclass :my_env

`endif // GUARD_MY_ENV_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_callback.sv
// Project :  Understanding UVM Callback
// Purpose :  My Callback  File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_CALLBACK_SV
`define GUARD_MY_CALLBACK_SV

class my_callback extends uvm_callback;
  
  `uvm_object_utils(my_callback)
  
  function new(string name = "my_callback");
    super.new(name);
  endfunction :new
  
  virtual task modify_pkt();
  endtask :modify_pkt
  
endclass :my_callback

`endif //GUARD_MY_CALLBACK_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_driver_callback.sv
// Project :  Understanding UVM Callback
// Purpose :  Driver callback File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_DRIVER_CALLBACK_SV
`define GUARD_MY_DRIVER_CALLBACK_SV

class my_driver_callback extends my_callback;
  
  `uvm_object_utils(my_driver_callback)
  
  function new(string name = "my_driver_callback");
    super.new(name);
  endfunction :new
  
  task modify_pkt; // callback method implementation
    
    `uvm_info(get_full_name(),"Inside modify_pkt method: Injecting error pkt",UVM_LOW);
     std::randomize(pkt) with {pkt inside {BAD_ERR1, BAD_ERR2};};
     
  endtask :modify_pkt
  
endclass :my_driver_callback

`endif //GUARD_MY_DRIVER_CALLBACK_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_test.sv
// Project :  Understanding UVM Callback
// Purpose :  Base test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_BASE_TEST_SV
`define GUARD_MY_BASE_TEST_SV

class my_base_test extends uvm_test;
  
  `uvm_component_utils(my_base_test)
  
  my_env env_o;
  
  function new(string name = "my_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = my_env::type_id::create("env_o", this);
  endfunction :build_phase
  
endclass :my_base_test

`endif // GUARD_MY_BASE_TEST_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_err_test.sv
// Project :  Understanding UVM Callback
// Purpose :  Error test File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_ERROR_TEST_SV
`define GUARD_MY_ERROR_TEST_SV

class my_err_test extends my_base_test;
  
  `uvm_component_utils(my_err_test)
  
  my_driver_callback drvr_cb;
  
  function new(string name = "my_err_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drvr_cb = my_driver_callback::type_id::create("drvr_cb", this);
    uvm_callbacks#(my_driver, my_callback)::add(env_o.drv, drvr_cb);
  endfunction : build_phase
  
endclass :my_err_test

`endif //GUARD_MY_ERROR_TEST_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding UVM Callback
// Purpose :  package File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_PACKAGE_SV
`define GUARD_MY_PACKAGE_SV

package my_package;

import uvm_pkg::*;
`include "my_callback.sv"
`include "my_driver_callback.sv"
`include "my_driver.sv"
`include "my_env.sv"
`include "my_base_test.sv"
`include "my_err_test.sv"
endpackage :my_package
`endif //GUARD_MY_PACKAGE_SV
//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding UVM Callback
// Purpose :  package File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////
//import uvm_pkg::*;         // Import UVM package for base classes and utilities
`include "uvm_macros.svh"   // Include UVM macros for logging and other utilities
`include "my_package.sv"  // Include the package containing other necessary definitions
import my_package::*;    // Import the package that includes transaction and environment classes

module tb_top;
  initial begin
    //run_test("my_base_test");
    //run_test("my_err_test");
    run_test();
  end
endmodule :tb_top

//LogFile Output using Synopsys VCS Tool (  with +UVM_TESTNAME=my_base_test )
Starting vcs inline pass...

5 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling package my_package
recompiling module tb_top
All of 5 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _425_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 8.240 seconds to compile + .302 seconds to elab + .666 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 19 09:21 2025
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh(402) @ 0: reporter [UVM/RELNOTES] 
----------------------------------------------------------------
UVM-1.2.Synopsys
(C) 2007-2014 Mentor Graphics Corporation
(C) 2007-2014 Cadence Design Systems, Inc.
(C) 2006-2014 Synopsys, Inc.
(C) 2011-2013 Cypress Semiconductor Corp.
(C) 2013-2014 NVIDIA Corporation
----------------------------------------------------------------

  ***********       IMPORTANT RELEASE NOTES         ************

  You are using a version of the UVM library that has been compiled
  with `UVM_NO_DEPRECATED undefined.
  See http://www.eda.org/svdb/view.php?id=3313 for more details.

  You are using a version of the UVM library that has been compiled
  with `UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR undefined.
  See http://www.eda.org/svdb/view.php?id=3770 for more details.

      (Specify +UVM_NO_RELNOTES to turn off this notice)

UVM_INFO @ 0: reporter [RNTST] Running test my_base_test...
UVM_INFO my_driver.sv(34) @ 0: uvm_test_top.env_o.drv [uvm_test_top.env_o.drv] Inside drive method
UVM_INFO my_driver.sv(30) @ 0: uvm_test_top.env_o.drv [uvm_test_top.env_o.drv] Driven pkt is GOOD
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    4
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1
[uvm_test_top.env_o.drv]     2

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.350 seconds;       Data structure size:   0.2Mb
Sat Jul 19 09:21:39 2025
Done
  
//LogFile Output using Synopsys VCS Tool (  with +UVM_TESTNAME=my_err_test )
  
Starting vcs inline pass...
5 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling package my_package
recompiling module tb_top
All of 5 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _425_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 7.492 seconds to compile + .274 seconds to elab + .593 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 19 09:22 2025
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh(402) @ 0: reporter [UVM/RELNOTES] 
----------------------------------------------------------------
UVM-1.2.Synopsys
(C) 2007-2014 Mentor Graphics Corporation
(C) 2007-2014 Cadence Design Systems, Inc.
(C) 2006-2014 Synopsys, Inc.
(C) 2011-2013 Cypress Semiconductor Corp.
(C) 2013-2014 NVIDIA Corporation
----------------------------------------------------------------

  ***********       IMPORTANT RELEASE NOTES         ************

  You are using a version of the UVM library that has been compiled
  with `UVM_NO_DEPRECATED undefined.
  See http://www.eda.org/svdb/view.php?id=3313 for more details.

  You are using a version of the UVM library that has been compiled
  with `UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR undefined.
  See http://www.eda.org/svdb/view.php?id=3770 for more details.

      (Specify +UVM_NO_RELNOTES to turn off this notice)

UVM_INFO @ 0: reporter [RNTST] Running test my_err_test...
UVM_INFO my_driver.sv(34) @ 0: uvm_test_top.env_o.drv [uvm_test_top.env_o.drv] Inside drive method
UVM_INFO my_driver_callback.sv(23) @ 0: reporter [drvr_cb] Inside modify_pkt method: Injecting error pkt
UVM_INFO my_driver.sv(30) @ 0: uvm_test_top.env_o.drv [uvm_test_top.env_o.drv] Driven pkt is BAD_ERR2
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    5
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1
[drvr_cb]     1
[uvm_test_top.env_o.drv]     2

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.360 seconds;       Data structure size:   0.2Mb
Sat Jul 19 09:22:20 2025
Done
