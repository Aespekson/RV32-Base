module standard;

reg clk = 0;
reg rst = 1;
wire [3:0] count;

counter countunit (
    .clk(clk),
    .rst(rst),
    .count(count)
);

// clock: 10 time units period
always #5 clk = ~clk;

initial begin
    // new release reset, less arbitrary than #12
    rst = 1'b1;
    repeat (2) @(posedge clk);
    rst = 1'b0;

    repeat (10) @(posedge clk);

    $finish;
end

endmodule
