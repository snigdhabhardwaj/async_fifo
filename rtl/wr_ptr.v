// module      : wr_ptr
// description : write pointer logic for asynchronous FIFO
// author      : snigdha bhardwaj
module wr_ptr #(
    parameter ADDR_WIDTH = 4
)(

    input wr_clk,
    input rst_n,
    input wr_en,
    input full,

    output [ADDR_WIDTH-1:0] wr_addr,
    output [ADDR_WIDTH:0] wr_gray
);

// Internal Signals

// Current write pointer 
reg  [ADDR_WIDTH:0] wptr_bin;

// Next write pointer (comb logic)
wire [ADDR_WIDTH:0] wptr_bin_next;

// Current write pointer
reg  [ADDR_WIDTH:0] wptr_gray;

// Next write pointer (from write pointer next)
wire [ADDR_WIDTH:0] wptr_gray_next;

// Output Assignments 
assign wr_addr = wptr_bin[ADDR_WIDTH-1:0];
assign wr_gray = wptr_gray;

//pointer logic 
assign wptr_bin_next = (wr_en && !full) ? (wptr_bin + 1'b1) : wptr_bin;
assign wptr_gray_next = wptr_bin_next ^ (wptr_bin_next >> 1);


always @(posedge wr_clk or negedge rst_n) begin
    if (!rst_n) begin
        wptr_bin  <= '0;
        wptr_gray <= '0;
    end
    else begin
        wptr_bin  <= wptr_bin_next;
        wptr_gray <= wptr_gray_next;
    end
end

endmodule