//module:fifo memory
//description:dual port memory for async fifo
//author; snigdha bhardwaj

module fifo_mem #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
)(
  //PARAMETRIZED MODULE 2^4=16 LOCATIONS per 8 bits = 256 bit storage
  //PORT DECLARATION
  
  //WRITE DOMAIN
  input   wr_clk,
    input  wr_en,
    input  [ADDR_WIDTH-1:0] wr_addr,
    input  [DATA_WIDTH-1:0]wr_data,

    // READ DOMAIN
    input rd_clk,
    input rd_en,
  input  [ADDR_WIDTH-1:0] rd_addr,
    output reg [DATA_WIDTH-1:0] rd_data
);

  // INTERNAL MEMORAY ARRAY...REG(STRORES VALUE)...EACH LOCATION STORES 8 BITS OF DATA...mem: ARRAY NAME...BITWISE LEFT SHIFT 1 BY 4 POSTIONS MAKES 0001 TO 10000(16)..mem [0:15]
  
reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

  //this is fifo memory (storage)
  
  //write logic

  always @(posedge wr_clk) begin
    if (wr_en)
        mem[wr_addr] <= wr_data;
end
//at every pos edge of wr clk we check if wr is enabled that means logic high if it is then we write the data into memory as speciffed by the address


//read logic

always @(posedge rd_clk) begin
    if (rd_en)
        rd_data <= mem[rd_addr]; //Take the contents stored at rd_addr and place it on the output register rd_data
end
endmodule
