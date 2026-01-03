`define assert(signal, value) \
        if (signal !== value) $finish;

module  alu_tb;

  reg clk;
  reg [5:0] i_alu_op = 5'b00000;
  reg [`DATA_WIDTH-1:0] i_a = 32'h00000000;
  reg [`DATA_WIDTH-1:0] i_b = 32'h00000000;

  wire [`DATA_WIDTH-1:0] o_c;

  alu dut (
    .i_alu_op(i_alu_op),
    .i_a(i_a),
    .i_b(i_b),
    .o_c(o_c)
  );

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
        i_a = 32'h00000001;
        i_b = 32'h00000001;
        i_alu_op = `OP_ALU_INV;
      #5
        `assert(dut.o_c,32'hfffffffe);
        i_a = 32'h00000001;
        i_b = 32'h00000001;
        i_alu_op = `OP_ALU_ADD;
      #5;
        `assert(dut.o_c, 32'h00000002);
        i_a = 32'h00000001;
        i_b = 32'h00000001;
        i_alu_op = `OP_ALU_SUB;
      #5;
        `assert(dut.o_c, 32'h00000000);
        i_a = 32'h00000101;
        i_b = 32'h00010001;
        i_alu_op = `OP_ALU_AND;
      #5;
        `assert(dut.o_c, 32'h00000001);
        i_a = 32'h00000101;
        i_b = 32'h00010001;
        i_alu_op = `OP_ALU_OR;
      #5;
        `assert(dut.o_c, 32'h00010101);
        i_a = 32'h00000101;
        i_b = 32'h00010001;
        i_alu_op = `OP_ALU_XOR;
      #5;
        `assert(dut.o_c, 32'h00010100);
        i_a = 32'h00000101;
        i_b = 32'h00010001;
        i_alu_op = `OP_ALU_SLT;
      #5;
        `assert(dut.o_c, 32'h00000001);
        i_a = 32'h00000001;
        i_b = 32'h00000010;
        i_alu_op = `OP_ALU_SLL;
      #5;
        `assert(dut.o_c, 32'h00010000);
        i_a = 32'h00000100;
        i_b = 32'h00000001;
        i_alu_op = `OP_ALU_SRL;
      #5;
        `assert(dut.o_c, 32'h00000080);
        i_a = 32'hfffffff0;
        i_b = 32'h00000003;
        i_alu_op = `OP_ALU_SRA;
      #5;
        `assert(dut.o_c, 32'hfffffffe);
         i_a = 32'h80000000;
         i_b = 32'h0000001f;
         i_alu_op = `OP_ALU_SRA;
       #5;
        `assert(dut.o_c, 32'hffffffff);

    $finish;

  end

  initial begin
    $dumpfile("ALU/wave.vcd");
    $dumpvars;
  end

endmodule
