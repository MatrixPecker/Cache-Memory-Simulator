// main memory

`timescale 1ns / 1ps

module memory(
  input isMemRead,
  input isLock,
  input [9:0] address,
  input [127:0] writeData,
  output reg [127:0] readData
);

  reg [31:0] mem [1023:0];

  integer i;
  initial begin
    for(i=0; i<1024; i=i+1) begin
      mem[i] = 0;
    end
    // TODO: add initial data here
    mem[0]   = 32'b00000000000000000011110011000011;
    mem[768] = 32'b00000000000000000000000011000011;
  end

  always @(*) begin
    if (isLock == 0) begin
      if (isMemRead == 1) begin // read
        readData = {mem[address],mem[address+1],mem[address+2],mem[address+3]};
      end else begin // write
        case (address[3:2])
          2'b00: mem[address]   = writeData[31:0];
          2'b01: mem[address+1] = writeData[31:0];
          2'b10: mem[address+2] = writeData[31:0];
          2'b11: mem[address+3] = writeData[31:0];
        endcase
      end
    end
  end

endmodule
