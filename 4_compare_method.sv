/* 			UVM EXAMPLE-4 UVM Compare Method					*/
`include "uvm_macros.svh"
import uvm_pkg ::*;

class my_mem_seq_item extends uvm_sequence_item;
  
  // Control Information
  rand bit [3:0] addr;
  rand bit 		wr_en;
  rand bit 		rd_en;
  
  // Payload Information
  rand bit [7:0] wdata;
  
  // Alanlysis Information
  bit [7:0] rdata;
  
  // utility and field macros
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
  
  // Constraint to generate only one among read and write
   constraint wr_rd_c { wr_en != rd_en; }; 
endclass

module sv_seq_item_tb;
  // Instance
  my_mem_seq_item seq_item_0;
  my_mem_seq_item seq_item_1;
  
  initial
    begin
      // Create Method
      seq_item_0 = my_mem_seq_item::type_id::create("seq_item_0");
      seq_item_1 = my_mem_seq_item::type_id::create("seq_item_1");
      
      // ***************** Matching Case *************************
  	  // Randomizing seq_item_0
      seq_item_0.randomize();
                                                 
      // Randomizing seq_item_1   
      seq_item_1.randomize();
                                                 
      seq_item_0.print();// To print seq_item_0
      seq_item_1.print();// To print seq_item_1
                                                 
      // Compare Method
      if(seq_item_0.compare(seq_item_1))
      	`uvm_info("","seq_item_0 matching with seq_item_1", UVM_LOW)
      else
        `uvm_error("","This Error is Expected --> seq_item_0 is not matching with seq_item_1")
        
      // ***************** Matching Case *************************
      seq_item_1.copy(seq_item_0); // Copying seq_item_0 to seq_item_1
      
      seq_item_0.print();// To print seq_item_0
      seq_item_1.print();// To print seq_item_1
      
      // Compare Method
      if(seq_item_0.compare(seq_item_1))
        `uvm_info("","seq_item_0 matching with seq_item_1", UVM_LOW)
      else
      	`uvm_error("","seq_item_1 is not matching with seq_item_1")
    end
endmodule

//Logfile Output
Starting vcs inline pass...

4 modules and 0 UDP read.
recompiling package vcs_paramclassrepository
recompiling package _vcs_DPI_package
recompiling package uvm_pkg
recompiling module sv_seq_item_tb
All of 4 modules done
rm -f _cuarc*.so _csrc*.so pre_vcsobj_*.so share_vcsobj_*.so
g++ -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -c /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.1/src/dpi/uvm_dpi.cc
gcc  -w  -pipe -fPIC -DVCS -O -I/apps/vcsmx/vcs/U-2023.03-SP2/include    -fPIC -c -o uM9F1_0x2aB.o uM9F1_0x2aB.c
if [ -x ../simv ]; then chmod a-x ../simv; fi
g++  -o ../simv      -rdynamic  -Wl,-rpath='$ORIGIN'/simv.daidir -Wl,-rpath=./simv.daidir -Wl,-rpath=/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib -L/apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib  -Wl,-rpath-link=./  uvm_dpi.o   objs/amcQw_d.o   _426_archive_1.so   SIM_l.o    uM9F1_0x2aB.o   rmapats_mop.o rmapats.o rmar.o rmar_nd.o  rmar_llvm_0_1.o rmar_llvm_0_0.o            -lvirsim -lerrorinf -lsnpsmalloc -lvfs    -lvcsnew -lsimprofile -luclinative /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_tls.o   -Wl,-whole-archive  -lvcsucli    -Wl,-no-whole-archive       ./../simv.daidir/vc_hdrs.o    /apps/vcsmx/vcs/U-2023.03-SP2/linux64/lib/vcs_save_restore_new.o -ldl  -lc -lm -lpthread -ldl 
../simv up to date
CPU time: 5.008 seconds to compile + .238 seconds to elab + .427 seconds to link
Chronologic VCS simulator copyright 1991-2023
Contains Synopsys proprietary information.
Compiler version U-2023.03-SP2_Full64; Runtime version U-2023.03-SP2_Full64;  Jun  2 06:49 2025
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
----------------------------------------
Name        Type             Size  Value
----------------------------------------
seq_item_1  my_mem_seq_item  -     @460 
  addr      integral         4     'h7  
  wr_en     integral         1     'h1  
  rd_en     integral         1     'h0  
  wdata     integral         8     'h14 
----------------------------------------
UVM_INFO @ 0: reporter [MISCMP] Miscompare for seq_item_0.addr: lhs = 'h9 : rhs = 'h7
UVM_INFO @ 0: reporter [MISCMP] 1 Miscompare(s) for object seq_item_1@460 vs. seq_item_0@456
UVM_ERROR testbench.sv(60) @ 0: reporter [] This Error is Expected --> seq_item_0 is not matching with seq_item_1
----------------------------------------
Name        Type             Size  Value
----------------------------------------
seq_item_0  my_mem_seq_item  -     @456 
  addr      integral         4     'h9  
  wr_en     integral         1     'h1  
  rd_en     integral         1     'h0  
  wdata     integral         8     'h6c 
----------------------------------------
----------------------------------------
Name        Type             Size  Value
----------------------------------------
seq_item_1  my_mem_seq_item  -     @460 
  addr      integral         4     'h9  
  wr_en     integral         1     'h1  
  rd_en     integral         1     'h0  
  wdata     integral         8     'h6c 
----------------------------------------
UVM_INFO testbench.sv(70) @ 0: reporter [] seq_item_0 matching with seq_item_1
           V C S   S i m u l a t i o n   R e p o r t 
Time: 0 ns
CPU Time:      0.260 seconds;       Data structure size:   0.1Mb
Mon Jun  2 06:49:17 2025
Done        
        
