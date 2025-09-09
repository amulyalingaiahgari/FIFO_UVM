import uvm_pkg::*;

class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  virtual fifo_interface.mon vif;
  uvm_analysis_port #(fifo_transaction) mon_aport;

  function new(string name="fifo_monitor", uvm_component parent=null);
    super.new(name, parent);
    mon_aport = new("mon_aport", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_interface.mon)::get(this, "", "vif", vif) )
      `uvm_fatal("NO_VIF", "virtual interface not found")
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_transaction tr;
    forever begin
      @(vif.monitor_cb);
      tr = fifo_transaction::type_id::create("tr");
      tr.rst=vif.monitor_cb.rst;
      tr.wr_en=vif.monitor_cb.wr_en;
      tr.rd_en=vif.monitor_cb.rd_en;
      tr.data_in=vif.monitor_cb.data_in;
      tr.data_out=vif.monitor_cb.data_out;
      tr.empty=vif.monitor_cb.empty;
      tr.full=vif.monitor_cb.full;
      
      `uvm_info("MONITOR", $sformatf("rst=%b, wr_en=%b, rd_en=%b, data_in=%h, data_out=sh, empty=%b, full=%b",tr.rst, tr.wr_en, tr.rd_en, tr.data_in, tr.data_out, tr.empty, tr.full), UVM_HIGH)
      mon_aport.write(tr);
    end
  endtask
endclass
