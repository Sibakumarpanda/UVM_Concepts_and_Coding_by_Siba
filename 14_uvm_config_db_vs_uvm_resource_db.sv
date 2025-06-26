
uvm_config_db Usage:
 1.Pass configurations variables/ classes down the hierarchy in the testbench .
 2.Pass virtual interface from top hierarchy to the components down in the testbench hierarchy.
  
Difference between uvm_config_db and uvm_resource_db:
 1. Although both classes provide a convenience layer on top of the uvm resource facility, uvm_config_db is derived from uvm_resource_db. This adds up additional methods on top of uvm_resource_db methods.
 2. With respect to component hierarchy, the uvm_config_db  has an argument as a context that has the type of uvm_component and instance name as a string that provides more flexibility as compared to uvm_resource that has two strings scope and name. 
    Since component hierarchy is mentioned in the context, it provides more control over the hierarchical path.
    The context = this argument provides a relative path from the component. 
    The context = null provides an absolute path which means there is no hierarchical path above.
 3. Thus, it is recommended to use uvm_config_db always.
