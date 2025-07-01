UVM Driver understanding:
-The driver interacts with DUT. 
-It drives randomized transactions or sequence items to DUT as a pin-level activity using an interface. 
-The driver has to be extended from uvm_component names as uvm_driver. 
-The transaction or sequence items are retrieved from the sequencer and the driver drives them to the design using the interface handle. 
-An interface handle can be retrieved from the configuration database which was already set in the top-level hierarchy.
-The uvm_driver class is a parameterized class of type REQ sequence_item and RSP sequence item.
-RSP sequence item is optional. 
-Usually, the REQ and RSP sequence item has the same class type. They can be different if it is declared specifically.

uvm_driver class declaration:
  
class uvm_driver #( type REQ = uvm_sequence_item, type RSP = REQ ) extends uvm_component  
  
