// Module      : async_fifo
// Description : top level async fifo
// Author      : Snigdha Bhardwaj

module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    // write interface
    input                       wr_clk,
    input                       rst_n,
    input                       wr_en,
    input  [DATA_WIDTH-1:0]     wr_data,
    output                      full,

    // read interface
    input                       rd_clk,
    input                       rd_en,
    output [DATA_WIDTH-1:0]     rd_data,
    output                      empty
);

// Internal Signals

// Memory Address
wire [ADDR_WIDTH-1:0] wr_addr;
wire [ADDR_WIDTH-1:0] rd_addr;

// Gray Pointers
wire [ADDR_WIDTH:0] wptr_gray;
wire [ADDR_WIDTH:0] rptr_gray;

// Next Gray Pointers
wire [ADDR_WIDTH:0] wptr_gray_next;
wire [ADDR_WIDTH:0] rptr_gray_next;

// Synchronized Gray Pointers
wire [ADDR_WIDTH:0] wptr_gray_sync;
wire [ADDR_WIDTH:0] rptr_gray_sync;

// FIFO Memory

fifo_mem #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) u_fifo_mem (

    .wr_clk (wr_clk),
    .wr_en  (wr_en),
    .wr_addr(wr_addr),
    .wr_data(wr_data),

    .rd_clk (rd_clk),
    .rd_en  (rd_en),
    .rd_addr(rd_addr),
    .rd_data(rd_data)
);

// Write Pointer
wr_ptr #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_wr_ptr (

    .wr_clk(wr_clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .full(full),

    .wr_addr(wr_addr),
    .wr_gray(wptr_gray),
    .wptr_gray_next(wptr_gray_next)
);
// Read Pointer

rd_ptr #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_rd_ptr (

    .rd_clk(rd_clk),
    .rst_n(rst_n),
    .rd_en(rd_en),
    .empty(empty),

    .rd_addr(rd_addr),
    .rd_gray(rptr_gray),
    .rptr_gray_next(rptr_gray_next)
);

// Read Pointer Synchronizer

sync_r2w #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_sync_r2w (

    .wr_clk(wr_clk),
    .rst_n(rst_n),
    .rptr_gray(rptr_gray),

    .rptr_gray_sync(rptr_gray_sync)
);

// Write Pointer Synchronizer

sync_w2r #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_sync_w2r (

    .rd_clk(rd_clk),
    .rst_n(rst_n),
    .wptr_gray(wptr_gray),

    .wptr_gray_sync(wptr_gray_sync)
);
// Full Logic

full #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_full (

    .wr_clk(wr_clk),
    .rst_n(rst_n),
    .wptr_gray_next(wptr_gray_next),
    .rptr_gray_sync(rptr_gray_sync),

    .full(full)
);
// Empty Logic

empty #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_empty (

    .rd_clk(rd_clk),
    .rst_n(rst_n),
    .rptr_gray_next(rptr_gray_next),
    .wptr_gray_sync(wptr_gray_sync),

    .empty(empty)
);

endmodule