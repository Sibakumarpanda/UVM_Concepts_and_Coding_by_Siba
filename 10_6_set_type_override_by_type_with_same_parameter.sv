/* Example9: for set_type_override_by_type with parameterized classes (same parameter)
Note: For parameterized classes, an overriding class should have the same parameter values. 
      If an overriding class has different parameter values, factory overriding will fail.

Arguments	Uses actual types (::type)

set_type_override_by_type , Synatx :  function void set_type_override_by_type (uvm_object_wrapper original_type,
                                                                               uvm_object_wrapper override_type,
                                                                                bit replace = 1)
*/

// Base class- animal
class animal #(parameter ID_WIDTH = 8) extends uvm_component;
  
   `uvm_component_param_utils(animal #(ID_WIDTH))
   bit [ID_WIDTH-1:0] id;
  
  function new(string name = "animal", uvm_component parent = null);
    super.new(name,parent);
    id = 1;
  endfunction
  
  virtual function string sound();
    return "some sound";
  endfunction
  
  virtual function display();
    `uvm_info(get_type_name(), $sformatf("Inside ANIMAL base class : ID_WIDTH = %0d, id = %0d", ID_WIDTH, id), UVM_LOW);
  endfunction
  
endclass :animal

// Derived class1- dog
class dog #(int ID_WIDTH = 8) extends animal #(ID_WIDTH);
  bit [ID_WIDTH-1:0] id;
  `uvm_component_param_utils(dog #(ID_WIDTH))
  
  function new(string name = "dog", uvm_component parent = null);
    super.new(name,parent);
     id = 2;
  endfunction
  
  function string sound();
    return "bark";
  endfunction
  
  function display();
    `uvm_info(get_type_name(), $sformatf("Inside DOG derived class1 : ID_WIDTH = %0d, id = %0d", ID_WIDTH, id), UVM_LOW);
  endfunction
  
endclass :dog

// Derived class2- cat
class cat #(int ID_WIDTH = 8) extends animal #(ID_WIDTH);
   bit [ID_WIDTH-1:0] id;
  `uvm_component_param_utils(cat #(ID_WIDTH))
  
  function new(string name = "cat", uvm_component parent = null);
    super.new(name,parent);
    id = 3;
  endfunction
  
  function string sound();
    return "meow";
  endfunction
  
  function display();
    `uvm_info(get_type_name(), $sformatf("Inside CAT derived class2 : ID_WIDTH = %0d, id = %0d", ID_WIDTH, id), UVM_LOW);
  endfunction
  
endclass :cat

// Test class demonstrating Both types of overrides that is set_type_override_by_type and set_type_override_by_name
class my_factory_param_override_test extends uvm_test;
  `uvm_component_utils(my_factory_param_override_test)
  
  animal#(32)    anim1;
  dog #(32)       dog1;
  cat #(32)      cat1;
     
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Method 1: set_type_override_by_type - type-safe approach
    // Replace all animal instances with dog/ cat by type override
    
    //factory.set_type_override_by_type(animal #(32)::get_type(), dog #(32)::get_type()); //(original_type, override_type)
    factory.set_type_override_by_type(animal #(32)::get_type(), cat#(32)::get_type());
    
    
    // Create objects through factory
    anim1 = animal#(32)::type_id::create("anim1",this);
    dog1  = dog#(32)::type_id::create("dog1",this); 
    cat1  = cat#(32)::type_id::create("cat1",this); 
    
    factory.print();
    
    // Display results
    `uvm_info("TEST", $sformatf("------ORIGINALLY---------"), UVM_LOW)
    `uvm_info("TEST", $sformatf("dog1 sound: %s (original: dog)", dog1.sound()), UVM_LOW)
    `uvm_info("TEST", $sformatf("cat1 sound: %s (original: cat)", cat1.sound()), UVM_LOW)
    `uvm_info("TEST", $sformatf("------After set_type_override_by_type ---------"), UVM_LOW)
    `uvm_info("TEST", $sformatf("anim1 sound: %s (original: animal)", anim1.sound()), UVM_LOW)
    //`uvm_info("TEST", $sformatf("cat1 sound: %s (original: cat)", cat1.sound()), UVM_LOW)
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    anim1.display();
  endtask  
endclass :my_factory_param_override_test

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
CPU time: 11.629 seconds to compile + .422 seconds to elab + .805 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  5 01:47 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_factory_param_override_test...

#### Factory Configuration (*)

No instance overrides are registered with this factory

Type Overrides:

  Requested Type  Override Type
  --------------  -------------
  <unknown>       <unknown>

All types registered with the factory: 42 total
(types without type names will not be printed)

  Type Name
  ---------
  my_factory_param_override_test
  snps_uvm_reg_bank_group
  snps_uvm_reg_map
(*) Types with no associated type name will be printed as <unknown>

####

UVM_INFO testbench.sv(109) @ 0: uvm_test_top [TEST] ------ORIGINALLY---------
UVM_INFO testbench.sv(110) @ 0: uvm_test_top [TEST] dog1 sound: bark (original: dog)
UVM_INFO testbench.sv(111) @ 0: uvm_test_top [TEST] cat1 sound: meow (original: cat)
UVM_INFO testbench.sv(112) @ 0: uvm_test_top [TEST] ------After set_type_override_by_type ---------
UVM_INFO testbench.sv(113) @ 0: uvm_test_top [TEST] anim1 sound: meow (original: animal)
UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
---------------------------------------------------------
Name          Type                            Size  Value
---------------------------------------------------------
uvm_test_top  my_factory_param_override_test  -     @456 
  anim1       uvm_component                   -     @464 
  cat1        uvm_component                   -     @480 
  dog1        uvm_component                   -     @472 
---------------------------------------------------------

UVM_INFO testbench.sv(72) @ 0: uvm_test_top.anim1 [uvm_component] Inside CAT derived class2 : ID_WIDTH = 32, id = 3

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    8
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST]     5
[UVMTOP]     1
[uvm_component]     1
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.520 seconds;       Data structure size:   0.2Mb
Thu Jun  5 01:47:32 2025
Done

module tb_top;
  initial begin
    run_test("my_factory_param_override_test");
  end
endmodule :tb_top
