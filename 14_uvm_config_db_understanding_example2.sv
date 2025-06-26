//Example for Config DB Precedence Rule

/*
NOTE: There are two precedence rules applicable to uvm_config_db. In the build_phase: They are

1. A set() call in a context higher up the component hierarchy takes precedence over a set() call that occurs lower in the hierarchical path.
2. On having same context field, the last set() call takes precedence over the earlier set() call.

*/

//Example2: Example for :  A set() call in a context higher up the component hierarchy takes precedence over a set() call that occurs lower in the hierarchical path.

//Class component_A

class component_A extends uvm_component;
  
  `uvm_component_utils(component_A)
  
  int id;
  
  function new(string name = "component_A", uvm_component parent = null);
    super.new(name, parent);
    id = 1;
  endfunction
  
  function display();
    `uvm_info(get_type_name(), $sformatf("inside component_A: id = %0d", id), UVM_LOW);
  endfunction
  
endclass :component_A

//Class component_B

class component_B extends component_A;
  
  `uvm_component_utils(component_B)
  
  int receive_value;
  int id;
  
  
  function new(string name = "component_B", uvm_component parent = null);
    super.new(name, parent);
    id = 2;
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    if(!uvm_config_db #(int)::get(this, "*", "value", receive_value))
      `uvm_fatal(get_type_name(), "get failed for resource in this scope");    
    
  endfunction
  
  function display();
    `uvm_info(get_type_name(), $sformatf("inside component_B: id = %0d, receive_value = %0d", id, receive_value), UVM_LOW);
  endfunction
  
endclass :component_B


//class env
class env extends uvm_env;
  
  `uvm_component_utils(env)
  
  component_A comp_A;
  component_B comp_B;
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    comp_A = component_A ::type_id::create("comp_A", this);
    comp_B = component_B ::type_id::create("comp_B", this);
    
    uvm_config_db #(int)::set(this, "*", "value", 200);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    void'(comp_A.display());
    void'(comp_B.display());
  endtask
  
endclass :env

//class my_test
class my_test extends uvm_test;
  
  `uvm_component_utils(my_test)
  
  bit control;
  env env_o;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
    
    uvm_config_db #(int)::set(null, "*", "value", 100);
  endfunction
   
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass :my_test

//module tb_top

module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule :tb_top

//Logfile output using Synopsys VCS Tool
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
CPU time: 9.181 seconds to compile + .326 seconds to elab + .695 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun 26 04:42 2025
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
--------------------------------------
Name          Type         Size  Value
--------------------------------------
uvm_test_top  my_test      -     @336 
  env_o       env          -     @349 
    comp_A    component_A  -     @362 
    comp_B    component_B  -     @371 
--------------------------------------

UVM_INFO testbench.sv(27) @ 0: uvm_test_top.env_o.comp_A [component_A] inside component_A: id = 1
UVM_INFO testbench.sv(56) @ 0: uvm_test_top.env_o.comp_B [component_B] inside component_B: id = 2, receive_value = 100
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
[UVMTOP]     1
[component_A]     1
[component_B]     1

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.370 seconds;       Data structure size:   0.2Mb
Thu Jun 26 04:42:45 2025
Done
