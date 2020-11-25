// data bus for cache 2a

`timescale 1ns / 1ps
`include "cache_2a.v"
`include "memory.v"

module main_2a(
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
  wire [31:0] memAddress;

  cache_2a cache(
    .isRead (isRead),
    .address (address),
    .writeData (writeData),
    .readData (readData),
    .isHit (isHit),
    .isMemRead (isMemRead),
    .memWriteData (memWriteData),
    .isLock (isLock),
    .memAddress (memAddress),
    .memReadData (memReadData)
  );

  memory mem(
    .isMemRead (isMemRead),
    .isLock (isLock),
    .address (memAddress),
    .writeData (memWriteData),
    .readData (memReadData)
  );

endmodule
