`timescale 1ns/1ns
`include "definitions.vh"

module top_tb;

  reg clk;
  reg rst;

  cpu_top cpu (
  .clk(clk),
  .rst(rst)
  );

  always #1 clk = ~clk;

  reg test_complete;

  initial begin
      test_complete = 1'b0;

      wait (cpu.inst === 32'h0000006f);
      test_complete = 1'b1;

      #15;
      // Auto-verification logic here.

      $display("Program completed successfully.");
      $finish;
  end

  initial begin
      clk = 1'b0;
      rst = 1'b1;

      #10;
      rst = 1'b0;
  end

initial begin
    $dumpfile("Top_Level_Logic/wave.vcd");
    $dumpvars(0, top_tb);
end
endmodule
