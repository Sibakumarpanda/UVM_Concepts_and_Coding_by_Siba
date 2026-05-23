/*
EXAMPLE-7: set_inst_override_by_name (factory override with uvm objects)
Arguments :  Uses strings for type names and instance path
Syntax for set_inst_override_by_name: 
factory.set_inst_override_by_name(
  "original_type_name",      // Original type as string
  "override_type_name",      // New type as string
  "full_or_relative_path",   // Instance path
  [parent_component]         // Optional context (for relative paths)
); 

*/

// Base class- animal

class animal extends uvm_object;
  `uvm_object_utils(animal)
  
  function new(string name = "animal");
    super.new(name);
  endfunction
  
  virtual function string sound();
    return "some sound";
  endfunction
  
endclass :animal

// Derived class1- dog
class dog extends animal;
  `uvm_object_utils(dog)
  
  function new(string name = "dog");
    super.new(name);
  endfunction
  
  function string sound();
    return "bark";
  endfunction
  
endclass :dog

// Derived class2- cat
class cat extends animal;
  `uvm_object_utils(cat)
  
  function new(string name = "cat");
    super.new(name);
  endfunction
  
  function string sound();
    return "meow";
  endfunction
  
endclass :cat

// Container class
class zoo extends uvm_component;
  `uvm_component_utils(zoo)
  
  animal anim1, anim2;
  cat    cat1, cat2;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create animals through factory
    anim1 = animal::type_id::create("anim1", this);
    anim2 = animal::type_id::create("anim2", this);
    cat1  = cat::type_id::create("cat1", this);
    cat2  = cat::type_id::create("cat2", this);
  endfunction
  
  function void report_phase(uvm_phase phase);
    
    factory.print();
    
    `uvm_info("ZOO", $sformatf("anim1 sound: %s", anim1.sound()), UVM_LOW)
    `uvm_info("ZOO", $sformatf("anim2 sound: %s", anim2.sound()), UVM_LOW)
    `uvm_info("ZOO", $sformatf("cat1 sound: %s", cat1.sound()), UVM_LOW)
    `uvm_info("ZOO", $sformatf("cat2 sound: %s", cat2.sound()), UVM_LOW)
  endfunction
  
endclass :zoo

// Test class demonstrating instance overrides
class my_instance_override_test extends uvm_test;
  `uvm_component_utils(my_instance_override_test)
  
  zoo my_zoo;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
       
    // Method 2: set_inst_override_by_name
    // Override only animal instance in zoo to be a dog
    
    /*  factory.set_inst_override_by_name( "animal",                      // Original type name
                                           "dog",                      // Override type name
                                           {get_name(), ".my_zoo.anim1"} // Full hierarchical path
                                          ); 
    
    */
    
    // Override only animal instance in zoo to be a cat
     factory.set_inst_override_by_name("animal",                      // Original type name
                                       "cat",                         // Override type name
                                       {get_name(), ".my_zoo.anim1"} // Full hierarchical path
                                       );
    
     my_zoo = zoo::type_id::create("my_zoo", this);
    
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass :my_instance_override_test

module tb_top;
  initial begin
    run_test("my_instance_override_test");
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
CPU time: 10.976 seconds to compile + .390 seconds to elab + .777 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  5 02:25 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_instance_override_test...
UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
----------------------------------------------------
Name          Type                       Size  Value
----------------------------------------------------
uvm_test_top  my_instance_override_test  -     @456 
  my_zoo      zoo                        -     @464 
----------------------------------------------------


#### Factory Configuration (*)

Instance Overrides:

  Requested Type  Override Path              Override Type
  --------------  -------------------------  -------------
  animal          uvm_test_top.my_zoo.anim1  cat

No type overrides are registered with this factory

All types registered with the factory: 43 total
(types without type names will not be printed)

  Type Name
  ---------
  animal
  cat
  dog
  my_instance_override_test
  snps_uvm_reg_bank_group
  snps_uvm_reg_map
  zoo
(*) Types with no associated type name will be printed as <unknown>

####

UVM_INFO testbench.sv(91) @ 0: uvm_test_top.my_zoo [ZOO] anim1 sound: meow
UVM_INFO testbench.sv(92) @ 0: uvm_test_top.my_zoo [ZOO] anim2 sound: some sound
UVM_INFO testbench.sv(93) @ 0: uvm_test_top.my_zoo [ZOO] cat1 sound: meow
UVM_INFO testbench.sv(94) @ 0: uvm_test_top.my_zoo [ZOO] cat2 sound: meow

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    6
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVMTOP]     1
[ZOO]     4
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.400 seconds;       Data structure size:   0.2Mb
Thu Jun  5 02:25:20 2025
Done

/*
EXAMPLE-8: set_inst_override_by_name (factory override with uvm component)
Arguments :  Uses strings for type names and instance path
Syntax for set_inst_override_by_name 
factory.set_inst_override_by_name(
  "original_type_name",      // Original type as string
  "override_type_name",      // New type as string
  "full_or_relative_path",   // Instance path
  [parent_component]         // Optional context (for relative paths)
); 

*/

// Base class- animal
class animal extends uvm_component;
  `uvm_component_utils(animal)
  
  function new(string name = "animal",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  virtual function string sound();
    return "some sound";
  endfunction
  
endclass :animal

// Derived class1- dog
class dog extends animal;
  `uvm_component_utils(dog)
  
  function new(string name = "dog",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function string sound();
    return "bark";
  endfunction
  
endclass :dog

// Derived class2- cat
class cat extends animal;
  `uvm_component_utils(cat)
  
  function new(string name = "cat",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function string sound();
    return "meow";
  endfunction
  
endclass :cat

// Container class
class zoo extends uvm_component;
  `uvm_component_utils(zoo)
  
  animal anim1, anim2;
  cat    cat1, cat2;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create animals through factory
    anim1 = animal::type_id::create("anim1", this);
    anim2 = animal::type_id::create("anim2", this);
    cat1  = cat::type_id::create("cat1", this);
    cat2  = cat::type_id::create("cat2", this);
  endfunction
  
  function void report_phase(uvm_phase phase);
    
    factory.print();
    `uvm_info("ZOO", $sformatf("anim1 sound: %s", anim1.sound()), UVM_LOW)
    `uvm_info("ZOO", $sformatf("anim2 sound: %s", anim2.sound()), UVM_LOW)
    `uvm_info("ZOO", $sformatf("cat1 sound: %s", cat1.sound()), UVM_LOW)
    `uvm_info("ZOO", $sformatf("cat2 sound: %s", cat2.sound()), UVM_LOW)
  endfunction
  
endclass :zoo

// Test class demonstrating instance overrides
class my_instance_override_test extends uvm_test;
  `uvm_component_utils(my_instance_override_test)
  
  zoo my_zoo;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
   
    // Method 2: set_inst_override_by_name
    // Override only animal instance in zoo to be a dog
    
    /*  factory.set_inst_override_by_name( "animal",                      // Original type name
                                           "dog",                      // Override type name
                                           {get_name(), ".my_zoo.anim1"} // Full hierarchical path
                                          ); 
    
    */
    
    // Override only animal instance in zoo to be a cat
     factory.set_inst_override_by_name("animal",                      // Original type name
                                       "cat",                         // Override type name
                                       {get_name(), ".my_zoo.anim1"} // Full hierarchical path
                                       );
    
     my_zoo = zoo::type_id::create("my_zoo", this);
    
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass :my_instance_override_test

module tb_top;
  initial begin
    run_test("my_instance_override_test");
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
CPU time: 11.067 seconds to compile + .386 seconds to elab + .740 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  5 02:26 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_instance_override_test...
UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
----------------------------------------------------
Name          Type                       Size  Value
----------------------------------------------------
uvm_test_top  my_instance_override_test  -     @456 
  my_zoo      zoo                        -     @464 
    anim1     cat                        -     @472 
    anim2     animal                     -     @480 
    cat1      cat                        -     @488 
    cat2      cat                        -     @496 
----------------------------------------------------


#### Factory Configuration (*)

Instance Overrides:

  Requested Type  Override Path              Override Type
  --------------  -------------------------  -------------
  animal          uvm_test_top.my_zoo.anim1  cat

No type overrides are registered with this factory

All types registered with the factory: 43 total
(types without type names will not be printed)

  Type Name
  ---------
  animal
  cat
  dog
  my_instance_override_test
  snps_uvm_reg_bank_group
  snps_uvm_reg_map
  zoo
(*) Types with no associated type name will be printed as <unknown>

####

UVM_INFO testbench.sv(90) @ 0: uvm_test_top.my_zoo [ZOO] anim1 sound: meow
UVM_INFO testbench.sv(91) @ 0: uvm_test_top.my_zoo [ZOO] anim2 sound: some sound
UVM_INFO testbench.sv(92) @ 0: uvm_test_top.my_zoo [ZOO] cat1 sound: meow
UVM_INFO testbench.sv(93) @ 0: uvm_test_top.my_zoo [ZOO] cat2 sound: meow

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    6
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVMTOP]     1
[ZOO]     4
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.390 seconds;       Data structure size:   0.2Mb
Thu Jun  5 02:26:11 2025
Done  
