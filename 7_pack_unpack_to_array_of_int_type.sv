/* 			UVM EXAMPLE-7 UVM Pack/Unpack to Array of Int types					*/

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_mem_seq_item extends uvm_sequence_item;
  // data and control fields
  rand bit [3:0] addr;
  rand bit		 wr_en;
  rand bit 		 rd_en;
  rand bit [7:0] wdata;
  	   bit [7:0] rdata;
  
  // Utility and field macros
  `uvm_object_utils_begin(my_mem_seq_item)
      	`uvm_field_int(addr, UVM_ALL_ON)
  		`uvm_field_int(wr_en, UVM_ALL_ON)
  		`uvm_field_int(rd_en, UVM_ALL_ON)
  		`uvm_field_int(wdata, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // Constructor
  function new(string name = "my_mem_seq_item");
    super.new(name);
  endfunction
  
  // Constraint
  constraint wr_rd_c { wr_en != rd_en; };  
  
endclass

// Testbench
module seq_item_tb_top;
  
  my_mem_seq_item seq_item_0;
  my_mem_seq_item seq_item_1;
  
  int unsigned int_packed_data[];
  
  initial
    begin
      // Create Method
      seq_item_0 = my_mem_seq_item::type_id::create("seq_item_0");
      seq_item_1 = my_mem_seq_item::type_id::create("seq_item_1");
      
      // =============== PACK ================ //
      seq_item_0.randomize();	// To randomize
      seq_item_0.print();	// To print
      
      // Pack method
      seq_item_0.pack_ints(int_packed_data);
      foreach(int_packed_data[i])
        `uvm_info("PACK",$sformatf("int_packed_data[%0d]= %0b",i,int_packed_data[i]), UVM_LOW)
        
      // =============== UNPACK =============== //  
      `uvm_info("UNPACK","Before UnPack", UVM_LOW)
      seq_item_1.print();
      
      // Unpack method
      seq_item_1.unpack_ints(int_packed_data);
      `uvm_info("UNPACK", "After UnPAck",UVM_LOW)
      seq_item_1.print();
    end
endmodule
      
//Logfile Output
Starting vcs inline pass...

4 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling module seq_item_tb_top
All of 4 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _425_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 5.175 seconds to compile + .234 seconds to elab + .426 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  2 08:01 2025
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

----------------------------------------
Name        Type             Size  Value
----------------------------------------
seq_item_0  my_mem_seq_item  -     @456 
  addr      integral         4     'h9  
  wr_en     integral         1     'h1  
  rd_en     integral         1     'h0  
  wdata     integral         8     'h6c 
----------------------------------------
UVM_INFO testbench.sv(53) @ 0: reporter [PACK] int_packed_data[0]= 10011001101100000000000000000000
UVM_INFO testbench.sv(56) @ 0: reporter [UNPACK] Before UnPack
----------------------------------------
Name        Type             Size  Value
----------------------------------------
seq_item_1  my_mem_seq_item  -     @460 
  addr      integral         4     'h0  
  wr_en     integral         1     'h0  
  rd_en     integral         1     'h0  
  wdata     integral         8     'h0  
----------------------------------------
UVM_INFO testbench.sv(61) @ 0: reporter [UNPACK] After UnPAck
----------------------------------------
Name        Type             Size  Value
----------------------------------------
seq_item_1  my_mem_seq_item  -     @460 
  addr      integral         4     'h9  
  wr_en     integral         1     'h1  
  rd_en     integral         1     'h0  
  wdata     integral         8     'h6c 
----------------------------------------
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.260 seconds;       Data structure size:   0.1Mb
Mon Jun  2 08:01:35 2025
Done
