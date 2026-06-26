`timescale 1ns/1ns
`include "definitions.vh"

module top_tb;

  reg clk;
  reg rst;

  cpu_top cpu (
  .clk(clk),
  .rst(rst)
  )


  initial begin

  #5
    $display("All Checks Passed.");
  #5

    $display("All Checks Passed.");
    $finish;
  end

  initial begin
    $dumpfile("Top_Level_Logic/wave.vcd");
    $dumpvars;
  end

endmodule
  /*
    //Defaults from all of the different test benches.

    // ALU defaults
    clk = 1'b0;
    alu_a = 32'h00000000;
    alu_b = 32'h00000000;
    alu_op = 32'h00000000;

    // Branching defaults
    branch = 1'b0;
    branch_op = 3'b000;
    branch_a = 32'h00000000;
    branch_b = 32'h00000000;

    // Data Memory defaults
    wdata = 32'h00000000;
    wdataaddr = 32'h00000000;
    rdataaddr = 32'h00000000;

    // No decoder defaults

    // instruction memory defaults
    inst_mem_addr = 32'h00000000;

    // Register file defaults
    write_addr = 5'b00000;
    rs1_addr = 5'b00000;
    rs2_addr = 5'b00000;
    write_data = 32'h00000000;
    */
