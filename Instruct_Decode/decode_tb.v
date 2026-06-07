`timescale 1ns/1ns

module  decode_tb;

  reg clk;
  reg [`INST_WIDTH-1:0] inst = 32'h00000000;

  wire [`FUNCT7_WIDTH-1:0] o_alu_op;
  wire [`DATA_WIDTH-1:0] o_alu_a;
  wire [`DATA_WIDTH-1:0] o_alu_b;
  wire o_branch;
  wire [2:0] o_branch_op;
  wire o_mem_write;
  reg [6:0] o_opcode;
  wire [1:0] o_result_mux;
  wire o_reg_write;
  reg [$clog2(`NUM_REGISTER)-1:0] o_rs1_addr;
  reg [$clog2(`NUM_REGISTER)-1:0] o_rs2_addr;
  reg [$clog2(`NUM_REGISTER)-1:0] o_rd_addr;

  decode dut (
    .inst(inst),
    .o_alu_op(o_alu_op),
    .o_alu_a(o_alu_a),
    .o_alu_b(o_alu_b),
    .o_mem_write(o_mem_write),
    .o_branch(o_branch),
    .o_branch_op(o_branch_op),
    .o_opcode(o_opcode),
    .o_result_mux(o_result_mux),
    .o_reg_write(o_reg_write),
    .o_rs1_addr(o_rs1_addr),
    .o_rs2_addr(o_rs2_addr),
    .o_rd_addr(o_rd_addr)
  );

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
    inst = 32'h00000000;
  #10
    inst = 32'hAAAAAAAA;
  #11
    $finish;

  end

  initial begin
    $dumpfile("Instruct_Decode/wave.vcd");
    $dumpvars;
  end

endmodule
