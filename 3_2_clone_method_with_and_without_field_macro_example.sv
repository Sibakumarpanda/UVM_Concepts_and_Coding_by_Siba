/*
clone method in UVM :
Example6: clone method with `uvm_object_utils and with Field macros 
The clone method calls the create() method followed by copy(). Thus, it creates and returns a copy of an object.          
*/

//`include "uvm_macros.svh"
//import uvm_pkg::*;

typedef enum{RED, GREEN, BLUE} color_type;

class temp_class extends uvm_object;
  
  rand bit [7:0] tmp_addr;
  rand bit [7:0] tmp_data;
  
  function new(string name = "temp_class");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(temp_class)
    `uvm_field_int(tmp_addr, UVM_ALL_ON)
    `uvm_field_int(tmp_data, UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass :temp_class

class my_object extends uvm_object;
  
  rand int        value;
       string     names;
  rand color_type colors;
  rand byte       data[4];
  rand bit [7:0]  addr;
  rand temp_class tmp;
  
  `uvm_object_utils_begin(my_object)
    `uvm_field_int(value, UVM_ALL_ON)
    `uvm_field_string(names, UVM_ALL_ON)
    `uvm_field_enum(color_type, colors, UVM_ALL_ON)
    `uvm_field_sarray_int(data, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_object(tmp, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "my_object");
    super.new(name);
    tmp = new();
  endfunction
  
endclass :my_object

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  my_object obj_A, obj_B;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj_A = my_object::type_id::create("obj_A", this);
    assert(obj_A.randomize());
    if(obj_B == null) 
      `uvm_info(get_full_name(), "obj_B is not created", UVM_LOW);
    $cast(obj_B, obj_A.clone());
    `uvm_info(get_full_name(), $sformatf("AFter clone:\n obj_A = \n%s and obj_B = \n%s", obj_A.sprint(), obj_B.sprint()), UVM_LOW);
  endfunction
  
endclass :my_test

module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule :tb_top

//Log File Output
Starting vcs inline pass...

4 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling module tb_top
All of 4 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _425_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 13.851 seconds to compile + .497 seconds to elab + .943 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun 10 01:00 2025
----------------------------------------------------------------
UVM-1.1d.Synopsys
(C) 2007-2013 Mentor Graphics Corporation
(C) 2007-2013 Cadence Design Systems, Inc.
(C) 2006-2013 Synopsys, Inc.
(C) 2011-2013 Cypress Semiconductor Corp.
----------------------------------------------------------------

  ***********       IMPORTANT RELEASE NOTES         ************

  You are using a version of the UVM library that has been compiled
  with `UVM_NO_DEPRECATED undefined.
  See http://www.eda.org/svdb/view.php?id=3313 for more details.

  You are using a version of the UVM library that has been compiled
  with `UVM_OBJECT_MUST_HAVE_CONSTRUCTOR undefined.
  See http://www.eda.org/svdb/view.php?id=3770 for more details.

      (Specify +UVM_NO_RELNOTES to turn off this notice)

UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO testbench.sv(70) @ 0: uvm_test_top [uvm_test_top] obj_B is not created
UVM_INFO testbench.sv(72) @ 0: uvm_test_top [uvm_test_top] AFter clone:
 obj_A = 
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
obj_A         my_object     -     @464      
  value       integral      32    'h1f135537
  names       string        0     ""        
  colors      color_type    32    GREEN     
  data        sa(integral)  4     -         
    [0]       integral      8     'h9f      
    [1]       integral      8     'h33      
    [2]       integral      8     'h12      
    [3]       integral      8     'h9c      
  addr        integral      8     'h2f      
  tmp         temp_class    -     @465      
    tmp_addr  integral      8     'h39      
    tmp_data  integral      8     'hbd      
--------------------------------------------
 and obj_B = 
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
obj_A         my_object     -     @466      
  value       integral      32    'h1f135537
  names       string        0     ""        
  colors      color_type    32    GREEN     
  data        sa(integral)  4     -         
    [0]       integral      8     'h9f      
    [1]       integral      8     'h33      
    [2]       integral      8     'h12      
    [3]       integral      8     'h9c      
  addr        integral      8     'h2f      
  tmp         temp_class    -     @468      
    tmp_addr  integral      8     'h39      
    tmp_data  integral      8     'hbd      
--------------------------------------------


--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    3
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[uvm_test_top]     2
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.490 seconds;       Data structure size:   0.2Mb
Tue Jun 10 01:00:43 2025
Done

