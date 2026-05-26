What is m_sequencer and p_sequencer in UVM ???

m_sequencer:
- m_sequencer is a handle available by default in a sequence. m_sequencer has a type of uvm_sequencer_base.
- Simply, it is a reference handle to the sequencer on which the sequence is running.
- To run a sequence on the sequencer, the start() method is called. This start method needs to provide a sequencer handle.
- Example: base_seq.start(env_o.seqr);
- Here, m_seqeuncer is a handle for base_seq that is set to env_o.seqr.

p_sequencer:
-All sequences have a m_sequencer handle but they do not have a p_sequencer handle.
-p_sequencer is not defined automatically. 
-It is defined using macro `uvm_declare_p_sequencer(sequencer_name). 

`define uvm_declare_p_sequencer(SEQUENCER) \
  SEQUENCER p_sequencer;\
  virtual function void m_set_p_sequencer();\
    super.m_set_p_sequencer(); \
    if( !$cast(p_sequencer, m_sequencer)) \
      `uvm_fatal("DCLPSQ", $sformatf("%m %s Error casting p_sequencer, please verify that this sequence/sequence item is intended to execute on this type of sequencer",get_full_name())) \
  endfunction 

-As shown above, define p_sequencer macro does declare p_sequencer handle of SEQUENCER type and casts m_sequencer handle to p_sequencer.
-A virtual sequencer is generally referred to as a p_sequencer. 
-This is used for user convenience. It is not a mandatory requirement. You can access virtual_sequencer with the env hierarchy path.
-It sounds confusing but to understand the usage of p_sequencer and what exactly it is. Let’s understand what is a virtual sequence and virtual sequencer concept in the next section.     
