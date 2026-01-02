#!/bin/bash
cd ..

iverilog -g2012 -o ALU/sim -IInstruct_Mem ALU/ALU.v ALU/ALU_tb.v
vvp ALU/sim
gtkwave ALU/wave.vcd
