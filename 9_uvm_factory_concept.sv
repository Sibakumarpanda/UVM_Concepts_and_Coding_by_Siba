Concept of UVM Factory:
The UVM factory is used to create UVM objects and components. 
This is commonly known as factory registration. 
The factory registration for UVM objects and components are lightweight proxies to the actual objects and components.

Guidelines for writing class for uvm_object/ uvm_component:
  1.Factory registration
  2.Default constructor new()
  3.Component and object creation
    
Factory registration:
All uvm_component and uvm_object must be registered with the factory using a pre-defined factory registration macro.
