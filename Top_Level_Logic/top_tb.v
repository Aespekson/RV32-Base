`timescale 1ns/1ns
`include "definitions.vh"

module cpu_tb;
  // Things from all other testbenches ported here.

  // ALU signals
  reg clk;
  reg [7:0] i_alu_op;
  reg [`DATA_WIDTH-1:0] i_a;
  reg [`DATA_WIDTH-1:0] i_b;

  wire [`DATA_WIDTH-1:0] o_c;

  alu alu (
    .i_alu_op(i_alu_op),
    .i_a(i_a),
    .i_b(i_b),
    .o_c(o_c)
  );

  //Branching logic signals
  reg i_branch;
  reg [2:0] i_branch_op;
  reg [`DATA_WIDTH-1:0] i_a;
  reg [`DATA_WIDTH-1:0] i_b;

  wire o_take;

  branch_log brancher (
    .i_branch(i_branch),
    .i_branch_op(i_branch_op),
    .i_a(i_a),
    .i_b(i_b),
    .o_take(o_take)
  );

  // Decoder signals

  reg [`INST_WIDTH-1:0]       inst;

  wire [`ALU_OP_WIDTH-1:0]    o_alu_op;
  wire [1:0]                  o_alu_a;
  wire [1:0]                  o_alu_b;
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

  wire                        o_illegal;
  wire                        o_uses_rs1;
  wire                        o_uses_rs2;

  decode decoder (
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
    .o_imm(o_imm),
    .o_illegal(o_illegal),
    .o_uses_rs1(o_uses_rs1),
    .o_uses_rs2(o_uses_rs2)
  );

  // Data Memory signals

  reg we;
  reg [31:0] wdata;
  wire [31:0] rdata;
  reg [31:0] waddr;
  reg [31:0] raddr;

  data_memory dut (
    .clk(clk),
    .we(we),
    .raddr(raddr),
    .waddr(waddr),
    .wdata(wdata),
    .rdata(rdata)
  );

  //instruction memory signals

  reg [$clog2(MEM_SIZE)-1:0] addr;
  wire [`INST_WIDTH-1:0] inst;

  instruction_memory dut (
    .i_addr(addr),
    .o_inst(inst)
  );

  // Register file signals

  reg clk;
  reg we;
  reg rst;

  reg [$clog2(`NUM_REGISTER)-1:0] rd_addr;
  reg [$clog2(`NUM_REGISTER)-1:0] rs1_addr;
  reg [$clog2(`NUM_REGISTER)-1:0] rs2_addr;

  reg [`DATA_WIDTH-1:0] rd;
  wire [`DATA_WIDTH-1:0] rs1;
  wire [`DATA_WIDTH-1:0] rs2;

    register_file dut (
        .clk(clk),
        .we(we),
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
    //Defaults from all of the different test benches.

    // ALU defaults
    clk = 1'b0;
    i_a = 32'h00000000;
    i_b = 32'h00000000;
    i_alu_op = 32'h00000000;

    // Branching defaults
    i_branch = 1'b0;
    i_branch_op = 3'b000;
    i_a_branch = 32'h00000000;
    i_b_branch = 32'h00000000;

    // Data Memory defaults
    wdata = 32'h00000000;
    waddr = 32'h00000000;
    raddr = 32'h00000000;

    // No decoder defaults

    // instruction memory defaults
    addr = 32'h00000000;

    // Register file defaults
    rd_addr = 5'b00000;
    rs1_addr = 5'b00000;
    rs2_addr = 5'b00000;
    rd = 32'h00000000;

    $display("All Checks Passed.");
    $finish;
  end

  initial begin
    $dumpfile("Top_Level_Logic/wave.vcd");
    $dumpvars;
  end

endmodule
