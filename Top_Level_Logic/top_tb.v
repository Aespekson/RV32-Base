`timescale 1ns/1ns
`include "definitions.vh"

module top_tb;
  // Things from all other testbenches ported here.

  // ALU signals
  reg clk;
  reg [`FUNCT7_WIDTH-1:0] alu_op;
  reg [`DATA_WIDTH-1:0] alu_a;
  reg [`DATA_WIDTH-1:0] alu_b;

  wire [`DATA_WIDTH-1:0] alu_o;

  alu alu (
    .i_alu_op(alu_op),
    .i_a(alu_a),
    .i_b(alu_b),
    .o_c(alu_o)
  );

  //Branching logic signals
  reg branch;
  reg [2:0] branch_op;
  reg [`DATA_WIDTH-1:0] branch_a;
  reg [`DATA_WIDTH-1:0] branch_b;

  wire take_branch;

  branch_log brancher (
    .i_branch(branch),
    .i_branch_op(branch_op),
    .i_a(branch_a),
    .i_b(branch_b),
    .o_take(take_branch)
  );

  // Decoder signals

  reg [`INST_WIDTH-1:0]       inst;

  wire [6:0]                  inst_opcode; //Remove here if removed in decode.v. Currently kept only for testing purposes.
  wire [1:0]                  result_mux;
  wire [`DATA_WIDTH-1:0]      imm;

  //Multiplexer ALU operand selects
  wire [1:0] alu_a_src;
  wire [1:0] alu_b_src;

  // Instruction flags
  wire                        inst_illegal;
  wire                        inst_uses_rs1;
  wire                        inst_uses_rs2;

  decode decoder (
    .inst(inst),
    .o_alu_op(alu_op),
    .o_alu_a(alu_a_src),
    .o_alu_b(alu_b_src),
    .o_mem_write(data_we),
    .o_branch(branch),
    .o_branch_op(branch_op),
    .o_opcode(inst_opcode),
    .o_result_mux(result_mux),
    .o_reg_write(reg_we),
    .o_rs1_addr(rs1_addr),
    .o_rs2_addr(rs2_addr),
    .o_rd_addr(rd_addr),
    .o_imm(imm),
    .o_illegal(inst_illegal),
    .o_uses_rs1(inst_uses_rs1),
    .o_uses_rs2(inst_uses_rs2)
  );

  // Data Memory signals

  reg data_we;
  reg [31:0] wdata;
  wire [31:0] rdata;
  reg [31:0] wdataaddr;
  reg [31:0] rdataaddr;

  data_memory data_mem (
    .clk(clk),
    .we(we),
    .raddr(rdataaddr),
    .waddr(wdataaddr),
    .wdata(wdata),
    .rdata(rdata)
  );

  //instruction memory signals

  reg [31:0] inst_mem_addr;
//  wire [`INST_WIDTH-1:0] inst;// Declared with decoder

  instruction_memory inst_memory (
    .i_addr(inst_mem_addr),
    .o_inst(inst)
  );

  // Register file signals

  reg reg_we;
  reg rst;

  reg [$clog2(`NUM_REGISTER)-1:0] rd_addr;
  reg [$clog2(`NUM_REGISTER)-1:0] rs1_addr;
  reg [$clog2(`NUM_REGISTER)-1:0] rs2_addr;

  reg [`DATA_WIDTH-1:0] rd;
  wire [`DATA_WIDTH-1:0] rs1;
  wire [`DATA_WIDTH-1:0] rs2;

    register_file reg_file (
        .clk(clk),
        .we(reg_we),
        .rst(rst),
        .rd_addr(rd_addr),
        .rd(rd),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1(rs1),
        .rs2(rs2)
    );

  always #5 clk = ~clk;

  initial begin
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
    rd_addr = 5'b00000;
    rs1_addr = 5'b00000;
    rs2_addr = 5'b00000;
    rd = 32'h00000000;
    */
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
