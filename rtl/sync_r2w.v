// Module      : sync_r2w
// Description : Synchronize Read Pointer into Write Clock Domain
// Author      : Snigdha Bhardwaj

module sync_r2w #(
    parameter ADDR_WIDTH = 4
)(
    //ports declaration
input wr_clk,
input rst_n,
input [ADDR_WIDTH:0]rptr_gray,

output [ADDR_WIDTH:0]rptr_gray_sync

);

reg [ADDR_WIDTH:0] sync_ff1;
reg [ADDR_WIDTH:0] sync_ff2;

// Output Assignment

assign rptr_gray_sync = sync_ff2;


// Two-Flip-Flop Synchronizer


always @(posedge wr_clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_ff1 <= '0;
        sync_ff2 <= '0;
    end
    else begin
        sync_ff1 <= rptr_gray;
        sync_ff2 <= sync_ff1;
    end
end

endmodule