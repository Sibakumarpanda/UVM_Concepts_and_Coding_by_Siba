Lock and Grab Methods in UVM sequencer:

-The UVM sequencer provides the facility to have exclusive access for the sequence to a driver via a sequencer using a locking mechanism. 
-This locking mechanism is implemented using lock and grab methods.
-Example: In controller or microprocessor, internal core services interrupt handling along with other operations. 
-Sometimes, if a particular interrupt is raised by the device which needs immediate attention and stops ongoing process execution. 
-Once this high-priority interrupt is serviced by the core, the previous process can be resumed.

lock method:
-On calling the lock method from a sequence, the sequencer will grant the sequence exclusive access to the driver when the sequence gets the next available slot via a sequencer arbitration mechanism. 
-Until the sequence calls the unlock method, no other sequence will have access to the driver. On calling unlock method, the lock will be released. 
-The lock is a blocking method and returns once the lock has been granted.
-Decleration : task lock (uvm_sequencer_base sequencer = null)  

grab method:
-The grab method is similar to the lock method except it takes immediate control to grab the next sequencer arbitration slot itself by overriding any other sequence priorities.
-The pre-existing lock or grab condition on the sequence will stop from grabbing the sequence for the current sequence.
-Decleration : task grab (uvm_sequencer_base sequencer = null)  

unlock method :
-The unlock method of the sequencer is called from the sequence to release its lock or grab. 
-It is mandatory to call unlock method in order to avoid sequencer locked conditions.
-Decleration : function void unlock (uvm_sequencer_base sequencer = null) 

ungrab method :
-The ungrab method is an alias of the unlock method
-Decleration : function void ungrab( uvm_sequencer_base sequencer = null)  

is_blocked method :
-The is_blocked method can be used to find a current sequence that is blocked due to the sequencer lock condition and returns 1. 
-It returns 0 value, then the sequence is not blocked and available to get the next slot in sequencer arbitration. 
-There is a possibility that the sequence may not get the slot if the sequencer is locked before the sequence issues a request.
-Decleration : function bit is_blocked() 

has_lock method :
-It returns 1 if the current sequence is locked, else returns 0.
-Decleration : function bit has_lock()  

kill method :
-The kill function is used to kill the sequence and removes all current locks and requests in the sequence’s default sequencer. 
-This will not allow executing the post_body and post_start callback methods and the sequence state will change to UVM_STOPPED.
-Decleration : function void kill()  

do_kill method :
-The do_kill is a user hook that is being called when a sequence is terminated by using sequence kill() or sequencer.stop_sequences().
-Note: sequencer.stop_sequences() ultimately calls sequence.kill method.
-Decleration : virtual function void do_kill() 

Note:
-The lock, grab, unlock and ungrab methods put requests on the specified sequencer. 
-If no argument is passed, the default sequencer will be considered.
-The lock method puts a lock request at the back of the arbitration queue whereas the grab method puts a grab request in front of the arbitration queue. 
-Hence, the grab request is serviced immediately as compared to the lock request if the arbitration queue has intermediate pending requests.  
-Please check below to examples for more understanding.
  1. Lock and unlock methods example
     Link : https://github.com/Sibakumarpanda/UVM_Concepts_and_Coding_by_Siba/blob/main/22_uvm_sequencer_lock_unlock_method_example.sv
  2. Grab and ungrab methods example
     Link : https://github.com/Sibakumarpanda/UVM_Concepts_and_Coding_by_Siba/blob/main/22_uvm_sequencer_grab_ungrab_method_example.sv
   
