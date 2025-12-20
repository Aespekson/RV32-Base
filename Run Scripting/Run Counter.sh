#!/bin/bash
cd ..

iverilog -g2012 -o Counter/sim -ICounter -Itb_sanitation Counter/tb_counter.v Counter/counter.v

vvp Counter/sim

gtkwave Counter/wave.vcd
