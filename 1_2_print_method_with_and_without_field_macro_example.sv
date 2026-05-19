/*
The print method is used to deep print UVM object class properties in a well-formatted manner. 
An appropriate `uvm_field_* macro is required to use based on the data type of class properties.
Note: sprint() method is the same as print() method except that sprint() method prints the object in string format.
Example-1:  print method with `uvm_object_utils and with out Field macros
           If the print method is used with `uvm_object_utils, no class properties will be printed.            
 */        

typedef enum{RED, GREEN, BLUE} color_type;

class my_object extends uvm_object;
  
  rand int        o_var;
       string     o_name;
  rand color_type colors;
  rand byte       data[4];
  rand bit [7:0]  addr;
  
  `uvm_object_utils(my_object)
  
  function new(string name = "my_object");
    super.new(name);
  endfunction
  
endclass :my_object

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  my_object obj;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj = my_object::type_id::create("obj", this);
    assert(obj.randomize());
    obj.print();
  endfunction
   
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
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
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _426_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 5.564 seconds to compile + .218 seconds to elab + .394 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  9 02:46 2025
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
----------------------------
Name  Type       Size  Value
----------------------------
obj   my_object  -     @464 
----------------------------
UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
----------------------------------
Name          Type     Size  Value
----------------------------------
uvm_test_top  my_test  -     @456 
----------------------------------


--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    2
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVMTOP]     1
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.260 seconds;       Data structure size:   0.2Mb
Mon Jun  9 02:46:52 2025
Done

/*
The print method is used to deep print UVM object class properties in a well-formatted manner. 
An appropriate `uvm_field_* macro is required to use based on the data type of class properties.
Note: sprint() method is the same as print() method except that sprint() method prints the object in string format.  
Example-2:  print method with `uvm_object_utils and with Field macros
           Here we can see that the  class properties will be printed.            
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
  
endclass : temp_class

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
  
endclass: my_object

class my_test extends uvm_test;
  
  `uvm_component_utils(my_test)
  
  my_object obj;
  bit packed_data_bits[];
  byte unsigned packed_data_bytes[];
  int unsigned packed_data_ints[];
  
  my_object unpack_obj;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj = my_object::type_id::create("obj", this);
    assert(obj.randomize());
    obj.print();
    // or
    //`uvm_info(get_full_name(), $sformatf("obj = \n%s", obj.sprint()), UVM_LOW);
  endfunction
  
endclass :my_test

module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule:tb_top

//Logfile output
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
CPU time: 6.102 seconds to compile + .236 seconds to elab + .439 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  9 02:47 2025
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
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
obj           my_object     -     @464      
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

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    1
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.270 seconds;       Data structure size:   0.2Mb
Mon Jun  9 02:47:47 2025
Done

/*
The print method is used to deep print UVM object class properties in a well-formatted manner. 
An appropriate `uvm_field_* macro is required to use based on the data type of class properties.
Note: sprint() method is the same as print() method except that sprint() method prints the object in string format. 
Example-3:  print method with `uvm_object_utils and without Field macros . (using do_print method)
           Here we can see that the  class properties will be printed. 
           
do_print() method :

The UVM automation macros primarily involve a lot of additional code that affects simulator performance.Hence, it is not recommended to use. 
Instead, do_print() callback method is a user-defined hook which is called by print() or sprint() method. 
The user must call the printer’s API in the do_print() implementation to add information to be printed.
NOTE: This do_print method with printer.print_field_int inside is working with UVM1.2 , its throwing error with UVM1.1d.           
 */ 

typedef enum{RED, GREEN, BLUE} color_type;

class temp_class extends uvm_object;
  
  rand bit [7:0] tmp_addr;
  rand bit [7:0] tmp_data;
  
  function new(string name = "temp_class");
    super.new(name);
  endfunction
  
  `uvm_object_utils(temp_class)
  
  // Here do_print method used instead of field macros
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("tmp_addr", tmp_addr, $bits(tmp_addr), UVM_HEX);
    printer.print_field_int("tmp_data", tmp_data, $bits(tmp_data), UVM_HEX);
  endfunction
  
endclass : temp_class

class my_object extends uvm_object;
  
  rand int        value;
       string     names;
  rand color_type colors;
  rand byte       data[4];
  rand bit [7:0]  addr;
  rand temp_class tmp;
  
  `uvm_object_utils(my_object)
    
  function new(string name = "my_object");
    super.new(name);
    tmp = new();
   
  endfunction
  
  //Here do_print method used instead of field macros
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("value", value, $bits(value), UVM_HEX);
    printer.print_string("names", names);
    printer.print_string("colors", colors.name);
    foreach(data[i])
      printer.print_field_int($sformatf("data[%0d]", i), data[i], $bits(data[i]), UVM_HEX);
    printer.print_field_int("addr", addr, $bits(addr), UVM_HEX);
    printer.print_object("tmp", tmp);
  endfunction
  
endclass: my_object

class my_test extends uvm_test;
  
  `uvm_component_utils(my_test)
  
  my_object obj;

  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj = my_object::type_id::create("obj", this);
    assert(obj.randomize());
    obj.print();
  endfunction
  
endclass :my_test

module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule:tb_top

//Logfile output
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
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _426_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 6.504 seconds to compile + .227 seconds to elab + .445 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  9 02:48 2025
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
------------------------------------------
Name          Type        Size  Value     
------------------------------------------
obj           my_object   -     @349      
  value       integral    32    'h1f135537
  names       string      0     ""        
  colors      string      5     GREEN     
  data[0]     integral    8     'h9f      
  data[1]     integral    8     'h33      
  data[2]     integral    8     'h12      
  data[3]     integral    8     'h9c      
  addr        integral    8     'h2f      
  tmp         temp_class  -     @350      
    tmp_addr  integral    8     'h39      
    tmp_data  integral    8     'hbd      
------------------------------------------
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    2
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.270 seconds;       Data structure size:   0.2Mb
Mon Jun  9 02:48:36 2025
Done  
