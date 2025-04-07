/*Some Important Key Points:
Front Door Access: This is the standard way to access registers through the bus interface. 
Means using the standard access mechanism external to the DUT to read or write to a register. This usually involves sequences of time-consuming transactions on a bus interface. 
Back Door Access: This allows direct access to the register without going through the bus interface. It will be done through hierarchiacal Path.
Means accessing a register directly via hierarchical reference or outside the language via .If we want to acess any register , then we need to have full HDL / RTL Hierarchical path */

//Sequence Template for write read test (write in to register through Front door & Read from register will be through Back door Acess)

class my_reg_sequence extends uvm_sequence;
  `uvm_object_utils(my_reg_sequence)

  uvm_reg_model my_reg_model;
  uvm_reg my_reg;
  uvm_reg_data_t write_data;
  uvm_reg_data_t read_data;

  function new(string name = "my_reg_sequence");
    super.new(name);
  endfunction

  virtual task body();
    // Front-door write
    uvm_status_e status;
    uvm_reg_data_t write_data = 'hABCD; // Example data to write

    // Write to the register using front-door access
    my_reg.write(status, write_data, .parent(this));

    if (status != UVM_IS_OK) begin
      `uvm_error("WRITE_ERROR", "Failed to write to register")
    end

    // Back-door read
    my_reg.read(status, read_data, .parent(this), .map(null), .bd_access(UVM_BACKDOOR));

    if (status != UVM_IS_OK) begin
      `uvm_error("READ_ERROR", "Failed to read from register")
    end

    `uvm_info("READ_DATA", $sformatf("Read data: %0h", read_data), UVM_MEDIUM)
  endtask
endclass

