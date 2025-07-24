UVM Barrier Concept Understanding:

-Similar to the UVM event, UVM provides another way to achieve synchronization with the UVM Barrier.
-The UVM barrier provides multi-process synchronization that blocks a set of processes until the desired number of processes reaches a particular synchronizing point at which all the processes are released.
-UVM Barrier Class Declaration:  class uvm_barrier extends uvm_object

UVM Barrier Usage:
-UVM Barrier is used to synchronize the number of processes based on the threshold value set by the set_threshold method. 
-Once the threshold is reached, the processes are unblocked by the wait_for method.  

UVM Barrier Methods:  

Type                      Methods                           Description

function                  new                               Creates a new object for barrier  

function                 set_threshold                      Sets a process threshold that waits till the mentioned number of processes reaches the barrier. 
                                                            Once the threshold is reached, all waiting processes are activated.  
  
function                 get_threshold                      Gets current threshold value for the barrier.

task                     wait_for                           Waits for the number of processes being set by the set_threshold method before continuing from the barrier. 

function                 get_num_waiters                    Returns the number of processes currently waiting at the barrier.  

function                 reset                              Resets the barrier and sets the waiter process count to zero. 
                                                            After reset, the barrier will force processes to wait for the same threshold value again. 
                                                            The reset function does not change the threshold value which was set by the set_threshold method last time .

function                 set_auto_reset                     Once the threshold is reached, the barrier should reset itself. 
                                                            This is the default configuration that makes sure blocking of new processes until the threshold reaches again.
                                                            If set_auto_reset is turned off, once the threshold is reached, 
                                                            new processes will not be blocked until the barrier is reset.   

function                 cancel                             Decrements the waiter count by one that is used when a process is being killed or activated 
                                                            while waiting on the barrier.                                                              
