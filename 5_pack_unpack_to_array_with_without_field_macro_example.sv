/*
pack and unpack method in UVM : 
Example10: pack and unpack method method with `uvm_object_utils and with Field macros : 
The pack method is used to do bitwise concatenation of the class properties into an array of type bit/ byte/ int.
The unpack method is used to extract values from an array of type bit/ byte/ int and store it into a class format.
Note: It is mandatory to keep the same order for both pack and unpack methods otherwise the result would be different.
pack: Do bitwise concatenation of the class properties into an array of type bit

unpack: Extract values from an array of type bit and store it into a class format.

pack_bytes: Do bitwise concatenation of the class properties into an array of type byte

unpack_bytes: Extract values from an array of type byte and store it into a class format.

pack_ints: Do bitwise concatenation of the class properties into an array of type int

unpack_ints: Extract values from an array of type int and store it into a class format.

This example will include all below types with using field macro:
pack_unpack_to_array_of_bit_type
pack_unpack_to_array_of_byte_type
pack_unpack_to_array_of_int_type
          
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
  rand color_type colors;
  rand byte       data[4];
  rand bit [7:0]  addr;
  rand temp_class tmp;
  
  `uvm_object_utils_begin(my_object)
    `uvm_field_int(value, UVM_ALL_ON)
    `uvm_field_enum(color_type, colors, UVM_ALL_ON)
    `uvm_field_sarray_int(data, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_object(tmp, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "my_object");
    super.new(name);
    tmp = new();
  endfunction
  
endclass :my_object

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  my_object obj;
  bit packed_data_bits[];
  byte unsigned packed_data_bytes[];
  int unsigned packed_data_ints[];
  
  my_object unpack_obj;
  
  int pack_values[3];
  int unpack_values[3];
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj = my_object::type_id::create("obj", this);
    assert(obj.randomize());
    `uvm_info(get_full_name(), $sformatf("obj = \n%s", obj.sprint()), UVM_LOW);
    
    // pack methods
    pack_values[0] = obj.pack(packed_data_bits);
    pack_values[1] = obj.pack_bytes(packed_data_bytes);
    pack_values[2] = obj.pack_ints(packed_data_ints);
    `uvm_info(get_full_name(), $sformatf("packed_data_bits = %p", packed_data_bits), UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("packed_data_bytes = %p", packed_data_bytes), UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("packed_data_ints = %p", packed_data_ints), UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("pack_values[BITS] = %0d, pack_values[BYTES] = %0d, pack_values[INTS] = %0d", pack_values[0], pack_values[1], pack_values[2]), UVM_LOW);
    
    // unpack methods
    unpack_obj = my_object::type_id::create("unpack_obj", this);
    unpack_values[0] = unpack_obj.unpack(packed_data_bits);
    `uvm_info(get_full_name(), $sformatf("bits: unpack_obj = \n%s", unpack_obj.sprint()), UVM_LOW);
    unpack_values[1] = unpack_obj.unpack_bytes(packed_data_bytes);
    `uvm_info(get_full_name(), $sformatf("bytes: unpack_obj = \n%s", unpack_obj.sprint()), UVM_LOW);
    unpack_values[2] = unpack_obj.unpack_ints(packed_data_ints);
    `uvm_info(get_full_name(), $sformatf("ints: unpack_obj = \n%s", unpack_obj.sprint()), UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("unpack_values[BITS] = %0d, unpack_values[BYTES] = %0d, unpack_values[INTS] = %0d", unpack_values[0], unpack_values[1], unpack_values[2]), UVM_LOW);
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
CPU time: 13.905 seconds to compile + .499 seconds to elab + .885 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun 10 06:16 2025
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
UVM_INFO testbench.sv(94) @ 0: uvm_test_top [uvm_test_top] obj = 
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
obj           my_object     -     @464      
  value       integral      32    'h1f135537
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

UVM_INFO testbench.sv(100) @ 0: uvm_test_top [uvm_test_top] packed_data_bits = '{'h0, 'h0, 'h0, 'h1, 'h1, 'h1, 'h1, 'h1, 'h0, 'h0, 'h0, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h1, 'h0, 'h1, 'h0, 'h1, 'h0, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h1, 'h1, 'h1, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h1, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h0, 'h0, 'h1, 'h0, 'h0, 'h1, 'h0, 'h1, 'h0, 'h0, 'h1, 'h1, 'h1, 'h0, 'h0, 'h0, 'h0, 'h1, 'h0, 'h1, 'h1, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h1, 'h1, 'h1, 'h1, 'h0, 'h1} 
UVM_INFO testbench.sv(101) @ 0: uvm_test_top [uvm_test_top] packed_data_bytes = '{'h1f, 'h13, 'h55, 'h37, 'h0, 'h0, 'h0, 'h1, 'h9f, 'h33, 'h12, 'h9c, 'h2f, 'h39, 'hbd} 
UVM_INFO testbench.sv(102) @ 0: uvm_test_top [uvm_test_top] packed_data_ints = '{'h1f135537, 'h1, 'h9f33129c, 'h2f39bd00} 
UVM_INFO testbench.sv(103) @ 0: uvm_test_top [uvm_test_top] pack_values[BITS] = 120, pack_values[BYTES] = 120, pack_values[INTS] = 120
UVM_INFO testbench.sv(108) @ 0: uvm_test_top [uvm_test_top] bits: unpack_obj = 
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
unpack_obj    my_object     -     @466      
  value       integral      32    'h1f135537
  colors      color_type    32    GREEN     
  data        sa(integral)  4     -         
    [0]       integral      8     'h9f      
    [1]       integral      8     'h33      
    [2]       integral      8     'h12      
    [3]       integral      8     'h9c      
  addr        integral      8     'h2f      
  tmp         temp_class    -     @467      
    tmp_addr  integral      8     'h39      
    tmp_data  integral      8     'hbd      
--------------------------------------------

UVM_INFO testbench.sv(110) @ 0: uvm_test_top [uvm_test_top] bytes: unpack_obj = 
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
unpack_obj    my_object     -     @466      
  value       integral      32    'h1f135537
  colors      color_type    32    GREEN     
  data        sa(integral)  4     -         
    [0]       integral      8     'h9f      
    [1]       integral      8     'h33      
    [2]       integral      8     'h12      
    [3]       integral      8     'h9c      
  addr        integral      8     'h2f      
  tmp         temp_class    -     @467      
    tmp_addr  integral      8     'h39      
    tmp_data  integral      8     'hbd      
--------------------------------------------

UVM_INFO testbench.sv(112) @ 0: uvm_test_top [uvm_test_top] ints: unpack_obj = 
--------------------------------------------
Name          Type          Size  Value     
--------------------------------------------
unpack_obj    my_object     -     @466      
  value       integral      32    'h1f135537
  colors      color_type    32    GREEN     
  data        sa(integral)  4     -         
    [0]       integral      8     'h9f      
    [1]       integral      8     'h33      
    [2]       integral      8     'h12      
    [3]       integral      8     'h9c      
  addr        integral      8     'h2f      
  tmp         temp_class    -     @467      
    tmp_addr  integral      8     'h39      
    tmp_data  integral      8     'hbd      
--------------------------------------------

UVM_INFO testbench.sv(113) @ 0: uvm_test_top [uvm_test_top] unpack_values[BITS] = 120, unpack_values[BYTES] = 120, unpack_values[INTS] = 120

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   10
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[uvm_test_top]     9
$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/base/uvm_root.svh", line 437.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.530 seconds;       Data structure size:   0.2Mb
Tue Jun 10 06:16:26 2025
Done

/*
pack and unpack method in UVM : 
Example10: pack and unpack method method with `uvm_object_utils and with Field macros (with do_pack and do_unpack method)
The do_pack/ do_unpack callback methods are user-defined hooks which are called by pack/ unpack() method. 
The derived class should override The `uvm_object_utils_begin..end and `uvm_field_* macros are not used.
The pack method is used to do bitwise concatenation of the class properties into an array of type bit/ byte/ int.
The unpack method is used to extract values from an array of type bit/ byte/ int and store it into a class format.

Note: It is mandatory to keep the same order for both pack and unpack methods otherwise the result would be different. 
This example should run using UVM 1.2 . while running using UVM1.1d it throws error.
pack: Do bitwise concatenation of the class properties into an array of type bit

unpack: Extract values from an array of type bit and store it into a class format.

pack_bytes: Do bitwise concatenation of the class properties into an array of type byte

unpack_bytes: Extract values from an array of type byte and store it into a class format.

pack_ints: Do bitwise concatenation of the class properties into an array of type int

unpack_ints: Extract values from an array of type int and store it into a class format.

This example will include all below types with out using field macro (using with do_pack and do_unpack method):
pack_unpack_to_array_of_bit_type
pack_unpack_to_array_of_byte_type
pack_unpack_to_array_of_int_type
          
*/

typedef enum{RED, GREEN, BLUE} color_type;

class temp_class extends uvm_object;
  `uvm_object_utils(temp_class)
  
  rand bit [7:0] tmp_addr;
  rand bit [7:0] tmp_data;
  
  function new(string name = "temp_class");
    super.new(name);
  endfunction
      
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("tmp_addr", tmp_addr, $bits(tmp_addr), UVM_HEX);
    printer.print_field_int("tmp_data", tmp_data, $bits(tmp_data), UVM_HEX);
  endfunction
  
  function void do_pack(uvm_packer packer);
    super.do_pack(packer);
    packer.pack_field_int(tmp_addr, $bits(tmp_addr));
    packer.pack_field_int(tmp_data, $bits(tmp_data));
  endfunction
  
  function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);
    tmp_addr = packer.unpack_field_int($bits(tmp_addr));
    tmp_data = packer.unpack_field_int($bits(tmp_data));
  endfunction
  
endclass:temp_class

class my_object extends uvm_object;
  `uvm_object_utils(my_object)
  
  rand int        value;
  rand color_type colors;
  rand byte       data[4];
  rand bit [7:0]  addr;
  rand temp_class tmp;
  
  function new(string name = "my_object");
    super.new(name);
    tmp = new();
  endfunction
  
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("value", value, $bits(value), UVM_HEX);
    printer.print_string("colors", colors.name);
    foreach(data[i])
      printer.print_field_int($sformatf("data[%0d]", i), data[i], $bits(data[i]), UVM_HEX);
    
    printer.print_field_int("addr", addr, $bits(addr), UVM_HEX);
    printer.print_object("tmp", tmp);
  endfunction
  
  function void do_pack(uvm_packer packer);
    super.do_pack(packer);
    packer.pack_field_int(value, $bits(value));
    packer.pack_field_int(colors, $bits(colors));
    foreach(data[i])
      packer.pack_field_int(data[i], $bits(data[i]));
    
    packer.pack_field_int(addr, $bits(addr));
    packer.pack_object(tmp);
  endfunction
  
  function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);
    value = packer.unpack_field_int($bits(value));
    colors = packer.unpack_field_int($bits(colors));
    foreach(data[i])
      data[i] = packer.unpack_field_int($bits(data[i]));
    
    addr = packer.unpack_field_int($bits(addr));
    packer.unpack_object(tmp);
  endfunction
  
endclass:my_object

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  my_object obj;
  bit packed_data_bits[];
  byte unsigned packed_data_bytes[];
  int unsigned packed_data_ints[];
  
  my_object unpack_obj;
  
  int pack_values[3];
  int unpack_values[3];
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj = my_object::type_id::create("obj", this);
    assert(obj.randomize());
    `uvm_info(get_full_name(), $sformatf("obj = \n%s", obj.sprint()), UVM_LOW);
    
    // pack methods
    pack_values[0] = obj.pack(packed_data_bits);
    pack_values[1] = obj.pack_bytes(packed_data_bytes);
    pack_values[2] = obj.pack_ints(packed_data_ints);
    `uvm_info(get_full_name(), $sformatf("packed_data_bits = %p", packed_data_bits), UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("packed_data_bytes = %p", packed_data_bytes), UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("packed_data_ints = %p", packed_data_ints), UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("pack_values[BITS] = %0d, pack_values[BYTES] = %0d, pack_values[INTS] = %0d", pack_values[0], pack_values[1], pack_values[2]), UVM_LOW);
    
    // unpack methods
    unpack_obj = my_object::type_id::create("unpack_obj", this);
    unpack_values[0] = unpack_obj.unpack(packed_data_bits);
    `uvm_info(get_full_name(), $sformatf("bits: unpack_obj = \n%s", unpack_obj.sprint()), UVM_LOW);
    unpack_values[1] = unpack_obj.unpack_bytes(packed_data_bytes);
    `uvm_info(get_full_name(), $sformatf("bytes: unpack_obj = \n%s", unpack_obj.sprint()), UVM_LOW);
    unpack_values[2] = unpack_obj.unpack_ints(packed_data_ints);
    `uvm_info(get_full_name(), $sformatf("ints: unpack_obj = \n%s", unpack_obj.sprint()), UVM_LOW);
    `uvm_info(get_full_name(), $sformatf("unpack_values[BITS] = %0d, unpack_values[BYTES] = %0d, unpack_values[INTS] = %0d", unpack_values[0], unpack_values[1], unpack_values[2]), UVM_LOW);
  endfunction
  
endclass :my_test

module tb_top;
  initial begin
    run_test("my_test");
  end
endmodule :tb_top

//LogFile Output
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
CPU time: 14.297 seconds to compile + .477 seconds to elab + .950 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun 10 06:25 2025
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
UVM_INFO testbench.sv(141) @ 0: uvm_test_top [uvm_test_top] obj = 
------------------------------------------
Name          Type        Size  Value     
------------------------------------------
obj           my_object   -     @349      
  value       integral    32    'h1f135537
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

UVM_INFO testbench.sv(147) @ 0: uvm_test_top [uvm_test_top] packed_data_bits = '{'h0, 'h0, 'h0, 'h1, 'h1, 'h1, 'h1, 'h1, 'h0, 'h0, 'h0, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h1, 'h0, 'h1, 'h0, 'h1, 'h0, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h1, 'h1, 'h1, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h1, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h0, 'h0, 'h1, 'h0, 'h0, 'h1, 'h0, 'h1, 'h0, 'h0, 'h1, 'h1, 'h1, 'h0, 'h0, 'h0, 'h0, 'h1, 'h0, 'h1, 'h1, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h1, 'h0, 'h0, 'h1, 'h1, 'h0, 'h1, 'h1, 'h1, 'h1, 'h0, 'h1} 
UVM_INFO testbench.sv(148) @ 0: uvm_test_top [uvm_test_top] packed_data_bytes = '{'h1f, 'h13, 'h55, 'h37, 'h0, 'h0, 'h0, 'h1, 'h9f, 'h33, 'h12, 'h9c, 'h2f, 'h39, 'hbd} 
UVM_INFO testbench.sv(149) @ 0: uvm_test_top [uvm_test_top] packed_data_ints = '{'h1f135537, 'h1, 'h9f33129c, 'h2f39bd00} 
UVM_INFO testbench.sv(150) @ 0: uvm_test_top [uvm_test_top] pack_values[BITS] = 120, pack_values[BYTES] = 120, pack_values[INTS] = 120
UVM_INFO testbench.sv(155) @ 0: uvm_test_top [uvm_test_top] bits: unpack_obj = 
------------------------------------------
Name          Type        Size  Value     
------------------------------------------
unpack_obj    my_object   -     @361      
  value       integral    32    'h1f135537
  colors      string      5     GREEN     
  data[0]     integral    8     'h9f      
  data[1]     integral    8     'h33      
  data[2]     integral    8     'h12      
  data[3]     integral    8     'h9c      
  addr        integral    8     'h2f      
  tmp         temp_class  -     @362      
    tmp_addr  integral    8     'h39      
    tmp_data  integral    8     'hbd      
------------------------------------------

UVM_INFO testbench.sv(157) @ 0: uvm_test_top [uvm_test_top] bytes: unpack_obj = 
------------------------------------------
Name          Type        Size  Value     
------------------------------------------
unpack_obj    my_object   -     @361      
  value       integral    32    'h1f135537
  colors      string      5     GREEN     
  data[0]     integral    8     'h9f      
  data[1]     integral    8     'h33      
  data[2]     integral    8     'h12      
  data[3]     integral    8     'h9c      
  addr        integral    8     'h2f      
  tmp         temp_class  -     @362      
    tmp_addr  integral    8     'h39      
    tmp_data  integral    8     'hbd      
------------------------------------------

UVM_INFO testbench.sv(159) @ 0: uvm_test_top [uvm_test_top] ints: unpack_obj = 
------------------------------------------
Name          Type        Size  Value     
------------------------------------------
unpack_obj    my_object   -     @361      
  value       integral    32    'h1f135537
  colors      string      5     GREEN     
  data[0]     integral    8     'h9f      
  data[1]     integral    8     'h33      
  data[2]     integral    8     'h12      
  data[3]     integral    8     'h9c      
  addr        integral    8     'h2f      
  tmp         temp_class  -     @362      
    tmp_addr  integral    8     'h39      
    tmp_data  integral    8     'hbd      
------------------------------------------

UVM_INFO testbench.sv(160) @ 0: uvm_test_top [uvm_test_top] unpack_values[BITS] = 120, unpack_values[BYTES] = 120, unpack_values[INTS] = 120
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   11
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1
[uvm_test_top]     9

$finish called from file "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_root.svh", line 527.
$finish at simulation time                    0
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.570 seconds;       Data structure size:   0.2Mb
Tue Jun 10 06:25:24 2025
Done
