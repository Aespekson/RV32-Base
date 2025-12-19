# RV32-Base

RV32-Base is a RISC-V CPU designed to be implemented on an FPGA board in conjunction with two other projects in the Project Context section.

The intent is explicitly not to be a production quality CPU. This is instead being built with a focus on implementing the following minimum requirements a RISC-V CPU must meet, including:
 - RV32I base integer ISA
 - In-order, single-issue, simple fetch - decode - execute - writeback pipeline
 - Flat physical address space
 - Memory-mapped I/O
 - Likely Machine mode only

Explicit non-goals include:
 - Out-of-order execution
 - A lot of caching behavior
 - Multiple cores
 - Strict or intense performance optimization or analysis (optimizations may be made casually if they appear easily)
 - Full privileged spec compliance

RV32-Base is strictly made to work with the other two projects below, not with existing platforms. This allows for greater co-design opportunities.

## Status
RV32-Base is under active development and is the first of three projects designed with the discussed intents in mind. Commits will be made (or, at least, are planned to be made) at logical watersheds. There is no guarantee that any particular commit is whole, functional, or even compiles. Only the final product or marked commits are guaranteed. 

## Project Context
As mentioned above, RV32-Base is intended to function with a custom operating system named MOS, with an accelerator being planned for later. This is the first of the three projects. The order they are planned to be tackled in is:
1. CPU (RV32-Base) [this repo](https://github.com/Aespekson/RV32-Base)
2. OS (MOS) [here](https://github.com/Aespekson/MOS)
3. Accelerator (RV32-Aux-Unit) [here](https://github.com/Aespekson/RV32-Aux-Unit)
