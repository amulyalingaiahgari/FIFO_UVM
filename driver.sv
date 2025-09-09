import uvm_pkg::*; 

class fifo_driver extends uvm_driver #(fifo_transaction);
  `uvm_component_utils(fifo_driver)

  virtual fifo_interface.drv vif;
  fifo_transaction tr;

  function new(string name = "fifo_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db#(virtual fifo_interface.drv)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not found")
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(tr);
      drive_transaction(tr);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_transaction(fifo_transaction tr);
    @(vif.driver_cb);
    vif.driver_cb.rst <= tr.rst;
    vif.driver_cb.wr_en <= tr.wr_en;
    vif.driver_cb.rd_en <= tr.rd_en;
    vif.driver_cb.data_in <= tr.data_in;
  endtask
endclass
