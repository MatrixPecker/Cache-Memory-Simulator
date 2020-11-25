// data bus for cache 1b

`timescale 1ns / 1ps
`include "cache_1b.v"
`include "memory.v"

module main_1b(
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
  wire [3:0] isDirty; 

  cache_1b cache(
    .isRead (isRead),
    .address (address),
    .writeData (writeData),
    .readData (readData),
    .isHit (isHit),
    .isMemRead (isMemRead),
    .memWriteData (memWriteData),
    .isLock (isLock),
    .isDirty (isDirty),    
    .memReadData (memReadData)
  );

  memory mem(
    .isMemRead (isMemRead),
    .isLock (isLock),
    .address (address),
    .writeData (memWriteData),
    .isDirty (isDirty),    
    .readData (memReadData)
  );

endmodule
