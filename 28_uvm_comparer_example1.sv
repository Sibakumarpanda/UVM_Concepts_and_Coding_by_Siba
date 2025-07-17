Example1: To undestand uvm_comparer concept
//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_transaction.sv
// Project :  Understanding uvm_comparer concept 
// Purpose :  Transaction class/seq item file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_TRANSACTION_SV
`define GUARD_MY_TRANSACTION_SV

class my_transaction extends uvm_object;
  rand bit[15:0] addr;
  rand bit[15:0] data;
  
  `uvm_object_utils_begin(my_transaction)
    `uvm_field_int(addr, UVM_PRINT);
    `uvm_field_int(data, UVM_PRINT);
  `uvm_object_utils_end
  
  function new(string name = "my_transaction");
    super.new(name);
  endfunction :new
  
endclass :my_transaction

`endif //GUARD_MY_TRANSACTION_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_base_test.sv
// Project :  Understanding uvm_comparer concept 
// Purpose :  my_base_test file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_MY_BASE_TEST_SV
`define GUARD_MY_BASE_TEST_SV

class my_base_test extends uvm_test;
  
  my_transaction tr1, tr2;
  uvm_comparer comp;

  `uvm_component_utils(my_base_test)
  
  function new(string name = "my_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr1 = my_transaction::type_id::create("tr1", this);
    tr2 = my_transaction::type_id::create("tr2", this);
    comp = new();
  endfunction :build_phase
 
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    assert(tr1.randomize());
    assert(tr2.randomize());
    
    comp.verbosity = UVM_LOW;
    comp.sev = UVM_ERROR;
    comp.show_max = 100;
    
    `uvm_info(get_full_name(), "Comparing objects", UVM_LOW)
    comp.compare_object("tr_compare", tr1, tr2);
    tr2.copy(tr1);
    comp.compare_object("tr_compare", tr1, tr2);
    `uvm_info(get_full_name(), $sformatf("Comparing objects: result = %0d", comp.result), UVM_LOW)
    
    comp.compare_field_int("int_compare", 5'h2, 5'h4, 5);
    comp.compare_string("string_compare", "name", "names");
    
    `uvm_info(get_full_name(), $sformatf("Comparing objects: result = %0d", comp.result), UVM_LOW)
    
    comp.compare_field_int("int_compare", 5'h4, 5'h4, 5);
    comp.compare_string("string_compare", "name", "name");
  endtask :run_phase
  
endclass :my_base_test

`endif //GUARD_MY_BASE_TEST_SV

//--------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  my_package.sv
// Project :  Understanding uvm_comparer concept 
// Purpose :  package File
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_MY_PACKAGE_SV
`define GUARD_MY_PACKAGE_SV

package my_package;

import uvm_pkg::*;

`include "my_transaction.sv"
`include "my_base_test.sv"

endpackage :my_package

`endif //GUARD_MY_PACKAGE_SV

//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  testbench.sv
// Project :  Understanding uvm_comparer concept 
// Purpose :  tb_top file 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
//import uvm_pkg::*;         // Import UVM package for base classes and utilities
`include "uvm_macros.svh"   // Include UVM macros for logging and other utilities
`include "my_package.sv"  // Include the package containing other necessary definitions
import my_package::*;    // Import the package that includes transaction and environment classes

module tb_top;
  initial begin
    run_test("my_base_test");
  end
endmodule :tb_top

//LogFile Output Using Synopsys Tool:
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
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _427_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 8.612 seconds to compile + .277 seconds to elab + .604 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 17 01:21 2025
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
UVM_INFO my_base_test.sv(40) @ 0: uvm_test_top [uvm_test_top] Comparing objects
UVM_ERROR /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_comparer.svh(351) @ 0: reporter [MISCMP] Miscompare for tr_compare.addr: lhs = 'h5537 : rhs = 'h8441
UVM_ERROR /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_comparer.svh(351) @ 0: reporter [MISCMP] Miscompare for tr_compare.data: lhs = 'h5fe3 : rhs = 'h6483
UVM_ERROR /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_comparer.svh(382) @ 0: reporter [MISCMP] 2 Miscompare(s) for object tr2@350 vs. tr1@349
UVM_ERROR /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_comparer.svh(382) @ 0: reporter [MISCMP] 2 Miscompare(s) for object tr2@350 vs. tr1@349
UVM_INFO my_base_test.sv(44) @ 0: uvm_test_top [uvm_test_top] Comparing objects: result = 2
UVM_ERROR /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_comparer.svh(351) @ 0: reporter [MISCMP] Miscompare for int_compare: lhs = 'h2 : rhs = 'h4
UVM_ERROR /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_comparer.svh(351) @ 0: reporter [MISCMP] Miscompare for string_compare: lhs = "name" : rhs = "names"
UVM_INFO my_base_test.sv(49) @ 0: uvm_test_top [uvm_test_top] Comparing objects: result = 4
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    5
UVM_WARNING :    0
UVM_ERROR :    6
UVM_FATAL :    0
** Report counts by id
[MISCMP]     6
[RNTST]     1
[UVM/RELNOTES]     1
[uvm_test_top]     3

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.320 seconds;       Data structure size:   0.2Mb
Thu Jul 17 01:21:18 2025
Done

