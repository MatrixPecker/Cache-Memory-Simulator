// main memory

`timescale 1ns / 1ps

module memory(
  input isMemRead,
  input isLock,
  input [9:0] address, // byte address
  input [127:0] writeData,
  output reg [127:0] readData
);

  reg [31:0] mem [1023:0];

  integer i;
  initial begin
    for(i=0; i<1024; i=i+1) begin
      mem[i] = 0;
    end
    // NOTE: add initial data here
    mem[0]   = 32'b00000000000000000011110011000011; // 0x3cc3
    mem[8'b10000000] = 32'b00000000000000000000110011001100; // 0xccc
    mem[8'b11000000] = 32'b00000000000000000000000011000011; // 0xc3
  end

  always @(*) begin
    if (isLock == 0) begin
      if (isMemRead == 1) begin // read
        readData = {mem[{address[9:4],2'b00}],mem[{address[9:4],2'b01}],mem[{address[9:4],2'b10}],mem[{address[9:4],2'b11}]};
      end else begin // write
        mem[{address[9:4],2'b00}] = writeData[127:96];
        mem[{address[9:4],2'b01}] = writeData[95:64];
        mem[{address[9:4],2'b10}] = writeData[63:32];
        mem[{address[9:4],2'b11}] = writeData[31:0];
      end
    end
  end

endmodule
