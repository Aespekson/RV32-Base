// Remember to invoke simulator from ../RV32-Base, not a lower directory or includes may not work properly
`include "../Tb_Sanitation/tb_standard.vh"

module tb;

initial begin
    $dumpfile("Counter/wave.vcd");
    $dumpvars(0, standard);
end

endmodule
