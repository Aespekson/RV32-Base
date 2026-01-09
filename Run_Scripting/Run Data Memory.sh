#!/bin/bash
cd ..

iverilog -g2012 -o Data_Mem/sim -IData_Mem Data_Mem/data_mem.v Data_Mem/data_mem_tb.v
vvp Data_Mem/sim
gtkwave Data_Mem/wave.vcd
