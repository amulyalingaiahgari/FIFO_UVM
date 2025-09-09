module fifo #(parameter width=8, parameter depth=8) (
    output reg [width-1:0] data_out,
    output reg empty,
    output reg full,
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [width-1:0] data_in
);

// Internal signals
reg [width-1:0] fifo_mem [0:depth-1];
reg [3:0] wr_ptr;  // Need 4 bits for depth=8 (0-7 + wrap)
reg [3:0] rd_ptr;  // Need 4 bits for depth=8 (0-7 + wrap)
reg [3:0] count;   // Number of elements in FIFO

// FIFO control logic
always @(posedge clk) begin
  if (rst) begin
    // Reset everything
    wr_ptr <= 0;
    rd_ptr <= 0;
    count <= 0;
    full <= 0;
    empty <= 1;
    data_out <= 0;
    
    // Optional: Clear memory
    for (int i = 0; i < depth; i++) begin
      fifo_mem[i] <= 0;
    end
  end
  else begin
    // Handle write operation
    if (wr_en && !full) begin
      fifo_mem[wr_ptr[2:0]] <= data_in;  // Using lower 3 bits for memory index
      wr_ptr <= wr_ptr + 1;
      if (!(rd_en && !empty)) begin  // If not simultaneous read
        count <= count + 1;
      end
    end
    
    // Handle read operation
    if (rd_en && !empty) begin
      data_out <= fifo_mem[rd_ptr[2:0]];  // Using lower 3 bits for memory index
      rd_ptr <= rd_ptr + 1;
      if (!(wr_en && !full)) begin  // If not simultaneous write
        count <= count - 1;
      end
    end
    
    // Handle simultaneous read and write
    if (wr_en && rd_en && !full && !empty) begin
      count <= count;  // Count remains the same
    end
    
    // Update status flags
    full <= (count == depth);
    empty <= (count == 0);
  end
end
endmodule
