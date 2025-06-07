UVM Objection Concept:

It provides a mechanism to coordinate status information between two or more components, objects. 
The uvm_objection class is extended from uvm_report_object.
The objection deals with the concept of raise and drop objection which means the internal counter is increment and decrement respectively. 
Each participating component and object may raise or drop objections asynchronously. 
When all objections are dropped, the counter value will become zero. 
The objection has to be raised before starting any process and drop it once it is completed.
Decleration :  
class uvm_objection extends uvm_report_object  
