`include "mem_sequence_item.sv"
//-------------------------------------------------------------------------------------------------
//Simple TestBench to check the Functionality of the developed Transaction class mem_sequence_item
//--------------------------------------------------------------------------------------------------
module seq_item_tb_top;
  
  //instance
  mem_sequence_item seq_item0;
  mem_sequence_item seq_item1;
  bit  bit_packed_data0[];
  bit  bit_packed_data1[];
  
  initial begin
    //create method
    //create(): The create method allocates a new object of the same type as this object and returns it via a base uvm_object handle.
    seq_item0 = mem_sequence_item::type_id::create(); 
    seq_item1 = mem_sequence_item::type_id::create(); 
    
    //randomizing the seq_item0
    seq_item0.randomize();  
    seq_item1.randomize();
    
    // Print seq_item0 and seq_item1 using the print method
    $display("Printing seq_item0:");
    seq_item0.print();
    
    $display("Printing seq_item1:");
    seq_item1.print();
    
     //compare method, It May give Mismatch because , both the seq_item are randomized , Same values may not be generated
    if(seq_item0.compare(seq_item1))
      `uvm_info("","In First attempt : seq_item0 Matching with seq_item1", UVM_LOW)
    else
      `uvm_error("","In First attempt : seq_item0 is Not Matching with seq_item1")
      
    
    // Copy method - Copy seq_item0 to seq_item1
    seq_item1.copy(seq_item0);
    
    // Print seq_item1 after copying
    $display("Printing seq_item1 after copying from seq_item0:");
    seq_item1.print();
             
    //---------------Matching Case------------------------------  
    
    if(seq_item0.compare(seq_item1))
      `uvm_info("","In Second attempt : seq_item0 Matching with seq_item1", UVM_LOW)
    else
      `uvm_error("","In Second attempt : seq_item0 is Not Matching with seq_item1") 
      
       
    //randomizing the seq_item0
    seq_item0.randomize();  
    seq_item1.randomize();   
    
    // Packing seq_item0 and seq_item1 using the pack method
      
    $display("Packing seq_item0:");
    //void'(seq_item0.pack(bit_packed_data0));
    seq_item0.pack(bit_packed_data0);
    $display("Size of bit_packed_data0: %0d", bit_packed_data0.size());
    foreach (bit_packed_data0[i]) 
      `uvm_info("PACK_seq_item0", $sformatf("bit_packed_data0[%0d] = %b", i, bit_packed_data0[i]), UVM_LOW)
   
    $display("Packing seq_item1:");
    //void'(seq_item1.pack(bit_packed_data1));
    seq_item1.pack(bit_packed_data1);
    $display("Size of bit_packed_data0: %0d", bit_packed_data0.size());
    foreach (bit_packed_data1[i]) 
      `uvm_info("PACK_seq_item1", $sformatf("bit_packed_data0[%0d] = %b", i, bit_packed_data1[i]), UVM_LOW)
      
    // Unpacking seq_item0 and seq_item1 using the pack method
      
    `uvm_info("UNPACK_seq_item0","Before UnPack", UVM_LOW)
    seq_item0.print();
    void'(seq_item0.unpack(bit_packed_data0));
    //seq_item0.unpack(bit_packed_data0);
    $display("Size of bit_packed_data0: %0d", bit_packed_data0.size());
    `uvm_info("UNPACK_seq_item0","After UnPack", UVM_LOW)
    seq_item0.print();
   
    `uvm_info("UNPACK_seq_item1","Before UnPack", UVM_LOW)
    seq_item1.print();
    void'(seq_item0.unpack(bit_packed_data0));
    //seq_item1.unpack(bit_packed_data1);
    $display("Size of bit_packed_data1: %0d", bit_packed_data1.size());
    `uvm_info("UNPACK_seq_item1","After UnPack", UVM_LOW)
    seq_item1.print();
    
    // Use convert2string method
    $display("seq_item0 as string: %s", seq_item0.convert2string());
    $display("seq_item1 as string: %s", seq_item1.convert2string());
    
    $display("----------------------------------------------------");
    
    // Use output2string method
    $display("seq_item0 as string: %s", seq_item0.output2string());
    $display("seq_item1 as string: %s", seq_item1.output2string());
         
    
  end  
endmodule :seq_item_tb_top
