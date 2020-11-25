// cache 1a (write through + 2-way associative)

`timescale 1ns / 1ps

module cache_1b(
  // with cpu
  input isRead,
  input [9:0] address,
  input [31:0] writeData,
  output reg [31:0] readData,
  output reg isHit,
  // with main memory
  output reg isMemRead,
  output reg [127:0] memWriteData,
  output reg isLock,
  output reg [3:0] isDirty,  
  input [127:0] memReadData
);

  reg [156:0] block [3:0]; // FIXME

  integer i;
  initial begin
    for (i=0; i<4; i=i+1) begin
      block[i] = 0;
    end
    isMemRead = 1;
    memWriteData = 0;
    isLock = 1;
  end

  reg [26:0] tag; // FIXME
  reg index; // FIXME
  reg realIndex;
  reg [1:0] wordOffset;
  always @(*) begin
    /* parse the address */
    tag = {0,address[9:5]};
    index = address [4];
    wordOffset = address[3:2];

    if (isRead == 1) begin // read
      /* check the cache block */
      isMemRead = 1;
      if (block[2*index][156]==1 && block[2*index][154:128]==tag) begin // hit
        realIndex = 2*index;
        isHit = 1;
        block[2*index][155]=1; // recently accessed
        block[2*index+1][155]=0; // otherwise
      end else if(block[2*index+1][156]==1 && block[2*index+1][154:128]==tag) begin // hit
        realIndex = 2*index+1;
        isHit = 1;
        block[2*index+1][155]=1;
        block[2*index][155]=0;
      end else begin // miss
        /* call main memory */
        isHit = 0;
        isLock = 0;
        #1; // wait for main memory to respond
        isLock = 1;
        /* locate and update the block with LRU algorithm */
        if(block[2*index][155]==0) begin
          realIndex=2*index;
          block[2*index][155]=1;
          block[2*index+1][155]=0;
        end else begin
          realIndex=2*index+1;
          block[2*index+1][155]=1;
          block[2*index][155]=0;
        end
        block[realIndex][156] = 1;
        block[realIndex][154:128] = tag;
        block[realIndex][127:0] = memReadData;
      end
      /* update the output */
      case(wordOffset)
        2'b00: readData = block[realIndex][127:96];
        2'b01: readData = block[realIndex][95:64];
        2'b10: readData = block[realIndex][63:32];
        2'b11: readData = block[realIndex][31:0];
      endcase
    end else begin // write
      isMemRead = 0;
      // readData = 0; // do not clear readData if the mode is switched to write
      if (block[2*index][156]==1 && block[2*index][154:128]==tag) begin // hit
        realIndex = 2*index;
        isHit = 1;
        case(wordOffset)
          2'b00: block[realIndex][127:96] = writeData;
          2'b01: block[realIndex][95:64] = writeData;
          2'b10: block[realIndex][63:32] = writeData;
          2'b11: block[realIndex][31:0] = writeData;
        endcase
      end else if (block[2*index+1][156]==1 && block[2*index+1][154:128]==tag) begin // hit
        realIndex = 2*index+1;
        isHit = 1;
        case(wordOffset)
          2'b00: block[realIndex][127:96] = writeData;
          2'b01: block[realIndex][95:64] = writeData;
          2'b10: block[realIndex][63:32] = writeData;
          2'b11: block[realIndex][31:0] = writeData;
        endcase
      end else begin
        isHit = 0;
      end
        memWriteData = writeData; // though 128 bits are occupied, only the last 32 bits are effective.
        case(address[3:2])
          2'b00: isDirty=4'b0001;
          2'b01: isDirty=4'b0010;
          2'b10: isDirty=4'b0100;
          2'b11: isDirty=4'b1000;
        endcase
        isLock = 0;
        #1;
        isLock = 1;
    end
  end

endmodule
