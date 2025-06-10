/*
copy method in UVM :The copy method does a copy of the mentioned object. It performs a deep copy.
Example4: copy method with `uvm_object_utils and with Field macros .           
*/

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
    this.names = "UVM";
  endfunction
  
endclass : my_object

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  my_object obj_A, obj_B;
  bit packed_data_bits[];
  byte unsigned packed_data_bytes[];
  int unsigned packed_data_ints[];
  
  my_object unpack_obj;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj_A = my_object::type_id::create("obj_A", this);
    obj_B = my_object::type_id::create("obj_B", this);
    assert(obj_A.randomize());
    assert(obj_B.randomize());
    `uvm_info(get_full_name(), $sformatf("Before copying: obj_A = \n%s and obj_B = \n%s", obj_A.sprint(), obj_B.sprint()), UVM_LOW);
    obj_B.copy(obj_A);
    `uvm_info(get_full_name(), $sformatf("After copying: obj_A = \n%s and obj_B = \n%s", obj_A.sprint(), obj_B.sprint()), UVM_LOW);
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
CPU time: 14.049 seconds to compile + .498 seconds to elab + .999 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun 10 00:45 2025
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
UVM_INFO testbench.sv(72) @ 0: uvm_test_top [uvm_test_top] Before copying: obj_A = 
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
obj_A         my_object     -     @464      
  value       integral      32    'h1f135537
  names       string        3     UVM       
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
obj_B         my_object     -     @466      
  value       integral      32    'he96c3deb
  names       string        3     UVM       
  colors      color_type    32    RED       
  data        sa(integral)  4     -         
    [0]       integral      8     'hcb      
    [1]       integral      8     'h49      
    [2]       integral      8     'hcc      
    [3]       integral      8     'h49      
  addr        integral      8     'h6d      
  tmp         temp_class    -     @467      
    tmp_addr  integral      8     'h66      
    tmp_data  integral      8     'h27      
--------------------------------------------

UVM_INFO testbench.sv(74) @ 0: uvm_test_top [uvm_test_top] After copying: obj_A = 
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
obj_A         my_object     -     @464      
  value       integral      32    'h1f135537
  names       string        3     UVM       
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
obj_B         my_object     -     @466      
  value       integral      32    'h1f135537
  names       string        3     UVM       
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
CPU Time:      0.520 seconds;       Data structure size:   0.2Mb
Tue Jun 10 00:45:44 2025
Done

/*
copy method in UVM :The copy method does a copy of the mentioned object. It performs a deep copy.
Example5: copy method with `uvm_object_utils and with out Field macros (using do_copy method) 
The do_copy() callback method is a user-defined hook that is called by the copy() method. 
The derived class should override the uvm_object_utils_begin, uvm_object_utils_end and `uvm_field_* macros are not used.
          
*/

//`include "uvm_macros.svh"
//import uvm_pkg::*;

typedef enum{RED, GREEN, BLUE} color_type;

class temp_class extends uvm_object;
  
  `uvm_object_utils(temp_class)
  
  rand bit [7:0] tmp_addr;
  rand bit [7:0] tmp_data;
  
  function new(string name = "temp_class");
    super.new(name);
  endfunction
  
  
  function void do_copy(uvm_object local_h);
    temp_class tmp_h;
    super.do_copy(local_h);
    // $cast is necessary: uvm_object local_h do not have temp_class properties (tmp_addr and tmp_data)
    // temp_class is extended from uvm_object, so child class temp_class handle is required for copying each property.
    $cast(tmp_h, local_h);
    tmp_addr = tmp_h.tmp_addr;
    tmp_data = tmp_h.tmp_data;
  endfunction
  
endclass :temp_class

class my_object extends uvm_object;
  
  `uvm_object_utils(my_object)
  
  rand int        value;
       string     names;
  rand color_type colors;
  rand byte       data[4];
  rand bit [7:0]  addr;
  rand temp_class tmp; 
  
  function new(string name = "my_object");
    super.new(name);
    tmp = new();
  endfunction
  
  function void do_copy(uvm_object local_h);
    my_object my_obj;
    super.do_copy(local_h);
    $cast(my_obj, local_h);
    value = my_obj.value;
    names = my_obj.names;
    colors= my_obj.colors;
    data = my_obj.data;
    addr = my_obj.addr;
    tmp.copy(my_obj.tmp);
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
    obj_B = my_object::type_id::create("obj_B", this);
    assert(obj_A.randomize());
    assert(obj_B.randomize());
    `uvm_info(get_full_name(), "Before copying", UVM_LOW);
    obj_print(obj_A);
    obj_print(obj_B);
    obj_B.copy(obj_A);
    `uvm_info(get_full_name(), "After copying", UVM_LOW);
    obj_print(obj_B);
  endfunction
  
  function void obj_print(uvm_object obj);
    my_object my_obj;
    string out;
    $cast(my_obj, obj);
    $display("-----------------------------");
    $display("----------  %s  ----------", my_obj.get_name);
    $display("-----------------------------");
    $sformat(out, "value = %0h, names = %s, addr = %0h", my_obj.value, my_obj.names, my_obj.addr); 
    `uvm_info(get_full_name(), $sformatf("%s", out), UVM_LOW);
    foreach(my_obj.data[i]) 
      `uvm_info(get_full_name(), $sformatf("data[%0d] = %h", i, my_obj.data[i]), UVM_LOW);
    $sformat(out, "tmp_addr = %0h, tmp_data = %0h", my_obj.tmp.tmp_addr, my_obj.tmp.tmp_data); 
    `uvm_info(get_full_name(), $sformatf("tmp: %s", out), UVM_LOW);
  endfunction
  
endclass :my_test

module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule
  
//LogFile Output
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
CPU time: 12.165 seconds to compile + .433 seconds to elab + .946 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun 10 00:47 2025
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
UVM_INFO testbench.sv(85) @ 0: uvm_test_top [uvm_test_top] Before copying
-----------------------------
----------  obj_A  ----------
-----------------------------
UVM_INFO testbench.sv(101) @ 0: uvm_test_top [uvm_test_top] value = 1f135537, names = , addr = 2f
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[0] = 9f
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[1] = 33
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[2] = 12
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[3] = 9c
UVM_INFO testbench.sv(105) @ 0: uvm_test_top [uvm_test_top] tmp: tmp_addr = 39, tmp_data = bd
-----------------------------
----------  obj_B  ----------
-----------------------------
UVM_INFO testbench.sv(101) @ 0: uvm_test_top [uvm_test_top] value = e96c3deb, names = , addr = 6d
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[0] = cb
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[1] = 49
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[2] = cc
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[3] = 49
UVM_INFO testbench.sv(105) @ 0: uvm_test_top [uvm_test_top] tmp: tmp_addr = 66, tmp_data = 27
UVM_INFO testbench.sv(89) @ 0: uvm_test_top [uvm_test_top] After copying
-----------------------------
----------  obj_B  ----------
-----------------------------
UVM_INFO testbench.sv(101) @ 0: uvm_test_top [uvm_test_top] value = 1f135537, names = , addr = 2f
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[0] = 9f
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[1] = 33
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[2] = 12
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] data[3] = 9c
UVM_INFO testbench.sv(105) @ 0: uvm_test_top [uvm_test_top] tmp: tmp_addr = 39, tmp_data = bd

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   21
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[uvm_test_top]    20
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.570 seconds;       Data structure size:   0.2Mb
Tue Jun 10 00:47:09 2025
Done 
