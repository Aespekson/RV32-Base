#! /usr/bin/vvp
:ivl_version "12.0 (stable)";
:ivl_delay_selection "TYPICAL";
:vpi_time_precision + 0;
:vpi_module "/usr/lib64/ivl/system.vpi";
:vpi_module "/usr/lib64/ivl/vhdl_sys.vpi";
:vpi_module "/usr/lib64/ivl/vhdl_textio.vpi";
:vpi_module "/usr/lib64/ivl/v2005_math.vpi";
:vpi_module "/usr/lib64/ivl/va_math.vpi";
S_0x555fc5351ef0 .scope module, "counter" "counter" 2 1;
 .timescale 0 0;
    .port_info 0 /INPUT 1 "clk";
    .port_info 1 /INPUT 1 "rst";
    .port_info 2 /OUTPUT 4 "count";
o0x7f177668a018 .functor BUFZ 1, C4<z>; HiZ drive
v0x555fc53520d0_0 .net "clk", 0 0, o0x7f177668a018;  0 drivers
v0x555fc5373470_0 .var "count", 3 0;
o0x7f177668a078 .functor BUFZ 1, C4<z>; HiZ drive
v0x555fc5373550_0 .net "rst", 0 0, o0x7f177668a078;  0 drivers
E_0x555fc5364bd0 .event posedge, v0x555fc53520d0_0;
    .scope S_0x555fc5351ef0;
T_0 ;
    %wait E_0x555fc5364bd0;
    %load/vec4 v0x555fc5373550_0;
    %flag_set/vec4 8;
    %jmp/0xz  T_0.0, 8;
    %pushi/vec4 0, 0, 4;
    %assign/vec4 v0x555fc5373470_0, 0;
    %jmp T_0.1;
T_0.0 ;
    %load/vec4 v0x555fc5373470_0;
    %addi 1, 0, 4;
    %assign/vec4 v0x555fc5373470_0, 0;
T_0.1 ;
    %jmp T_0;
    .thread T_0;
# The file index is used to find the file name in the following table.
:file_names 3;
    "N/A";
    "<interactive>";
    "counter.v";
