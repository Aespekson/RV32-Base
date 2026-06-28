# RV32-Base

RV32-Base is a RISC-V CPU designed to be implemented on an FPGA board in conjunction with the operating system described in the Project Context section.

The intent is explicitly not to be a production quality CPU. This is instead being built with a focus on implementing the following minimum requirements a RISC-V CPU must meet, including:

* RV32I base integer ISA
* In-order, single-issue, simple fetch - decode - execute - writeback pipeline
* Flat physical address space
* Memory-mapped I/O
* Likely Machine mode only

Explicit non-goals include:

* Out-of-order execution
* A lot of caching behavior
* Multiple cores
* Strict or intense performance optimization or analysis (optimizations may be made casually if they appear easily)
* Full privileged spec compliance

RV32-Base is designed specifically to work with the accompanying operating system rather than existing platforms. This allows for greater hardware/software co-design opportunities.

## ISA

Documentation for the ISA used in this project is found [here](https://docs.riscv.org/reference/isa/_attachments/riscv-unprivileged.pdf).

## Verification

Initially, RV32-Base is just going to be verified with naive test benches that test certain base cases (and hopefully problematic borders that serve as edge cases). After an end product has been assembled, it will be verified with [riscv-formal](https://github.com/YosysHQ/riscv-formal).

## Status

RV32-Base is under active development and is the first of two projects designed with the discussed intents in mind. Most commits should compile fine, but this is not guaranteed for all parts of the project. Only the final product or marked commits are guaranteed.

## Project Context

As mentioned above, RV32-Base is intended to function with a custom operating system named MOS. This is the first of the two projects. The planned development order is:

1. CPU (RV32-Base) — [this repo](https://github.com/Aespekson/RV32-Base)
2. OS (MOS) — [here](https://github.com/Aespekson/MOS)

## Notes and Minor Points

### Naming Standards

Folders are capitalized and multiple words are adjoined by "_", as in `Instruct_Mem`.

Source code files are not capitalized and multiple words are adjoined by "_", as in `instruct_mem.v`.

Scripts are capitalized and multiple words are adjoined by spaces, as in `Run Counter.sh`.

### Running/Testing Commits

RV32-Base is currently being developed and tested using the Fedora operating system but should work on most Linux distributions. Nothing has been tested on Windows.

GTKWave and Icarus Verilog must be installed. It is recommended to either run the `.sh` scripts located in `../RV32-Base/Run_Scripting/` or to copy and paste the commands located in them (after the `cd ..` command) into a terminal whose working directory is `../RV32-Base/`.

The dump file is specified in each test bench assuming that the commands are executed from `../RV32-Base/` and will therefore not work if they are executed from another working directory.
