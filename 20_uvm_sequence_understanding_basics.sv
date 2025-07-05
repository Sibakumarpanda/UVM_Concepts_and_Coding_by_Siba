
UVM Sequence understanding:
-UVM sequence is a container that holds data items (uvm_sequence_items) which are sent to the driver via the sequencer.
-Note: uvm_sequence class is parameterized with uvm_sequence_item.
-uvm_sequence class declaration: virtual class uvm_seqence #( type REQ = uvm_sequence_item, type RSP = REQ) extends uvm_sequence_base
