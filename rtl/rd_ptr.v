// Module      : rd_ptr
// Description : Read Pointer Logic for Asynchronous FIFO
// Author      : Snigdha Bhardwaj

module rd_ptr #(
    parameter ADDR_WIDTH = 4
)(
    // Inputs port declaration
    input rd_clk,
    input rst_n,
    input rd_en,
    input empty,

    // Outputs port declaredd
    output [ADDR_WIDTH-1:0] rd_addr,
    output [ADDR_WIDTH:0] rd_gray
);

// Internal Signals

// Current Read Pointer 
reg  [ADDR_WIDTH:0] rptr_bin;

// Next Read Pointer 
wire [ADDR_WIDTH:0] rptr_bin_next;

// Current Read Pointer 
reg  [ADDR_WIDTH:0] rptr_gray;

// Next Read Pointer 
wire [ADDR_WIDTH:0] rptr_gray_next;

// Output Assignments

assign rd_addr = rptr_bin[ADDR_WIDTH-1:0];
assign rd_gray = rptr_gray;

// Next Binary Pointer Logic

assign rptr_bin_next = (rd_en && !empty) ? (rptr_bin + 1'b1) : rptr_bin;

// Next Gray Pointer Logic( gray is binary xor binary right shift by 1)

assign rptr_gray_next = rptr_bin_next ^ (rptr_bin_next >> 1);

// Sequential Logic

always @(posedge rd_clk or negedge rst_n) begin
    if (!rst_n) begin
        rptr_bin  <= '0;
        rptr_gray <= '0;
    end
    else begin
        rptr_bin  <= rptr_bin_next;
        rptr_gray <= rptr_gray_next;
    end
end

endmodule