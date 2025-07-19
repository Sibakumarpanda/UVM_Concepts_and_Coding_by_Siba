UVM Callback Understandng:
-The callbacks are used to alter the behavior of the component or object without modifying its code. 
-Refer System Verilog callback to have a better understanding. A simple example of callbacks can be the phasing mechanism in UVM.

UVM Callback Usage:
-Allows plug-and-play mechanism to establish a reusable verification environment.
-Based on the hook method call, the user-defined code is executed instead of the empty callback method. This brings various flavors of the component or object.
-Callbacks can be used to introduce errors or delays in the components.

UVM Callback Macros with description:

`uvm_register_cb(T, CB)
Description:
-Register the user-defined callback which is extended from uvm_callback.
-If a type-callback pair is not registered then a warning is issued for an attempt to call add, delete, etc methods.
-Here, T – Object type where user-defined callback is used and it must be derived from uvm_object.
-Here, CB – user-defined callback type

`uvm_do_callbacks(T, CB, METHOD)
Description:
-Calls METHOD of user-defined callback class.
-Here, T – Object type where user-defined callback is used and it must be derived from uvm_object.
-Here, CB – user-defined callback type
-Here, METHOD – callback method call to invoke.  

`uvm_do_obj_callbacks(T, CB, OBJ, METHOD)
Description:
-It is similar to `uvm_do_callbacks macro, but it has an additional OBJ argument to specify external object associated with the callback.
-Example: For applying callback in a sequence, OBJ could be specified as parent sequence or sequencer. 

UVM Callback Classes with description :
-The UVM callback provides a set of classes for its implementation.
  uvm_callbacks     - provides a base class for callback implementation and is typically used for modifying component behavior without modifying the component class.
  uvm_callback_iter -It is an iterator class for iterating over callback queues of a specific type.
  uvm_callback      -Provides a base class for user-defined callback classes.

UVM Callback Methods with description :
 -The uvm_callback methods can be called using a scope resolution operator as they are static methods.
 -For example: uvm_callbacks#(T, CB)::add(obj,cb);
-Where,
 T : Object type where user-defined callback is used and it must be derived from uvm_object.
 CB : user-defined callback type
 obj : object handle where user-defined callback is used
 cb : a user-defined callback object 
- The methods with description is as below: 
-add :Registers the given callback object with the given obj handle.
-add_by_name: Registers the given callback object with one or more uvm_components.
-delete :Deletes the given callback object.
-delete_by_name:Deletes the given callback object with one or more uvm_components.  

Steps to implement uvm_callback :
    
1. Create a user-defined callback class that extends from the uvm_callback class.
   class driver_cb extends uvm_callback;
2. Add an empty callback method 
   virtual task modify_pkt();
   endtask   
3. Implement a callback method in the class which is extended from the above user-defined class.
4. Register user-defined callback method using `uvm_register_cb in the component or object where callbacks are called (In the below example, it is registered in the driver component).
   `uvm_register_cb(driver,driver_cb)
   If `uvm_register_cb is not used then a warning is issued as like below.
   Example: UVM_WARNING @ 0: reporter [CBUNREG] Callback drvd_cb cannot be registered with object (*) because callback type derived_cb is not registered with object type uvm_object
5. Place callback hook i.e. calling callback method in the required component or object using `uvm_do_callbacks macro.
   `uvm_do_callbacks(driver,driver_cb,modify_pkt());
  
//Sample Code Snippet:
class driver_cb extends uvm_callback;
  `uvm_object_utils(driver_cb)
  
  function new(string name = "driver_cb");
    super.new(name);
  endfunction
  
  virtual task modify_pkt();
  endtask
endclass

class derived_cb extends driver_cb;
  `uvm_object_utils(derived_cb)
  
  function new(string name = "derived_cb");
    super.new(name);
  endfunction
  
  task modify_pkt; // callback method implementation
    `uvm_info(get_full_name(),"Inside modify_pkt method: Injecting error pkt",UVM_LOW);
    std::randomize(pkt) with {pkt inside {BAD_ERR1, BAD_ERR2};};
  endtask
endclass  
  

  
