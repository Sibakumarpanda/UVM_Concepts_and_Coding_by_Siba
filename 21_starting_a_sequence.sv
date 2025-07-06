How to start a sequence?
-A sequence is started by calling the start method that accepts a pointer to the sequencer through which sequence_items are sent to the driver. 
-A pointer to the sequencer is also commonly known as m_sequencer.
-The start method assigns a sequencer pointer to the m_sequencer and then calls the body() task. 
-On completing the body task with the interaction with the driver, the start() method returns. 
-As it requires interaction with the driver, the start is a blocking method.
