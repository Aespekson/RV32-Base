module tb;

reg clk = 0;
reg rst = 1;
wire [3:0] count;

// Remember to invoke simulator from ../RV32-Base, not a lower directory or includes may not work properly
`include "../tb_sanitation/tb_standard.vh"

counter uut (
    .clk(clk),
    .rst(rst),
    .count(count)
);

initial begin
    $dumpfile("Counter/wave.vcd");
    $dumpvars(0, tb);
end

endmodule
