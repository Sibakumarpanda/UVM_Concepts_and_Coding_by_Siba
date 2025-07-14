Sequence-Driver-Sequencer communication in UVM :
-We understood the concept of sequece_item, sequence, sequencer, and driver independently. 
-Here in this , we will discuss how they talk with each other and provide sequence items from sequence to driver via the sequencer. 
-Before that make sure ,we are aware of all methods used in sequencer and driver. (Refer: UVM Sequencer and UVM Driver).
  
Understanding Sequencer-Driver Connections:
-The sequencer and driver communicate with each other using a bidirectional TLM interface to transfer REQ and RSP sequence items.
-The driver has uvm_seq_item_pull_port which is connected with uvm_seq_item_pull_export of the associated sequencer. 
-This TLM interface provides a facility to use implemented API to retrieve REQ items and turn RSP items.  
-Note: Both uvm_seq_item_pull_port and uvm_seq_item_pull_export are parameterized classes with REQ and RSP sequence items.
-The TLM connection between driver and sequencer is one-to-one. 
-It means neither multiple sequencers are connected to a single driver nor multiple drivers connected to a single sequencer.  
-Connections: The driver and sequencers are connected in the connect_phase of the UVM agent as below: 
              <driver_inst>.seq_item_port.connect(<sequencer_inst>.seq_item_export);
-Where, The seq_item_port and seq_item_export are an instance handle for uvm_seq_item_pull_port and uvm_seq_item_pull_export respectively. 

Sequence-Driver-Sequencer communication Approaches :
-Based on the varieties of methods available with sequence and driver, all combinations are explained further.
    Approach A: Using get_next_item and item_done methods in the driver (Without RSP packet and with RSP packet)
    Approach B: Using get and put methods in driver  

Approach A: Using get_next_item and item_done methods in the driver Without RSP packet :
  
  
