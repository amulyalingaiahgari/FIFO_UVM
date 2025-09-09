import uvm_pkg::*;

class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  uvm_analysis_export #(fifo_transaction) sb_export;
  uvm_tlm_analysis_fifo #(fifo_transaction) sb_fifo;

  logic [7:0]expected_data[$];
  int write_count=0;
  int read_count=0;

  function new(string name = "fifo_scoreboard", uvm_component parent=null);
    super.new(name, parent);
    sb_export=new("sb_expert", this);
    sb_fifo=new("sb_fifo", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    sb_export.connect(sb_fifo.analysis_export);
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_transaction tr;
    forever begin
      sb_fifo.get(tr);
      #1;
      check_transaction(tr);
    end
  endtask

  virtual function void check_transaction(fifo_transaction tr);
    if(tr.rst) begin
      expected_data.delete();
      write_count=0;
      read_count=0;
      `uvm_info("SCOREBOARD", "Reset detected - Clearing expected data", UVM_LOW)
    end
    else begin
      `uvm_info("SCOREBOARD", $sformatf("Processing: wr_en=%b, rd_en=%b, data_in=4h, data_out=h, empty=%b, full=$b",tr.wr en, tr.rd en, tr.data in,tr.data out, tr.empty, tr.full), UVM MEDIUM)
      
      if(tr.wr_en && !tr.full) begin
        expected_data.push_back(tr.data_in);
        write_count++;
        `uvm_info("SCOREBOARD", $sformatf("write data: $0h, Queue size:%0d", tr.data_in, expected_data.size()), UVM_LOW)
      end

      if(tr.rd_en && !tr.empty) begin
        if(expected_data.size() > 0) begin
          logic [7:0] expected = expected_data.pop_front();
          if(tr.data_out !== expected) begin
            `uvm_error("SCOREBOARD", $sformatf("Data mistach! Expected: %0h, Got:%oh(READ count:%0d)",expected, tr.data_out, read_count))
          end
          else begin
            `uvm_info("SCOREBOARD", $sformatf("Read data matched:%0h",tr.data_out), UVM_LOW)
          end
          read_count++;
        end
        else begin
          `uvm_error("SCOREBOARD", $sformatf("Read unexpected data:%0h(no expected data in queue)", tr.data_out) )
        end
      end
      if(expected_data.size()==0 && !tr.empty)
        `uvm_warning("SCOREBOARD", $sformatf("FIFO should be empty but empty=%b(expected size=0)", tr.empty))
        if(expected_data.size()==8 && !tr.full)
          `uvm_warning("SCOREBOARD", $sformatf("FIFO should be full but full=%b(expected size=%0d)",tr.full, expected_data. size() ) )
    end
  endfunction
endclass
