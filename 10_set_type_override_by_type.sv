/*
EXAMPLE-1: set_type_override_by_type (factory override with uvm objects)
Arguments	Uses actual types (::type)
set_type_override_by_type , Synatx :  function void set_type_override_by_type (uvm_object_wrapper original_type,
                                                                               uvm_object_wrapper override_type,
                                                                                bit replace = 1)
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

// Test class demonstrating Both types of overrides that is set_type_override_by_type and set_type_override_by_name

class my_factory_override_test extends uvm_test;
  `uvm_component_utils(my_factory_override_test)
  
  animal anim1;
  dog    dog1;
  cat    cat1;
  
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Method 1: set_type_override_by_type - type-safe approach
    // Replace all animal instances with dog/ cat by type override
    
    factory.set_type_override_by_type(animal::get_type(), dog::get_type()); //(original_type, override_type)
    //factory.set_type_override_by_type(animal::get_type(), cat::get_type());
    
    
    // Create objects through factory
    anim1 = animal::type_id::create("anim1");
    dog1  = dog::type_id::create("dog1"); 
    cat1  = cat::type_id::create("cat1"); 
    
    // Display results
    `uvm_info("TEST", $sformatf("------ORIGINALLY---------"), UVM_LOW)
    `uvm_info("TEST", $sformatf("dog1 sound: %s (original: dog)", dog1.sound()), UVM_LOW)
    `uvm_info("TEST", $sformatf("cat1 sound: %s (original: cat)", cat1.sound()), UVM_LOW)
    `uvm_info("TEST", $sformatf("------After set_type_override_by_type ---------"), UVM_LOW)
    `uvm_info("TEST", $sformatf("anim1 sound: %s (original: animal)", anim1.sound()), UVM_LOW)
    //`uvm_info("TEST", $sformatf("cat1 sound: %s (original: cat)", cat1.sound()), UVM_LOW)
  endfunction
  
endclass :my_factory_override_test

module tb_top;
  initial begin
    run_test("my_factory_override_test");
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
CPU time: 11.561 seconds to compile + .404 seconds to elab + .815 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  4 09:58 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_factory_override_test...
UVM_INFO testbench.sv(87) @ 0: uvm_test_top [TEST] ------ORIGINALLY---------
UVM_INFO testbench.sv(88) @ 0: uvm_test_top [TEST] dog1 sound: bark (original: dog)
UVM_INFO testbench.sv(89) @ 0: uvm_test_top [TEST] cat1 sound: meow (original: cat)
UVM_INFO testbench.sv(90) @ 0: uvm_test_top [TEST] ------After set_type_override_by_type ---------
UVM_INFO testbench.sv(91) @ 0: uvm_test_top [TEST] anim1 sound: bark (original: animal)

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    6
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST]     5
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.480 seconds;       Data structure size:   0.2Mb
Wed Jun  4 09:58:02 2025
Done

/*
EXAMPLE-2: set_type_override_by_type (factory override with uvm components)
Arguments	Uses actual types (::type)

set_type_override_by_type , Synatx :  function void set_type_override_by_type (uvm_object_wrapper original_type,
                                                                               uvm_object_wrapper override_type,
                                                                                bit replace = 1)
*/

// Base class- animal
class animal extends uvm_component;
  `uvm_component_utils(animal)
  
  function new(string name = "animal", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  virtual function string sound();
    return "some sound";
  endfunction
  
endclass :animal

// Derived class1- dog
class dog extends animal;
  `uvm_component_utils(dog)
  
  function new(string name = "dog", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function string sound();
    return "bark";
  endfunction
  
endclass :dog

// Derived class2- cat
class cat extends animal;
  `uvm_component_utils(cat)
  
  function new(string name = "cat", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function string sound();
    return "meow";
  endfunction
  
endclass :cat

// Test class demonstrating Both types of overrides that is set_type_override_by_type and set_type_override_by_name
class my_factory_override_test extends uvm_test;
  `uvm_component_utils(my_factory_override_test)
  
  animal anim1;
  dog    dog1;
  cat    cat1;
    
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Method 1: set_type_override_by_type - type-safe approach
    // Replace all animal instances with dog/ cat by type override
    
    factory.set_type_override_by_type(animal::get_type(), dog::get_type()); //(original_type, override_type)
    //factory.set_type_override_by_type(animal::get_type(), cat::get_type());
    
    
    // Create objects through factory
    anim1 = animal::type_id::create("anim1",this);
    dog1  = dog::type_id::create("dog1",this); 
    cat1  = cat::type_id::create("cat1",this); 
    
    // Display results
    `uvm_info("TEST", $sformatf("------ORIGINALLY---------"), UVM_LOW)
    `uvm_info("TEST", $sformatf("dog1 sound: %s (original: dog)", dog1.sound()), UVM_LOW)
    `uvm_info("TEST", $sformatf("cat1 sound: %s (original: cat)", cat1.sound()), UVM_LOW)
    `uvm_info("TEST", $sformatf("------After set_type_override_by_type ---------"), UVM_LOW)
    `uvm_info("TEST", $sformatf("anim1 sound: %s (original: animal)", anim1.sound()), UVM_LOW)
    //`uvm_info("TEST", $sformatf("cat1 sound: %s (original: cat)", cat1.sound()), UVM_LOW)
  endfunction
  
endclass :my_factory_override_test

module tb_top;
  initial begin
    run_test("my_factory_override_test");
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
CPU time: 10.939 seconds to compile + .416 seconds to elab + .792 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  4 09:59 2025
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

UVM_INFO @ 0: reporter [RNTST] Running test my_factory_override_test...
UVM_INFO testbench.sv(87) @ 0: uvm_test_top [TEST] ------ORIGINALLY---------
UVM_INFO testbench.sv(88) @ 0: uvm_test_top [TEST] dog1 sound: bark (original: dog)
UVM_INFO testbench.sv(89) @ 0: uvm_test_top [TEST] cat1 sound: meow (original: cat)
UVM_INFO testbench.sv(90) @ 0: uvm_test_top [TEST] ------After set_type_override_by_type ---------
UVM_INFO testbench.sv(91) @ 0: uvm_test_top [TEST] anim1 sound: bark (original: animal)

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    6
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[TEST]     5
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.410 seconds;       Data structure size:   0.2Mb
Wed Jun  4 09:59:48 2025
Done  
  
