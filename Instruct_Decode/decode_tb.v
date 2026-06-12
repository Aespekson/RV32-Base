`timescale 1ns/1ns
`include "definitions.vh"

module decode_tb;
  reg [`INST_WIDTH-1:0]       inst;

  wire [`ALU_OP_WIDTH-1:0]    o_alu_op;
  wire [`DATA_WIDTH-1:0]      o_alu_a;
  wire [`DATA_WIDTH-1:0]      o_alu_b;
  wire                        o_branch;
  wire [2:0]                  o_branch_op;
  wire [6:0]                  o_opcode; //Remove here if removed in decode.v. Currently kept only for testing purposes.
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
    // ADD x3, x1, x2
    //inst = 32'b0000000_00010_00001_000_00011_0110011; //Pure bits, less intuitive
    inst = {7'b0,5'd2,5'd1,3'b0,5'd3,`Rtype}; // Concatenated bits, more transparent
  #5;
    `assert(o_opcode, `Rtype)
    `assert(o_rd_addr, 5'd3)            //Read at x3
    `assert(o_rs1_addr, 5'd1)           //Operand A at x1
    `assert(o_rs2_addr, 5'd2)           //Operand B at x2
    `assert(o_reg_write, 1'b1)          // Reg write enabled
    `assert(o_mem_write, 1'b0)          // Mem write disabled
    `assert(o_branch, 1'b0)             // No branch
    `assert(o_alu_op, `OP_ALU_ADD)      // ALU op ADD
    `assert(o_alu_a[1:0], `ALU_A_RS1)   // ALU input A is rs1
    `assert(o_alu_b[1:0], `ALU_B_RS2)   // ALU input B is rs2
    `assert(o_result_mux, `RESULT_ALU)  // Get result from ALU

    // ADDI x5, x1, -4
    inst = {12'hffc, 5'd1, 3'b000, 5'd5, `Itype_A};
  #5;
    `assert(o_opcode, `Itype_A)
    `assert(o_rd_addr, 5'd5)
    `assert(o_rs1_addr, 5'd1)
    `assert(o_reg_write, 1'b1)
    `assert(o_alu_op, `OP_ALU_ADD)
    `assert(o_alu_b[1:0], `ALU_B_IMM)
    `assert(o_imm, 32'hffff_fffc)

    // SW x2, 8(x1)
    inst = {7'b0000000, 5'd2, 5'd1, 3'b010, 5'b01000, `Stype};
  #5;
    `assert(o_mem_write, 1'b1)
    `assert(o_reg_write, 1'b0)
    `assert(o_alu_op, `OP_ALU_ADD)
    `assert(o_alu_b[1:0], `ALU_B_IMM)
    `assert(o_imm, 32'd8)

    // BEQ x1, x2, +8
    inst = {1'b0, 6'b000000, 5'd2, 5'd1, `BRANCH_BEQ, 4'b0100, 1'b0, `Btype};
  #5;
    `assert(o_branch, 1'b1)
    `assert(o_branch_op, `BRANCH_BEQ)
    `assert(o_reg_write, 1'b0)
    `assert(o_mem_write, 1'b0)
    `assert(o_imm, 32'd8)

    // LUI x10, 0x12345
    inst = {20'h12345, 5'd10, `Utype};
  #5;
    `assert(o_reg_write, 1'b1)
    `assert(o_result_mux, `RESULT_IMM)
    `assert(o_imm, 32'h12345_000)

    // JAL x1, +16
    inst = {1'b0, 10'b0000001000, 1'b0, 8'b00000000, 5'd1, `Jtype};
  #5;
    `assert(o_branch, 1'b1)
    `assert(o_branch_op, `BRANCH_JAL_JALR)
    `assert(o_reg_write, 1'b1)
    `assert(o_result_mux, `RESULT_PC4)
    `assert(o_imm, 32'd16)

    $display("All Checks Passed.");
    $finish;
  end

  initial begin
    $dumpfile("Instruct_Decode/wave.vcd");
    $dumpvars;
  end

endmodule
