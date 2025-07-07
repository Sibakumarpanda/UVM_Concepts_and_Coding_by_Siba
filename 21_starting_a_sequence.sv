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

Method type                                  Methods                                          Description

task                                         pre_start                                        It is a user-definable callback that is called before the optional execution of the pre_body task.  

task                                         pre_body                                         It is a user-definable callback that is called before the execution of body only when the sequence is started with start.

task                                         pre_do                                           It is a user-definable callback task that is called on parent sequence (if any) before the item is 
                                                                                              randomized and after sequence has issued wait_for_grant() call.

function                                     mid_do                                           It is a user-definable callback function that is called after the sequence item is randomized, 
                                                                                              and just before the item is sent to the driver.
  
task                                         body                                             It is a user-defined task to write main sequence code.

function                                     post_do                                          It is a user-definable callback function that is called after completing the item using either put or item_done methods.

task                                         post_body                                        It is a user-definable callback task that is called after the execution of the body only when the sequence 
                                                                                              is started with the start method.
  
task                                         post_start                                       It is a user-definable callback that is called after the optional execution of the post_body task.
  
-Note: mid_do and post_do are functions and other methods are tasks.
-The pre_start and post_start methods are always called.
-The start method call follows the below sequence:
  
sub_seq.pre_start()        
sub_seq.pre_body()          if call_pre_post==1 
  parent_seq.pre_do(0)      if parent_sequence!=null 
  parent_seq.mid_do(this)   if parent_sequence!=null
sub_seq.body                YOUR STIMULUS CODE 
  parent_seq.post_do(this)  if parent_sequence!=null 
sub_seq.post_body()         if call_pre_post==1 
sub_seq.post_start()



  
