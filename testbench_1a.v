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

  main_1a uut(
    .isRead (isRead),
    .address (address),
    .writeData (writeData),
    .readData (readData),
    .isHit (isHit)
  );

  initial begin
    /* Time 0: init*/
    currTime = 0; isRead = 1; address = 0; writeData = 0;
    /* Time 10: miss, readData=0x3cc3 */
    #10 isRead = 1; address = 10'b0000000000;
    /* Time 20: hit, writeData=0xff */
    #10 isRead = 0; address = 10'b0000000000; writeData = 8'b11111111;
    /* Time 30: hit, readData=0xff */
    #10 isRead = 1; address = 10'b0000000000;
    // Here in the main memory, the first word should be 0x000000ff
    
    /* Time 40: miss, readData=0xccc */
    #10 isRead = 1; address = 10'b1000000000;
    /* Time 50: miss, readData=0xff [direct-mapped feature] */
    #10 isRead = 1; address = 10'b0000000000; 
    /* Time 60: miss, readData=0xc3 */
    #10 isRead = 1; address = 10'b1100000000;
    /* Time 70: miss, readData=0xccc */
    #10 isRead = 1; address = 10'b1000000000;
    /* Time 100: stop*/
    #30 $stop;

    // Here in the main memory, the first word should still be 0x000000ff
  end

  always #10 begin
    $display("--------------------------- Time: %d ---------------------------",currTime);
    $display("isRead: %d, address: 0x%H, isHit: %d",isRead, address, isHit);
    $display("writeData: 0x%H, readData: 0x%H",writeData, readData);
    currTime = currTime + 10;
  end

endmodule
