// Module      : sync_w2r
// Description : Synchronize Write Pointer into Read Clock Domain
// Author      : Snigdha Bhardwaj


module sync_w2r #(
    parameter ADDR_WIDTH = 4
)(
    // Inputs portss
    input rd_clk,
    input rst_n,
    input [ADDR_WIDTH:0] wptr_gray,

    // Outputportss
    output [ADDR_WIDTH:0] wptr_gray_sync
);

    
// Synchronizer Registers

reg [ADDR_WIDTH:0] sync_ff1;
reg [ADDR_WIDTH:0] sync_ff2;


// Output Assignment

assign wptr_gray_sync = sync_ff2;

// Two-Flip-Flop Synchronizer

always @(posedge rd_clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_ff1 <= '0;
        sync_ff2 <= '0;
    end
    else begin
        sync_ff1 <= wptr_gray;
        sync_ff2 <= sync_ff1;
    end
end

endmodule