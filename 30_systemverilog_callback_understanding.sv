System Verilog Callback Understanding:
-The callbacks are used to alter the behavior of the component without modifying its code. 
-The verification engineer provides a set of hook methods that helps to customize the behavior depending on the requirement. 
-A simple example of callbacks can be the pre_randomize and post_randomize methods before and after the built-in randomize method call.

Callback usage:
-It allows plug-and-play mechanism to establish a reusable verification environment.
-Based on the hook method call, the user-defined code is executed instead of the empty callback method.
-Simply, callbacks are the empty methods that can be implemented in the derived class to tweak the component behavior. 
-These empty methods are called callback methods and calls to these methods are known as callback hooks.

A Simple Callback Example :
-In below example, modify_pkt is a callback method and it is being called in the pkt_sender task known as callback hook.
-The driver class drives a GOOD packet. 
-The err_driver is a derived class of the driver class and it sends a corrupted packet of type BAD_ERR1 or BAD_ERR2 depending on the inject_err bit.
-If the inject_err bit is set, then a corrupted packet will be generated otherwise a GOOD packet will be generated.  

//Callback Example using System Verilog-Example1

  
