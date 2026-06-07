`include "definitions.vh"

module decode (
    input wire[`INST_WIDTH-1:0] inst,

    output reg [`FUNCT7_WIDTH-1:0] o_alu_op,
    output reg [`DATA_WIDTH-1:0] o_alu_a,
    output reg [`DATA_WIDTH-1:0] o_alu_b,

    output reg o_branch,
    output reg [2:0] o_branch_op,
    output reg [`FUNCT7_WIDTH-1:0] o_opcode,
    output reg [1:0] o_result_mux,
    output reg o_reg_write,
    output reg [$clog2(`NUM_REGISTER)-1:0] o_rs1_addr,
    output reg [$clog2(`NUM_REGISTER)-1:0] o_rs2_addr,
    output reg [$clog2(`NUM_REGISTER)-1:0] o_rd_addr,

    output reg o_mem_write
);
    // Preemptive field readings. Whether we need them or not depends on instruction
    wire [6:0] o_opcode = inst[6:0]; //Instruction opcode
    wire [4:0] rd     = inst[11:7];
    wire [2:0] funct3 = inst[14:12];
    wire [4:0] rs1    = inst[19:15];
    wire [4:0] rs2    = inst[24:20];
    wire [6:0] funct7 = inst[31:25];

    // Immediates depending on kind of instruction
    wire [31:0] imm_i = {{20{inst[31]}}, inst[31:20]};
    wire [31:0] imm_s = {{20{inst[31]}}, inst[31:25], inst[11:7]};
    wire [31:0] imm_b = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
    wire [31:0] imm_u = {inst[31:12], 12'b0};
    wire [31:0] imm_j = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};

    assign o_opcode   = inst[6:0];
    assign o_rd_addr  = inst[11:7];
    assign o_rs1_addr = inst[19:15];
    assign o_rs2_addr = inst[24:20];

    always @* begin
    o_alu_op     = `OP_ALU_NOP;
    o_result_mux = 2'b00;
    o_reg_write  = 1'b0;
    o_mem_write  = 1'b0;
    o_branch     = 1'b0;
    o_branch_op  = 3'b000;
    o_imm        = 32'b0;

    case (opcode)
        `Rtype: begin
            o_reg_write = 1'b1;

            case ({funct7, funct3})
                {7'b0000000, 3'b000}: o_alu_op = `OP_ALU_ADD;
                {7'b0100000, 3'b000}: o_alu_op = `OP_ALU_SUB;
                {7'b0000000, 3'b111}: o_alu_op = `OP_ALU_AND;
                {7'b0000000, 3'b110}: o_alu_op = `OP_ALU_OR;
                {7'b0000000, 3'b100}: o_alu_op = `OP_ALU_XOR;
                {7'b0000000, 3'b010}: o_alu_op = `OP_ALU_SLT;
                {7'b0000000, 3'b011}: o_alu_op = `OP_ALU_SLTU;
                {7'b0000000, 3'b001}: o_alu_op = `OP_ALU_SLL;
                {7'b0000000, 3'b101}: o_alu_op = `OP_ALU_SRL;
                {7'b0100000, 3'b101}: o_alu_op = `OP_ALU_SRA;
                default: begin
                end
            endcase
        end

        `Itype_A: begin
            o_reg_write = 1'b1;
            o_imm       = imm_i;

            case (funct3)
                3'b000: o_alu_op = `OP_ALU_ADD;  // ADDI
                3'b010: o_alu_op = `OP_ALU_SLT;  // SLTI
                3'b011: o_alu_op = `OP_ALU_SLTU; // SLTIU
                3'b100: o_alu_op = `OP_ALU_XOR;  // XORI
                3'b110: o_alu_op = `OP_ALU_OR;   // ORI
                3'b111: o_alu_op = `OP_ALU_AND;  // ANDI

                3'b001: begin
                    if (funct7 == 7'b0000000)
                        o_alu_op = `OP_ALU_SLL;  // SLLI
                end

                3'b101: begin
                    if (funct7 == 7'b0000000)
                        o_alu_op = `OP_ALU_SRL;  // SRLI
                    else if (funct7 == 7'b0100000)
                        o_alu_op = `OP_ALU_SRA;  // SRAI
                end
            endcase
        end

        `Stype: begin
            o_mem_write = 1'b1;
            o_imm       = imm_s;
        end

        `Btype: begin
            o_branch    = 1'b1;
            o_branch_op = funct3;
            o_imm       = imm_b;
        end

        `Jtype: begin
            o_branch    = 1'b1;
            o_branch_op = `BRANCH_JAL_JALR;
            o_reg_write = 1'b1;
            o_imm       = imm_j;
        end
    endcase
end

endmodule
