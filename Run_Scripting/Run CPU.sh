#!/bin/bash
cd ..

iverilog -g2012 -o Top_Level_Logic/sim -ITop_Level_Logic Top_Level_Logic/top_tb.v Top_Level_Logic/ALU.v Top_Level_Logic/branch_log.v Top_Level_Logic/data_mem.v Top_Level_Logic/decode.v Top_Level_Logic/instruct_mem.v Top_Level_Logic/register_file.v
vvp Top_Level_Logic/sim
gtkwave Top_Level_Logic/wave.vcd
