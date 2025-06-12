Resource database Concept and Mechanism in UVM :

The UVM centralized resource database is used to store configurable objects, variables, virtual interfaces, queues, class handles, etc and retrieve them from the database. 
Hence , such a configurable testbench provides a degree of freedom to the verification engineer to use provided information in various parts of the testbench.
The resource database consists of polymorphic resource containers that store each resource in the form of a lookup table.
A lookup table is nothing but a centralized resource database. 
The uvm_resource_base and uvm_resource as shown below are uvm source code snippets.
  
//uvm_resource_base code Snippet:  
virtual class uvm_resource_base extends uvm_object;
  protected string scope;
  int unsigned precedence;
  static int unsigned default_precedence = 1000;
  ...
  ...
endclass
  
//uvm_resource class code Snippet:  
class uvm_resource #(type T=int) extends uvm_resource_base;

  typedef uvm_resource#(T) this_type;
  static this_type my_type = get_type();
  ...
  ...
endclass 

-In above code, The uvm_resource_base class is a common base class for the resource container family that defines a set of functions. 
-The uvm_resource#(type T) is a parameterized class that provides additional functions like read() and write() for resource operation.
-Each resource has a set of scope. 
-A scope is a context like an instantiation of the component in the uvm testbench hierarchy that represents a unique string (For example tb_top.env.agent_o.mon).
-A scope may also use uvm_object::get_full_name(). 
-A set of scope is represented as a regular expression. 
-For simplicity, a set of strings can be said to be a set of scope (For example regular expressions like tb_top\.env\.agent_o.* that involve strings tb_top.env.agent_o.mon and tb_top.env.agent_o.drv etc). 
-There can be an ‘N’ set of strings (scope) in the testbench hierarchy. 
-Precedence variable is associate precedence of resource w.r.t. other resources when scope and name match for the resource on looking up in the database. 
-The variable default_precedence is used to set the default precedence value initially i.e. 1000. 
-It is allowed to change the precedence value. When two resources have the same precedence, the first resource found has a priority.
  
Resource database organization :
-The resource database is also known as the resource pool.  
-The resource database consists of a pair of associative array names as ‘name table’ and ‘type table’. 
-The ‘name table’ and ‘type table’ are alternatively known as ‘name map’ and ‘type map’. 
-The resource is stored in the ‘name table’ by name and in the ‘type table’ by type handle. 
-Both the name and queue table has a queue associated with them.
-If more than one resource has the same name or type, it is stored in the corresponding queue.

