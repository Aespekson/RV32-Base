#!/bin/bash
cd ..

iverilog -g2012 -o Instruct_Decode/sim -IDecode Instruct_Decode/decode.v Instruct_Decode/decode_tb.v
vvp Instruct_Decode/sim
gtkwave Instruct_Decode/wave.vcd
