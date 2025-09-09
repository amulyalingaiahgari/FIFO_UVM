import uvm_pkg::*;

class fifo_transaction extends uvm_sequence_item;

  `uvm_object_utils_begin(fifo_transaction)
  `uvm_field_int(rst, UVM_ALL_ON)
  `uvm_field_int(wr_en, UVM_ALL_ON)
  `uvm_field_int(rd_en, UVM_ALL_ON)
  `uvm_field_int(data_in, UVM_ALL_ON)
  `uvm_field_int(data_out, UVM_ALL_ON)
  `uvm_field_int(empty, UVM_ALL_ON)
  `uvm_field_int(full, UVM_ALL_ON)
  `uvm_object_utils_end

  rand logic rst;
  rand logic wr_en;
  rand logic rd_en;
  rand logic [7:0]data_in;
  logic [7:0]data_out;
  logic empty;
  logic full;

  function new(string name = "fifo_transaction");
    super.new(name);
  endfunction

  constraint valid_ops {
    wr_en dist {0 := 70, 1 := 30};
    rd_en dist {0 := 70, 1 := 30};
  }
endclass
