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

Approach A: Using get_next_item and item_done methods in the driver Without RSP packet : The steps are,
  
-Create a sequence item and register in the factory using the create_item function call. 
-The wait_for_grant issues request to the sequencer and wait for the grant from the sequencer. It returns when the sequencer has granted the sequence. 
-Randomize the sequence item and send it to the sequencer using send_request call. 
-There should not be any simulation time delay between wait_for_grant and send_request method call. 
-The sequencer forwards the sequence item to the driver with the help of REQ FIFO. This unblocks the get_next_item() call and the driver receives the sequence item.
-The wait_for_item_done() call from sequence gets blocked until the driver responds back.
-In the meantime, the driver drives the sequence item to the DUT using a virtual interface handle. Once it is completed, the item_done method is called. 
-This unblocks the wait_for_item_done method from the sequence.
-If a response has to be sent from the driver to the sequence, item_done(RSP) is called with the RSP item as an argument. 
-The RSP item is communicated to the sequence by a sequencer with help of RSP FIFO. 
-It is important to call the get_response method to get the response. 
-NOTE :This step is optional and not required if the RSP item is not sent by the DUT.
- We can understand this , with an example in below link :
     Link : https://github.com/Sibakumarpanda/UVM_Concepts_and_Coding_by_Siba/blob/main/23_ex1_sequence_driver_sequencer_comm_approach_without_rsp_pkt.sv

Approach A: Using get_next_item and item_done methods in the driver With RSP packet : The steps are,  
  - The steps are same as above stpes mentioned in without RSP Packet section , An extra step (last step is needed here).
  - We can see this with an example in below link :
      Link : https://github.com/Sibakumarpanda/UVM_Concepts_and_Coding_by_Siba/blob/main/23_ex2_sequence_driver_sequencer_comm_approach_with_rsp_pkt.sv

Approach B: Using get and put methods in driver:
  
-Create a sequence item and register in the factory using the create_item function call.
-The wait_for_grant issues the request to the sequencer and wait for the grant from the sequencer. It returns when the sequencer has granted the sequence.
-Randomize the sequence item and send it to the sequencer using send_request call. 
-There should not be any simulation time delay between wait_for_grant and send_request method call. 
-The sequencer forwards the sequence item to the driver with the help of REQ FIFO. This unblocks the get() call and the driver receives the sequence item.
-The wait_for_item_done() call from the sequence gets blocked until the driver calls the get method.
-Once the get method is called, the wait_for_item_done() call from sequence gets unblocked immediately without caring about driving the virtual interface.
-The get_response call is necessary to call that completes the communication. 
-The get_response method is blocked until the driver calls put(RSP).
-In the meantime, the driver drives the sequence item to the DUT using a virtual interface handle. 
-Once it is completed, the put(RSP) method is called. This unblocks the get_response method from the sequence. 
-The RSP item is communicated to the sequence by a sequencer with help of RSP FIFO.
- We can understand this , with an example in below link :
    Link :  https://github.com/Sibakumarpanda/UVM_Concepts_and_Coding_by_Siba/blob/main/23_ex3_sequence_driver_sequencer_comm_approach_using_get_put.sv
  
