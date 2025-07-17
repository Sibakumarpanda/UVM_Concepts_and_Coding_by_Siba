//Example1: Example demonstraing uvm_printer concept
//-------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    :  testbench.sv
// Project :  Understanding uvm_printer concept 
// Purpose :  It contains all the files at one place 
// Author  :  Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////
`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum{RED, GREEN, BLUE} color_type;

//temp_class
class temp_class extends uvm_object;
  rand bit [7:0] tmp_addr;
  rand bit [7:0] tmp_data;
  
  function new(string name = "temp_class");
    super.new(name);
  endfunction :new
  
  `uvm_object_utils_begin(temp_class)
    `uvm_field_int(tmp_addr, UVM_ALL_ON)
    `uvm_field_int(tmp_data, UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass :temp_class

//my_object class

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
  endfunction :new
  
endclass:my_object

//my_test class
class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  my_object obj;
  bit packed_data_bits[];
  byte unsigned packed_data_bytes[];
  int unsigned packed_data_ints[];
  
  my_object unpack_obj;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction :new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj = my_object::type_id::create("obj", this);
    assert(obj.randomize());
    `uvm_info(get_full_name(), "****Example to understand uvm_printer concept by Mr.Siba K Panda****", UVM_LOW);
    `uvm_info(get_full_name(), "obj print without any argument", UVM_LOW);
    
    // Knob setting.
    uvm_default_printer.knobs.indent = 5;
    uvm_default_printer.knobs.hex_radix = "0x";
    
    obj.print();
    
    `uvm_info(get_full_name(), "obj print with uvm_default_table_printer argument", UVM_LOW);
    obj.print(uvm_default_table_printer);
    
    `uvm_info(get_full_name(), "obj print with uvm_default_tree_printer argument", UVM_LOW);
    obj.print(uvm_default_tree_printer);
    
    `uvm_info(get_full_name(), "obj print with uvm_default_line_printer argument", UVM_LOW);
    obj.print(uvm_default_line_printer);
    
  endfunction :build_phase
  
endclass :my_test

//tb_top module
module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule :tb_top

//LogFile output using Synopsys VCS Tool
Starting vcs inline pass...

4 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling module tb_top
All of 4 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _425_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 7.963 seconds to compile + .317 seconds to elab + .623 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jul 17 04:53 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO testbench.sv(69) @ 0: uvm_test_top [uvm_test_top] ****Example to understand uvm_printer concept by Mr.Siba K Panda****
UVM_INFO testbench.sv(70) @ 0: uvm_test_top [uvm_test_top] obj print without any argument
--------------------------------------------------
Name                Type          Size  Value     
--------------------------------------------------
obj                 my_object     -     @349      
     value          integral      32    0x1f135537
     names          string        3     UVM       
     colors         color_type    32    GREEN     
     data           sa(integral)  4     -         
          [0]       integral      8     0x9f      
          [1]       integral      8     0x33      
          [2]       integral      8     0x12      
          [3]       integral      8     0x9c      
     addr           integral      8     0x2f      
     tmp            temp_class    -     @350      
          tmp_addr  integral      8     0x39      
          tmp_data  integral      8     0xbd      
--------------------------------------------------
UVM_INFO testbench.sv(78) @ 0: uvm_test_top [uvm_test_top] obj print with uvm_default_table_printer argument
--------------------------------------------------
Name                Type          Size  Value     
--------------------------------------------------
obj                 my_object     -     @349      
     value          integral      32    0x1f135537
     names          string        3     UVM       
     colors         color_type    32    GREEN     
     data           sa(integral)  4     -         
          [0]       integral      8     0x9f      
          [1]       integral      8     0x33      
          [2]       integral      8     0x12      
          [3]       integral      8     0x9c      
     addr           integral      8     0x2f      
     tmp            temp_class    -     @350      
          tmp_addr  integral      8     0x39      
          tmp_data  integral      8     0xbd      
--------------------------------------------------
UVM_INFO testbench.sv(81) @ 0: uvm_test_top [uvm_test_top] obj print with uvm_default_tree_printer argument
obj: (my_object@349) {
  value: 'h1f135537 
  names: UVM 
  colors: GREEN 
  data: {
    [0]: 'h9f 
    [1]: 'h33 
    [2]: 'h12 
    [3]: 'h9c 
  }
  addr: 'h2f 
  tmp: (temp_class@350) {
    tmp_addr: 'h39 
    tmp_data: 'hbd 
  }
}
UVM_INFO testbench.sv(84) @ 0: uvm_test_top [uvm_test_top] obj print with uvm_default_line_printer argument
obj: (my_object@349) { value: 'h1f135537  names: UVM  colors: GREEN  data: { [0]: 'h9f  [1]: 'h33  [2]: 'h12  [3]: 'h9c  } addr: 'h2f  tmp: (temp_class@350) { tmp_addr: 'h39  tmp_data: 'hbd  } } 
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    7
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1
[uvm_test_top]     5

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.340 seconds;       Data structure size:   0.2Mb
Thu Jul 17 04:53:05 2025
Done
