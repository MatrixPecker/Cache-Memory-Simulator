// data bus for cache 1a

`timescale 1ns / 1ps
`include "cache_1a.v"
`include "memory.v"

module main_1a(
  input isRead,
  input [9:0] address,
  input [31:0] writeData,
  output [31:0] readData,
  output isHit
);

  wire isMemRead;
  wire isLock;
  wire [127:0] memWriteData;
  wire [127:0] memReadData;

  cache_1a cache(
    .isRead (isRead),
    .address (address),
    .writeData (writeData),
    .readData (readData),
    .isHit (isHit),
    .isMemRead (isMemRead),
    .memWriteData (memWriteData),
    .isLock (isLock),
    .memReadData (memReadData)
  );

  memory mem(
    .isMemRead (isMemRead),
    .isLock (isLock),
    .address (address),
    .writeData (memWriteData),
    .readData (memReadData)
  );

endmodule
