module tb;

reg clk = 0;
reg rst = 1;
wire [3:0] count;

counter uut (
    .clk(clk),
    .rst(rst),
    .count(count)
);

// clock: 10 time units period
always #5 clk = ~clk;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);

    #12 rst = 0;   // release reset
    #100 $finish;
end

endmodule
