
// clock: 10 time units period
always #5 clk = ~clk;

initial begin
    // new release reset, less arbitrary than #12
    rst = 1'b1;
    repeat (2) @(posedge clk);
    rst = 1'b0;

    repeat (20) @(posedge clk);

    $finish;
end
