`define assert(signal, value) \
        if (signal !== value) $finish;



module  branch_unit_tb;

  reg clk;
  reg i_branch = 1'b0;
  reg [2:0] i_branch_op = 3'b000;
  reg [`DATA_WIDTH-1:0] i_a = 32'h00000000;
  reg [`DATA_WIDTH-1:0] i_b = 32'h00000000;

  wire o_take;

  branch_unit dut (
    .i_branch(i_branch),
    .i_branch_op(i_branch_op),
    .i_a(i_a),
    .i_b(i_b),
    .o_take(o_take)
  );

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin

    #10;
      `assert(dut.o_take, 1'b0);
    $finish;

  end

  initial begin
    $dumpfile("Branch_Unit/wave.vcd");
    $dumpvars;
  end

endmodule
