// main memory

`timescale 1ns / 1ps

module memory(
  input isMemRead,
  input isLock,
  input [9:0] address,
  input [127:0] writeData,
  input [3:0] isDirty,
  output reg [127:0] readData
);

  reg [31:0] mem [1023:0];

  integer i;
  initial begin
    for(i=0; i<1024; i=i+1) begin
      mem[i] = 0;
    end
    // TODO: add initial data here
    mem[0]   = 32'b00000000000000000011110011000011; // 0x3cc3
    mem[512] = 32'b00000000000000000000110011001100; // 0xccc
    mem[768] = 32'b00000000000000000000000011000011; // 0xc3
  end

  always @(*) begin
    if (isLock == 0) begin
      if (isMemRead == 1) begin // read
        readData = {mem[address],mem[address+1],mem[address+2],mem[address+3]};
      end else begin // write
        if(isDirty[0]) mem[address]   = writeData[31:0];
        if(isDirty[1]) mem[address+1] = writeData[31:0];
        if(isDirty[2]) mem[address+2] = writeData[31:0];
        if(isDirty[3]) mem[address+3] = writeData[31:0];
      end
    end
  end

endmodule
