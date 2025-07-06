How to start a sequence ???
-A sequence is started by calling the start method that accepts a pointer to the sequencer through which sequence_items are sent to the driver. 
-A pointer to the sequencer is also commonly known as m_sequencer.
-The start method assigns a sequencer pointer to the m_sequencer and then calls the body() task. 
-On completing the body task with the interaction with the driver, the start() method returns. 
-As it requires interaction with the driver, the start is a blocking method.

-start method definition:
virtual task start ( uvm_sequencer_base sequencer,
                     uvm_sequence_base parent_sequence = null,
                     int this_priority = -1;
                     bit call_pre_post = 1; 
                    
- Where , sequencer = While starting a sequence, on which sequencer it has to be started, need to be specified whereas other arguments are optional.
          parent_sequence = parent_sequence is a sequence that calls the current sequence. If parent_sequence is null, then this sequence is a root parent otherwise, it is a child of parent_sequence. 
                           The parent_sequence’s pre_do, mid_do, and post_do methods will be called during the execution of the current sequence.
          this_priority = this_priority is the priority of the sequence (by default it considers the priority of the parent sequence). Higher priority is indicated by higher value.
          call_pre_post = By default, call_pre_post = 1 is set which means pre_body and post_body methods will be called. To disable calling these methods, call_pre_post can be set to 0.

-For a sequence named as child_seq, the start method can be called as shown below:
   assert(child_seq.randomize());
   child_seq.start(seqr, parent_seq, priority, call_pre_post);  
-The following methods are called during sequence execution via the start method:  
