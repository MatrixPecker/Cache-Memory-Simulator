# Cache Memory Simulator
*A Cache Memory Simulator that supports write through / write back and Direct mapped / 2-way associative. Several block replacement algorithms are also implemented (in C).*

## Overview

This project uses `verilog` to simulate the datapath between CPU, Cache and Main Memory. It uses `c` to simulate a set of block-replacement algorithms.

<center><img src="asset/cache_overview.png" style="zoom:80%;" />Overview of Cache memory datapath [1]</center>


## Encoding and Standard

### Address Encoding

<center><img src="asset/direct_addr.png" style="zoom:80%;" />Address Encoding for direct-mapped cache</center>

<center><img src="asset/2way_addr.png" style="zoom:80%;" />Address Encoding for 2-way associative cache</center>

### Block Encoding

<center><img src="asset/direct_block.png" style="zoom:80%;" />Block Encoding for direct-mapped cache</center>

<center><img src="asset/2way_block.png" style="zoom:80%;" />Block Encoding for 2-way associative cache</center>

### Simulation Standard
The verilog program is simulated with `xvlog`. The board id is `XC7A35TCPG236-1`.

## Block Replacement Algorithm

| Abbr.         | Algorithm                                       | Comment [^2]                                             |
| ------------- | ----------------------------------------------- | -------------------------------------------------------- |
| Optimal       | Optimal Block Replacement Algorithm             | Not implementable in practice, but useful for evaluation |
| NRU           | Not Recently Used Block Replacement Algorithm   | crude approximation of LRU                               |
| FIFO          | First-In, First-Out Block Replacement Algorithm | might throw out important blocks                         |
| Second Chance | Second-Chance Block Replacement Algorithm       | big improvement over FIFO                                |
| Clock         | Clock Block Replacement Algorithm               | realistic                                                |
| LRU           | Least Recently Used Block Replacement Algorithm | excellent, but difficult to implement in practice        |
| MRU           | Most Recently Used Block Replacement Algorithm  | difficult to implement in practice                       |
| NFU           | Not Frequently Used Block Replacement Algorithm | crude approximation to LRU                               |
| Aging         | Aging Block Replacement Algorithm               | efficient algorithm that approximates LRU well           |
| Working Set   | Working Set Block Replacement Algorithm         | expensive to implement                                   |
| WSClock       | WSClock Block Replacement Algorithm             | excellent and efficient                                  |

## Reference
[^1]: VE370 Project Manual, *Professor G. Zheng*, UM-SJTU JI.
[^2]: Modern Operating System (4th Edition), *Andrew S. Tanenbaum*, Amsterdam, The Netherlands.