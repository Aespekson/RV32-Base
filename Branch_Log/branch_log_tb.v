`include "definitions.vh"

// Unique to this tb rn. Will not move to definitions for now.
`define incrementpass \
        passed++;

module  branch_unit_tb;

  reg clk;
  reg i_branch = 1'b0;
  reg [2:0] i_branch_op = 3'b000;
  reg [`DATA_WIDTH-1:0] i_a = 32'h00000000;
  reg [`DATA_WIDTH-1:0] i_b = 32'h00000000;

  wire o_take;

  branch_log dut (
    .i_branch(i_branch),
    .i_branch_op(i_branch_op),
    .i_a(i_a),
    .i_b(i_b),
    .o_take(o_take)
  );

  reg [2:0] passed; //Counter intended to count the number of operations that work, in order tested in the testbench

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
    passed = 0;
    i_branch = 1'b1;
    i_a = 32'hA0000000;
    i_b = 32'hA0000000;
    i_branch_op = `BRANCH_BEQ;
    #10
      `assert(dut.o_take, 1'b1);
    i_b = 0;
    #10
      `assert(dut.o_take, 1'b0);// Tests equal op in case that arguments are equal and not equal
      `incrementpass //System Verilog. If testing with pure verilog interpreter, change. Others marked with //* and number of ops tested so you can find them easier
    i_branch = 0;
    #10;
      `assert(dut.o_take, 1'b0);// Tests that enable signal (i_branch) works properly. Not an operation
    i_branch = 1;
    i_b = 32'hA0000000;
    i_branch_op = `BRANCH_BNE;
    #10
      `assert(dut.o_take, 1'b0);
    i_b = 0;
    #10
      `assert(dut.o_take, 1'b1);
    i_b = 32'hA0000000;
    i_a = 0;
    #10
      `assert(dut.o_take, 1'b1);
      `incrementpass//* 2
    i_branch_op = `BRANCH_BLT;
    #10
      `assert(dut.o_take, 1'b0);
    i_b = 0;
    #10
      `assert(dut.o_take, 1'b0);
    i_a = 32'hB000000B;
    #10
      `assert(dut.o_take, 1'b1);
      `incrementpass//* 3
    i_branch_op = `BRANCH_BGE;
    #10
      `assert(dut.o_take, 1'b0);
    i_b = i_a;
    #10
      `assert(dut.o_take, 1'b1);
    i_a = 0;
    #10
      `assert(dut.o_take, 1'b1);
      `incrementpass//* 4
    i_branch_op = `BRANCH_BLTU;
    i_a = 0;
    #10
      `assert(dut.o_take, 1'b1);
    i_b = 0;
    #10
      `assert(dut.o_take, 1'b0);
    i_a = 32'hB000000B;
    #10
      `assert(dut.o_take, 1'b0);
      `incrementpass//* 5
    i_branch_op = `BRANCH_BGEU;
    #10
      `assert(dut.o_take, 1'b1);
    i_b = i_a;
    #10
      `assert(dut.o_take, 1'b1);
    i_a = 0;
    #10
      `assert(dut.o_take, 1'b0);
      `incrementpass//* 6
    i_branch_op = `BRANCH_JAL_JALR;
    #10
      `assert(dut.o_take, 1'b1)
      `incrementpass//* 7
    #10;
    i_branch_op = 3'b011;// Testing the one illegal opcode; not an operation; should default to 0
    #10
      `assert(dut.o_take, 1'b0)
      `incrementpass //* 8
      //Even though it isn't an operation, I feel the need to signal it is complete some way
    #10
    $finish;

  end

  initial begin
    $dumpfile("Branch_Log/wave.vcd");
    $dumpvars;
  end

endmodule
