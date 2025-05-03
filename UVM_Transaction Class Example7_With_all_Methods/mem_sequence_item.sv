//-----------------------------------------------------------------------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : mem_sequence_item.sv 
// Project : 
// Purpose : A standardized Transaction class with various Methods like create, print, copy, compare,pack, unpack,convert2string , output2string
// Author  : Siba Kumar Panda
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class mem_sequence_item extends uvm_sequence_item;
  //Control Information
  rand bit [3:0] addr;
  rand bit       wr_en;
  rand bit       rd_en;  
  rand bit [7:0] wdata;  //Payload Information 
       bit [7:0] rdata;  //Analysis Information
  
 `uvm_object_utils(mem_sequence_item)
  
  //Constructor
  extern function new(string name = "mem_sequence_item");
    
  //Print Method
  extern function void do_print(uvm_printer printer);
   
  //Copy Method  
  extern function void do_copy(uvm_object rhs);
      
  // Compare method
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	  
  // Pack method
  extern function void do_pack(uvm_packer packer);    
  
// Unpack method
/*function void do_unpack(uvm_packer packer);
	 packer.unpack_field_int(addr, $bits(addr));
	 packer.unpack_field_int(wr_en, $bits(wr_en));
	 packer.unpack_field_int(rd_en, $bits(rd_en));
	 packer.unpack_field_int(wdata, $bits(wdata));
	 
endfunction*/
  
  // Unpack method
  extern function void do_unpack(uvm_packer packer);
     
  // Convert to string method
  extern function string convert2string();
    
  // Output to string method
  extern function string output2string();
   
          
  //constaint, to generate any one among write and read
  constraint wr_rd_c { wr_en != rd_en; }; 
  
endclass: mem_sequence_item

//Constructor
function mem_sequence_item::new(string name = "mem_sequence_item");
   super.new(name);
endfunction :new
  
//Print Method
function void mem_sequence_item::do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("addr", addr, $bits(addr));
    printer.print_field("wr_en", wr_en, $bits(wr_en));
    printer.print_field("rd_en", rd_en, $bits(rd_en));
    printer.print_field("wdata", wdata, $bits(wdata));

endfunction :do_print
    
//Copy Method  
function void mem_sequence_item::do_copy(uvm_object rhs);
     mem_sequence_item rhs_ ;
     if (!$cast(rhs_, rhs)) 
       return;
     this.addr  = rhs_.addr;
     this.wr_en = rhs_.wr_en;
     this.rd_en = rhs_.rd_en;
     this.wdata = rhs_.wdata;
   
 endfunction :do_copy
  
// Compare method
function bit mem_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
	 mem_sequence_item rhs_ ;
	 if (!$cast(rhs_, rhs)) 
        return 0;
	    return (this.addr   == rhs_.addr) &&
	           (this.wr_en  == rhs_.wr_en) &&
	           (this.rd_en  == rhs_.rd_en) &&
	           (this.wdata  == rhs_.wdata) ;
  
endfunction :do_compare
  
// Pack method
function void mem_sequence_item::do_pack(uvm_packer packer);
     packer.pack_field_int(addr,  $bits(addr));
	 packer.pack_field_int(wr_en, $bits(wr_en));
	 packer.pack_field_int(rd_en, $bits(rd_en));
	 packer.pack_field_int(wdata, $bits(wdata));
	    
endfunction :do_pack 
    
function void mem_sequence_item::do_unpack(uvm_packer packer);
    void'(packer.unpack_field_int(addr));  // Cast to void if return value is not needed
    void'(packer.unpack_field_int(wr_en)); // Cast to void if return value is not needed
    void'(packer.unpack_field_int(rd_en)); // Cast to void if return value is not needed
    void'(packer.unpack_field_int(wdata)); // Cast to void if return value is not needed
endfunction :do_unpack
  
// Convert to string method
function string mem_sequence_item::convert2string();
    string s;
    //s = $sformatf("addr=%4h, wr_en=%4h, rd_en=%4h, wdata=%b,",addr,wr_en,rd_en,wdata);
    s = $sformatf("addr=%h, wr_en=%h, rd_en=%h, wdata=%b,",addr,wr_en,rd_en,wdata);
    return s;
endfunction :convert2string

// Output to string method    
function string mem_sequence_item::output2string();
    string s;
    s = $sformatf("rdata=%h", rdata);
    return s;
endfunction :output2string     
    