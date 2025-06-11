Resource database Concept and Mechanism in UVM :

The UVM centralized resource database is used to store configurable objects, variables, virtual interfaces, queues, class handles, etc and retrieve them from the database. 
Hence , such a configurable testbench provides a degree of freedom to the verification engineer to use provided information in various parts of the testbench.
The resource database consists of polymorphic resource containers that store each resource in the form of a lookup table.
A lookup table is nothing but a centralized resource database. 
The uvm_resource_base and uvm_resource as shown below are uvm source code snippets.
