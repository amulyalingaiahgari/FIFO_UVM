interface fifo_interface(input clk);
  logic rst, wr_en, rd_en;
  logic [7:0] data_in, data_out;
  logic full, empty;

  clocking driver_cb @(posedge clk);
    output rst, wr_en, rd_en, data_in;
    input data_out, empty, full;
  endclocking

  clocking monitor_cb @(posedge clk);
    input rst, wr_en, rd_en, data_in, data_out, empty, full;
  endclocking

  modport drv (clocking driver_cb, input clk);
  modport mon (clocking monitor_cb, input clk);
endinterface
