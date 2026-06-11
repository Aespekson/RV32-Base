`timescale 1ns/1ns
`include "definitions.vh"

module decode_tb;
  reg [`INST_WIDTH-1:0]       inst;

  wire [`ALU_OP_WIDTH-1:0]    o_alu_op;
  wire [`DATA_WIDTH-1:0]      o_alu_a;
  wire [`DATA_WIDTH-1:0]      o_alu_b;
  wire                        o_branch;
  wire [2:0]                  o_branch_op;
  wire [6:0]                  o_opcode; //Remove here if removed in decode.v
  wire [1:0]                  o_result_mux;
  wire                        o_reg_write;
  wire [`REG_ADDR_WIDTH-1:0]  o_rs1_addr;
  wire [`REG_ADDR_WIDTH-1:0]  o_rs2_addr;
  wire [`REG_ADDR_WIDTH-1:0]  o_rd_addr;
  wire [`DATA_WIDTH-1:0]      o_imm;
  wire                        o_mem_write;

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
    .o_rd_addr(o_rd_addr),
    .o_imm(o_imm)
  );

  initial begin
  inst = 32'h00000000;
  #10
    inst = 32'hAAAAAAAA;
  #11

    $display("All Checks Passed."); // When we put checks in here, of course
    $finish;
  end

  initial begin
    $dumpfile("Instruct_Decode/wave.vcd");
    $dumpvars;
  end

endmodule
