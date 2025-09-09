import uvm_pkg::*;
class basic_test_seq extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(basic_test_seq)

  function new(string name="basic_test_seq");
    super.new(name);
  endfunction

  virtual task body();
    fifo_transaction tr;
    `uvm_info("SEQ", "Applying reset", UVM_LOW)
    tr=fifo_transaction::type_id::create("tr");
    tr.rst=1;
    start_item(tr);
    finish_item(tr);
    #20;

    //release reset
    tr=fifo_transaction::type_id::create("tr");
    tr.rst=0;
    tr.wr_en=0;
    tr.rd_en=0;
    start_item(tr);
    finish_item(tr);
    #10;
    
    //write some data to fifo
    `uvm_info("SEQ", "writing data to FIFO", UVM_LOW)
    repeat (10) begin
      tr=fifo_transaction::type_id::create("tr");
      tr.rst=0;
      tr.wr_en=l;
      tr.rd_en=0;
      tr.data_in=$urandom_range(0,255);
      start_item(tr);
      finish_item(tr);
      #10;
    end
    #10;

  /*  //stop writing
    tr=fifo_transaction::type_id::create("tr");
    tr.rst=0;
    tr.wr_en=0;
    tr.rd_en=0;
    start_item(tr);
    finish_item(tr);
    #20; */

    //read some data
    `uvm_info("SEQ","reading data from FIFO", UVM_LOW)
    repeat (10) begin
      tr=fifo_transaction::type_id::create("tr");
      tr.rst=0;
      tr.wr_en=0;
      tr.rd_en=1;
      start_item(tr);
      finish_item(tr);
      #10;
    end

    //stop reading
    tr=fifo_transaction::type_id::create("tr");
    tr.rst=0;
    tr.wr_en=0;
    tr.rd_en=0;
    start_item(tr);
    finish_item(tr);
    #20;
  endtask
endclass
