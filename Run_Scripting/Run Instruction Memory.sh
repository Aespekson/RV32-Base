#!/bin/bash
cd ..

iverilog -g2012 -o Instruct_Mem/sim -IInstruct_Mem Instruct_Mem/instruct_mem.v Instruct_Mem/instruct_mem_tb.v
vvp Instruct_Mem/sim
gtkwave Instruct_Mem/wave.vcd
