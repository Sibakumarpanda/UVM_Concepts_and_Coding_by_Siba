UVM Pool Concept Understanding:

-The uvm_pool is a parameterized class that implements a pool data structure same as System Verilog associative array and it can be allocated based on demand. 
-The items in the pool can be shared across different verification components as pass by reference. 
-On copying the uvm_pool object, it copies the class handle instead of copying an entire associative array.
-uvm_pool class declaration:  class uvm_pool # (type KEY = int, T = uvm_void) extends uvm_object

uvm_pool class Methods :
  
  Methods                                                            Description

  function new ( string name = “” )                                  Creates pool for the given name 

  static function T get_global ( KEY key )                          Returns the specified item instance from the global item pool.  

  static function this_type get_global_pool ()                     Returns the singleton global pool for the item of type T.  

  virtual function int num ()                                     Returns the total number of items in the pool for unique keys 

  virtual function void add ( KEY key, T item )                  Adds given item for the given key as a (key, item) pair. 
                                                                 If an item exists already for the given key, the previous item is overwritten with the new item.  

  virtual function T get ( KEY key )      
                                                                     Returns the item for the given key. 
                                                                     If no item exists by that key, it creates a new item and returns the same for that key.  

  virtual function void delete ( KEY key ) Removes the item from the pool for the given key.

  virtual function int exists ( KEY key ) Returns 1 if an item exists in the pool for the given key otherwise, it returns 0.

  virtual function int next ( ref KEY key ) If the next key is found, then the function returns 1, and the key is updated with that key.

                                            If the input key is the last key in the pool, then the function returns 0, and the key is left unchanged.  

  virtual function int prev ( ref KEY key )- If the previous key is found, then the function returns 1, and the key is updated with that key.

                                               If the input key is the first key in the pool, then the function returns 0, and the key is left unchanged

  virtual function int first ( ref KEY key )- Returns the key of the first item as a key stored in the pool if the pool is not empty and 1 is returned.
                                                The key is unchanged if the pool is empty and 0 is returned.

  virtual function int last ( ref KEY key )-Returns the key of the last item as a key stored in the pool if the pool is not empty and 1 is returned

                                            The key is unchanged if the pool is empty and 0 is returned                                                

                                                                       
