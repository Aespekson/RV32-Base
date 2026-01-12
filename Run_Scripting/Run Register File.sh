#!/bin/bash
cd ..

iverilog -g2012 -o Register_File/sim -IRegister_File Register_File/register_file.v Register_File/register_file_tb.v
vvp Register_File/sim
gtkwave Register_File/wave.vcd
