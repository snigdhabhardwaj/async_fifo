// Module      : full
// Description : Full Flag Generation Logic for Asynchronous FIFO
// Author      : Snigdha Bhardwaj


module full #(
    parameter ADDR_WIDTH = 4
)(
    // Inputs portsss
    input wr_clk,
    input rst_n,
    input  [ADDR_WIDTH:0] wptr_gray_next,
    input  [ADDR_WIDTH:0] rptr_gray_sync,

    // Outputports
    output reg full
);


//full detetc logic

wire full_next;

assign full_next =
    (wptr_gray_next ==
    {~rptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1],
      rptr_gray_sync[ADDR_WIDTH-2:0]});

// Sequential Logic


always @(posedge wr_clk or negedge rst_n) begin
    if (!rst_n)
        full <= 1'b0;
    else
        full <= full_next;
end

endmodule