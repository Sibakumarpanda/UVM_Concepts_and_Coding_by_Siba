UVM Queue Concept Understanding:
-The uvm_queue class builds a dynamic queue that to be allotted on-demand basis and passed by reference.
-uvm_queue class declaration:   class uvm_queue #( type T = int ) extends uvm_object

uvm_queue class Methods :

  Methods                                                           Description

    function new ( string name = “” )                               Creates a new queue for the given name  
    static function T get_global ( int index )                      Returns the specified item instance from the global item queue. 
    static function this_type get_global_queue ()                  Returns the singleton global queue for the item of type T.
    virtual function int size ()                                   Returns size of the queue i.e. stored number of items in the queue.  

    virtual function void insert ( int index, T item )             Inserts the item at the given index.  
    virtual function void delete ( int index = -1 )               Removes the item from the given index. 
                                                                If an index is not provided, complete queue content will be deleted 
      
    virtual function T get ( int index )                         Returns the item at the given index.

    virtual function void push_back( T item )                  Inserts the given item at the back of the queue.

    virtual function void push_front( T item )                 Inserts the given item at the front of the queue.

    virtual function T pop_back()                            Returns the last element in the queue or null if the queue is empty.

      virtual function T pop_front()                          Returns the first element in the queue or null if the queue is empty.  


 //A basic example code using uvm_queue concept 
// componentA class       
class componentA extends uvm_component;
  `uvm_component_utils(componentA)
  uvm_queue#(string) qA;
  
  function new(string name = "componentA", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    qA = uvm_queue#(string)::get_global_queue();
    
    qA.push_front("Rock");
    qA.push_back("Scissor");
    qA.insert(1, "Paper");
  endtask
endclass : componentA

//componentB Class      
class componentB extends uvm_component;
  `uvm_component_utils(componentB)
  uvm_queue#(string) qB;
  string s_name;
  
  function new(string name = "componentB", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    s_name = uvm_queue#(string)::get_global(1);
    `uvm_info(get_name(), $sformatf("get_global: item = %s", s_name), UVM_LOW);
    
    qB = uvm_queue#(string)::get_global_queue();

    s_name = qB.pop_front();
    `uvm_info(get_name(), $sformatf("pop_front = %s", s_name), UVM_LOW);
    
    `uvm_info(get_name(), $sformatf("Before delete: qB size = %0d", qB.size()), UVM_LOW);
    qB.delete(1);
    `uvm_info(get_name(), $sformatf("After delete: qB size = %0d", qB.size()), UVM_LOW);
    
    s_name = qB.pop_back();
    `uvm_info(get_name(), $sformatf("pop_back = %s", s_name), UVM_LOW);
  endtask
endclass :componentB
      
//base_test class
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  componentA comp_a;
  componentB comp_b;

  function new(string name = "base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    comp_a = componentA::type_id::create("comp_a", this);
    comp_b = componentB::type_id::create("comp_b", this);
  endfunction : build_phase
  
  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction
endclass :base_test
/////////////////////////////////////////////////////////
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "componentA.sv"   
`include "componentB.sv" 
`include "base_test.sv"
      
//tb_top module
module tb_top;
  initial begin
    run_test("base_test");
  end
endmodule :tb_top      

//LogFile output using Synopsys VCS Tool
Starting vcs inline pass...

4 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling module event_pool_example
All of 4 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _426_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 15.262 seconds to compile + .484 seconds to elab + .987 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Aug  1 04:14 2025
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
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
-------------------------------------
Name          Type        Size  Value
-------------------------------------
uvm_test_top  base_test   -     @336 
  comp_a      componentA  -     @349 
  comp_b      componentB  -     @358 
-------------------------------------

UVM_INFO components.sv(31) @ 0: uvm_test_top.comp_b [comp_b] get_global: item = Paper
UVM_INFO components.sv(36) @ 0: uvm_test_top.comp_b [comp_b] pop_front = Rock
UVM_INFO components.sv(38) @ 0: uvm_test_top.comp_b [comp_b] Before delete: qB size = 2
UVM_INFO components.sv(40) @ 0: uvm_test_top.comp_b [comp_b] After delete: qB size = 1
UVM_INFO components.sv(43) @ 0: uvm_test_top.comp_b [comp_b] pop_back = Paper
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    8
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1
[UVMTOP]     1
[comp_b]     5

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.500 seconds;       Data structure size:   0.2Mb
Fri Aug  1 04:14:23 2025
Done      
