Virtual Sequence and Virtual Sequencer Understanding:
-A virtual sequence is nothing but a container that starts multiple sequences on different sequencers.
-Virtual sequencer controls other sequencers and it is not attached to any driver.
  
Virtual Sequence and Virtual Sequencer Usage:
-In SOC, there could be different modules that interact with different protocols So, we need different drivers to drive corresponding interfaces.
-So we usually keep separate agents to handle the different protocols. So, we need to execute sequences on corresponding sequencers.
-Another example can be thought of as multiple cores in SOC. 
-There can be multiple cores present in SOC that can handle different operations on input provided and respond to the device differently. 
-In this case, as well, different sequence execution becomes important on different sequencers.
-A virtual sequence is usually executed on the virtual sequencer. A virtual sequence gives control to start different sequences.
-It is recommended to use a virtual sequencer if you have multiple agents and stimulus coordination is required.

Why are the virtual_sequence and virtual_sequencer named virtual???
-System Verilog has virtual methods, virtual interfaces, and virtual classes. 
- “virtual” keyword is common in all of them. 
-But, virtual_sequence and virtual_sequencer do not require any virtual keyword. 
-UVM does not have uvm_virtual_sequence and uvm_virtual_sequencer as base classes. A virtual sequence is derived from uvm_sequence. 
-A virtual_sequencer is derived from uvm_sequencer as a base class.
-Virtual sequencer controls other sequencers. It is not attached to any driver and can not process any sequence_items too. Hence, it is named virtual.  

Examples:
- To understand the concept of Virtual Sequence and Virtual Sequencer in depth , we have here Four variety of examples as below .
    1. Example1: Without virtual sequence and virtual sequencer 
       Link :
    2. Example2: With virtual sequence and without a virtual sequencer
       Link:
    3. Example3: With virtual sequence and virtual sequencer using p_senquencer handle
       Link:
    4. Example4: With virtual sequence and virtual sequencer but without using p_senquencer handle
       Link:
