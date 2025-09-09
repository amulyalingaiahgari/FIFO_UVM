import uvm_pkg ::*;

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  fifo_env env;
  virtual fifo_interface vif;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);

    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not found")

      uvm_config_db#(virtual fifo_interface.drv)::set(this, "env.agent*", "vif", vif);
      uvm_config_db#(virtual fifo_interface.mon)::set(this, "env.agent*", "vif", vif);
  endfunction

  virtual task run_phase(uvm_phase phase);
    basic_test_seq seq;
    phase.raise_objection(this);
    seq = basic_test_seq::type_id::create("seq");
    if(seq == null) begin
      `uvm_fatal("TEST", "Failed to create sequence")
    end
    seq.start(env.agent.sequencer);

    #100;
    phase.drop_objection(this);
  endtask
endclass
