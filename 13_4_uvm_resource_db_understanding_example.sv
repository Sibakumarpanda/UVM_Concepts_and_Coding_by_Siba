//Example for Resource DB Understanding
//Class component_A

class component_A #(parameter ID_WIDTH = 8) extends uvm_component;
 
  `uvm_component_param_utils(component_A #(ID_WIDTH))
  
   bit [ID_WIDTH-1:0] id;
  
  function new(string name = "component_A", uvm_component parent = null);
    super.new(name, parent);
    id = 1;
  endfunction
  
  function display();
    `uvm_info(get_type_name(), $sformatf("inside component_A: id = %0d", id), UVM_LOW);
  endfunction
  
endclass :component_A

//Class mycomponent

class mycomponent #(parameter ID_WIDTH = 8) extends uvm_component;
 
  `uvm_component_param_utils(mycomponent #(ID_WIDTH))
  
   bit [ID_WIDTH-1:0] id;
  
  function new(string name = "mycomponent", uvm_component parent = null);
    super.new(name, parent);
    id = 2;
  endfunction
  
  function display();
    `uvm_info(get_type_name(), $sformatf("inside mycomponent: id = %0d", id), UVM_LOW);
  endfunction
  
endclass :mycomponent

// Class component_B

class component_B #(int ID_WIDTH = 8) extends component_A #(ID_WIDTH);
 
  `uvm_component_param_utils(component_B #(ID_WIDTH))
  
   bit ctrl;
   bit [ID_WIDTH-1:0] id;
   mycomponent #(8) my_comp;
  
  function new(string name = "component_B", uvm_component parent = null);
    super.new(name, parent);
    id = 3;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_resource_db #(bit)::read_by_name(get_full_name(), "control", ctrl))
      `uvm_fatal(get_type_name(), "read_by_name failed for resource in this scope");
    
    if(ctrl)  
      my_comp = mycomponent #(8)::type_id::create("my_comp", this);
    
  endfunction
  
  function display();
    `uvm_info(get_type_name(), $sformatf("inside component_B: id = %0d, ctrl = %0d", id, ctrl), UVM_LOW);
    if(ctrl) 
      void'(my_comp.display());
  endfunction
  
endclass :component_B

//class my_test

class my_test extends uvm_test;
 
  `uvm_component_utils(my_test)
  
  component_A #(32) comp_A;
  component_B #(16) comp_B;
  
   bit control;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    comp_A = component_A #(32)::type_id::create("comp_A", this);
    comp_B = component_B #(16)::type_id::create("comp_B", this);
    
    uvm_resource_db #(bit)::set("*", "control", 1, this);
    
  endfunction
   
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    void'(comp_A.display());
    void'(comp_B.display());
  endtask
  
endclass :my_test

//tb_top module
module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule :tb_top

//Logfile output using Synopsys VCS
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
CPU time: 15.307 seconds to compile + .554 seconds to elab + 1.177 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun 26 01:06 2025
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
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
----------------------------------------
Name          Type           Size  Value
----------------------------------------
uvm_test_top  my_test        -     @336 
  comp_A      uvm_component  -     @349 
  comp_B      uvm_component  -     @358 
    my_comp   uvm_component  -     @371 
----------------------------------------

UVM_INFO testbench.sv(17) @ 0: uvm_test_top.comp_A [uvm_component] inside component_A: id = 1
UVM_INFO testbench.sv(68) @ 0: uvm_test_top.comp_B [uvm_component] inside component_B: id = 3, ctrl = 1
UVM_INFO testbench.sv(36) @ 0: uvm_test_top.comp_B.my_comp [uvm_component] inside mycomponent: id = 2
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    6
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1
[UVMTOP]     1
[uvm_component]     3

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.580 seconds;       Data structure size:   0.2Mb
Thu Jun 26 01:06:30 2025
Done
