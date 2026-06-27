`timescale 1ns/1ns
`include "definitions.vh"
`default_nettype none // To catch wires that have not been explicitly declared

module cpu_top(
  input wire clk,
  input wire rst
);

  // ALU signals

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

  assign branch_a = rs1;
  assign branch_b = rs2;

  // Decoder signals

  reg [`INST_WIDTH-1:0]       inst;

  wire [6:0]                  inst_opcode; //Remove here if removed in decode.v. Currently kept only for testing purposes.
  wire [`DATA_WIDTH-1:0]      imm;

  //Multiplexer ALU operand selects
  wire [1:0] alu_a_src;
  wire [1:0] alu_b_src;

  // PC/result Multiplexer selects
  wire [1:0]                  pc_src;
  wire [1:0]                  result_src;

  // Instruction flags
  wire                        inst_illegal;
  wire                        inst_uses_rs1;
  wire                        inst_uses_rs2;

  decode decoder (
    .inst(inst),
    .o_opcode(inst_opcode),
    .o_alu_op(alu_op),
    .o_alu_a(alu_a_src),
    .o_alu_b(alu_b_src),
    .o_pc_src(pc_src),
    .o_result_mux(result_src),
    .o_mem_write(data_we),
    .o_branch(branch),
    .o_branch_op(branch_op),
    .o_reg_write(reg_we),
    .o_rs1_addr(rs1_addr),
    .o_rs2_addr(rs2_addr),
    .o_write_addr(write_addr),
    .o_imm(imm),
    .o_illegal(inst_illegal),
    .o_uses_rs1(inst_uses_rs1),
    .o_uses_rs2(inst_uses_rs2)
  );

  // Data Memory signals

  reg         data_we;
  reg [31:0]  wdata;
  wire [31:0] rdata;
  reg [31:0]  wdataaddr;
  reg [31:0]  rdataaddr;

  assign wdataaddr = alu_o;
  assign rdataaddr = alu_o;
  assign wdata     = rs2;

  data_memory data_mem (
    .clk(clk),
    .we(data_we),
    .raddr(rdataaddr),
    .waddr(wdataaddr),
    .wdata(wdata),
    .rdata(rdata)
  );

  //No instruction memory signals not declared elsewhere

  instruction_memory inst_memory (
    .i_addr(PC),
    .o_inst(inst)
  );

  // Register file signals

  reg reg_we;

  reg [$clog2(`NUM_REGISTER)-1:0] write_addr;
  reg [$clog2(`NUM_REGISTER)-1:0] rs1_addr;
  reg [$clog2(`NUM_REGISTER)-1:0] rs2_addr;

  reg [`DATA_WIDTH-1:0] write_data;
  wire [`DATA_WIDTH-1:0] rs1;
  wire [`DATA_WIDTH-1:0] rs2;

    register_file reg_file (
        .clk(clk),
        .we(reg_we),
        .rst(rst),
        .write_addr(write_addr),
        .write_data(write_data),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1(rs1),
        .rs2(rs2)
    );

  //Multiplexers
  always @* begin
        case(alu_a_src)
            `ALU_A_RS1:  alu_a = rs1;
            `ALU_A_PC:   alu_a = PC;
            `ALU_A_ZERO: alu_a = 0;
            default:     alu_a = 0;
        endcase
  end

  always @* begin
    case (alu_b_src)
        `ALU_B_RS2:  alu_b = rs2;
        `ALU_B_IMM:  alu_b = imm;
        `ALU_B_FOUR: alu_b = 32'd4;
        default:     alu_b = 32'b0;
    endcase
  end

  reg [31:0]  PC;
  reg [31:0] next_PC;

  always @(posedge clk) begin
    if (!rst)
        PC <= 32'h0000_0000;
    else
        PC <= next_PC;
  end

  always @* begin
    case (pc_src)
      `PC_SRC_PC4:     next_PC = PC + 4;
      `PC_SRC_PC_IMM:  if (take_branch) next_PC = PC + imm;
      `PC_SRC_RS1_IMM: if (take_branch) next_PC = rs1 + imm & 32'hFFFF_FFFE; //JALR target ignores lowest bit because it cannot guarantee rs1 is byte aligned.
      default:         next_PC = PC + 4;
    endcase
  end

  always @* begin
    case (result_src)
      `RESULT_ALU: write_data = alu_o;
      `RESULT_MEM: write_data = rdata;
      `RESULT_PC4: write_data = PC + 4;
      `RESULT_IMM: write_data = imm;
      default:     write_data = 32'b0;
    endcase
  end

endmodule
