/*
EXAMPLE-2a : An objection in the Sequence Class
The objection can be raised and dropped either in body tasks or pre_body/ post_body tasks.
a. With use of starting_phase.raise_objection(this); and starting_phase.drop_objection(this);  
NOTE: The above method is not recommended to use with uvm1.2 as the starting_phase() method from uvm_sequence_base is deprecated in uvm1.2 

*/

//Transaction class or Sequence item class
class my_seq_item extends uvm_sequence_item;
  `uvm_object_utils(my_seq_item)
  
  rand bit[15:0] addr;
  rand bit[15:0] data;
   
  function new(string name = "my_seq_item");
    super.new(name);
  endfunction
  
endclass :my_seq_item

//Base sequence class
class base_seq extends uvm_sequence #(my_seq_item);
  `uvm_object_utils(base_seq)
  
  my_seq_item   req;
  
  function new (string name = "base_seq");
    super.new(name);
  endfunction

  task pre_body();
    `uvm_info(get_type_name(), "Inside pre_body", UVM_LOW);
    if (starting_phase != null) 
      starting_phase.raise_objection(this); 
  endtask
  
  task body();
    `uvm_info(get_type_name(), "Base seq: Body started", UVM_LOW);
    req = my_seq_item::type_id::create("req");
    // send to the driver
    #20;
    `uvm_info(get_type_name(), "Base seq: Body completed", UVM_LOW);
  endtask
  
  task post_body();
    `uvm_info(get_type_name(), "Inside post_body", UVM_LOW);
    if (starting_phase != null) 
      starting_phase.drop_objection(this); 
  endtask
  
endclass: base_seq

//Base Test Class
class base_test extends uvm_test;
  `uvm_component_utils(base_test)  
  base_seq bseq;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
 
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    bseq = base_seq::type_id::create("bseq");
    bseq.starting_phase = phase; // Assign phase directly
    bseq.start(null);
  endtask
  
endclass :base_test

//TB TOP Module
module tb_top;
  initial begin
    run_test("base_test");
  end
endmodule :tb_top
// Log File Output
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
CPU time: 14.866 seconds to compile + .492 seconds to elab + .960 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  7 12:47 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
UVM_INFO testbench.sv(34) @ 0: reporter@@bseq [base_seq] Inside pre_body
UVM_INFO testbench.sv(40) @ 0: reporter@@bseq [base_seq] Base seq: Body started
UVM_INFO testbench.sv(44) @ 20: reporter@@bseq [base_seq] Base seq: Body completed
UVM_INFO testbench.sv(48) @ 20: reporter@@bseq [base_seq] Inside post_body
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 20: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 20: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    7
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST_DONE]     1
[UVM/RELNOTES]     1
[base_seq]     4

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                   20
           V C S   S i m u l a t i o n   R e p o r t 
Time: 20 ns
CPU Time:      0.450 seconds;       Data structure size:   0.2Mb
Sat Jun  7 12:47:47 2025
Done
