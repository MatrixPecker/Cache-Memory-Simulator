// testbench for simulation of cache 1a (write through + direct mapped)

`timescale 1ns / 1ps
`include "main_1a.v"

/*
 *
 */
module testbench_1a;

  reg isRead;
  reg [9:0] address;
  reg [31:0] writeData;
  wire [31:0] readData;
  wire isHit;

  integer currTime;
  // reg clk; // FIXME: I believe that clk is only needed for Write Back (recycle dirty)

  main_1a uut(
    .isRead (isRead),
    .address (address),
    .writeData (writeData),
    .readData (readData),
    .isHit (isHit)
  );

  initial begin
    currTime = 0; isRead = 1; address = 0; writeData = 0; // init
    #10 isRead = 1; address = 10'b0000000000; //should miss
    #10 isRead = 0; address = 10'b0000000000; writeData = 8'b11111111; //should hit
    #10 isRead = 1; address = 10'b0000000000; //should hit and read out 0xff
    // FIXME: #10 or #20?
    //here check main memory content, 
    //the first byte should remain 0x00 if it is write-back, 
    //should change to 0xff if it is write-through.
    
    #10 isRead = 1; address = 10'b1000000000; //should miss
    #10 isRead = 1; address = 10'b0000000000; //should hit for 2-way associative, should miss for directly mapped
    
    #10 isRead = 1; address = 10'b1100000000; //should miss
    #10 isRead = 1; address = 10'b1000000000; //should miss both for directly mapped and for 2-way associative (Least-Recently-Used policy)
    
    #30 $stop;
    //here check main memory content, 
    //the first byte should be 0xff
  end

  always #10 begin
    $display("--------------------------- Time: %d ---------------------------",currTime);
    $display("isRead: %d, address: 0x%H, isHit: %d",isRead, address, isHit);
    $display("writeData: 0x%H, readData: 0x%H",writeData, readData);
    currTime = currTime + 10;
  end

endmodule
