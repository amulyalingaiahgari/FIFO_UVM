`include "uvm_macros.svh"
import uvm_pkg ::*;

module tb_top();
  reg clk;

  initial begin
    clk=0;
    forever
      #5 clk = ~clk;
  end

  fifo_interface intf(clk);

  fifo #(.width(8), .depth(8)) dut(.clk(intf.clk), .rst(intf.rst), .wr_en(intf.wr_en), .data_in(intf.data_in), .rd_en(intf.rd_en), .data_out(intf.data_out), .full(intf.full), .empty(intf.empty) );

  initial begin
    uvm_config_db#(virtual fifo_interface)::set(null,"*", "vif", intf);
    run_test("base_test");
  end

endmodule
