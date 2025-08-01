UVM Queue Concept Understanding:
-The uvm_queue class builds a dynamic queue that to be allotted on-demand basis and passed by reference.
-uvm_queue class declaration:   class uvm_queue #( type T = int ) extends uvm_object

uvm_queue class Methods :

  Methods                                                           Description

    function new ( string name = “” )                               Creates a new queue for the given name  
    static function T get_global ( int index )                      Returns the specified item instance from the global item queue. 
    static function this_type get_global_queue ()                  Returns the singleton global queue for the item of type T.
    virtual function int size ()                                   Returns size of the queue i.e. stored number of items in the queue.  

    virtual function void insert ( int index, T item )             Inserts the item at the given index.  
    virtual function void delete ( int index = -1 )               Removes the item from the given index. 
                                                                If an index is not provided, complete queue content will be deleted 
      
    virtual function T get ( int index )                         Returns the item at the given index.

    virtual function void push_back( T item )                  Inserts the given item at the back of the queue.

    virtual function void push_front( T item )                 Inserts the given item at the front of the queue.

    virtual function T pop_back()                            Returns the last element in the queue or null if the queue is empty.

      virtual function T pop_front()                          Returns the first element in the queue or null if the queue is empty.  
