#!/bin/bash
cd ..

iverilog -g2012 -o Branch_Log/sim -IALU Branch_Log/branch_log.v Branch_Log/branch_log_tb.v
vvp Branch_Log/sim
gtkwave Branch_Log/wave.vcd
