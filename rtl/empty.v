
// Module      : empty
// Description : Empty Flag Generation Logic for Asynchronous FIFO
// Author      : Snigdha Bhardwaj

module empty #(
    parameter ADDR_WIDTH = 4
)(
    // input
    input rd_clk,
    input rst_n,
    input  [ADDR_WIDTH:0] rptr_gray_next,
    input  [ADDR_WIDTH:0] wptr_gray_sync,

    // output port
    output reg empty
);

// Empty Detection Logic
wire empty_next;

assign empty_next = (rptr_gray_next == wptr_gray_sync);

// Sequential Logic

always @(posedge rd_clk or negedge rst_n) begin
    if (!rst_n)
        empty <= 1'b1;
    else
        empty <= empty_next;
end

endmodule