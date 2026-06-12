`include "definitions.vh"

// o_alu_a[1:0] and o_alu_b[1:0] are operand-select controls using the
// ALU_A_* and ALU_B_* macros in definitions.vh. They remain DATA_WIDTH wide
// only to preserve the original port names/shape while the rest of the CPU is
// still being assembled.
module decode (
    input  wire [`INST_WIDTH-1:0]     inst,

    output reg  [`ALU_OP_WIDTH-1:0]   o_alu_op,
    output reg  [`DATA_WIDTH-1:0]     o_alu_a,
    output reg  [`DATA_WIDTH-1:0]     o_alu_b,

    output reg                        o_branch,
    output reg  [2:0]                 o_branch_op,
    output wire [6:0]                 o_opcode, // Going to keep for testing purposes
    output reg  [1:0]                 o_result_mux,
    output reg                        o_reg_write,
    output wire [`REG_ADDR_WIDTH-1:0] o_rs1_addr,
    output wire [`REG_ADDR_WIDTH-1:0] o_rs2_addr,
    output wire [`REG_ADDR_WIDTH-1:0] o_rd_addr,
    output reg  [`DATA_WIDTH-1:0]     o_imm,

    output reg                        o_mem_write
);
    wire [6:0] opcode = inst[6:0];
    wire [4:0] rd     = inst[11:7];
    wire [2:0] funct3 = inst[14:12];
    wire [4:0] rs1    = inst[19:15];
    wire [4:0] rs2    = inst[24:20];
    wire [6:0] funct7 = inst[31:25];

    wire [`DATA_WIDTH-1:0] imm_i = {{20{inst[31]}}, inst[31:20]};
    wire [`DATA_WIDTH-1:0] imm_s = {{20{inst[31]}}, inst[31:25], inst[11:7]};
    wire [`DATA_WIDTH-1:0] imm_b = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
    wire [`DATA_WIDTH-1:0] imm_u = {inst[31:12], 12'b0};
    wire [`DATA_WIDTH-1:0] imm_j = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};

    assign o_opcode   = opcode; //Remove if o_opcode is removed
    assign o_rd_addr  = rd;
    assign o_rs1_addr = rs1;
    assign o_rs2_addr = rs2;

    always @* begin
        // Safe defaults: unsupported instructions behave like a NOP.
        o_alu_op     = `OP_ALU_NOP;
        o_alu_a      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_RS1};
        o_alu_b      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_RS2};
        o_result_mux = `RESULT_ALU;
        o_reg_write  = 1'b0;
        o_mem_write  = 1'b0;
        o_branch     = 1'b0;
        o_branch_op  = 3'b000;
        o_imm        = {`DATA_WIDTH{1'b0}};

        case (opcode)
            `Rtype: begin
                o_reg_write = 1'b1;
                o_alu_a     = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_RS1};
                o_alu_b     = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_RS2};
                o_result_mux = `RESULT_ALU;

                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: o_alu_op = `OP_ALU_ADD;  // ADD
                    {7'b0100000, 3'b000}: o_alu_op = `OP_ALU_SUB;  // SUB
                    {7'b0000000, 3'b111}: o_alu_op = `OP_ALU_AND;  // AND
                    {7'b0000000, 3'b110}: o_alu_op = `OP_ALU_OR;   // OR
                    {7'b0000000, 3'b100}: o_alu_op = `OP_ALU_XOR;  // XOR
                    {7'b0000000, 3'b010}: o_alu_op = `OP_ALU_SLT;  // SLT
                    {7'b0000000, 3'b011}: o_alu_op = `OP_ALU_SLTU; // SLTU
                    {7'b0000000, 3'b001}: o_alu_op = `OP_ALU_SLL;  // SLL
                    {7'b0000000, 3'b101}: o_alu_op = `OP_ALU_SRL;  // SRL
                    {7'b0100000, 3'b101}: o_alu_op = `OP_ALU_SRA;  // SRA
                    default: begin
                        o_reg_write = 1'b0;
                        o_alu_op    = `OP_ALU_NOP;
                    end
                endcase
            end

            `Itype_A: begin
                o_reg_write = 1'b1;
                o_alu_a     = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_RS1};
                o_alu_b     = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_IMM};
                o_result_mux = `RESULT_ALU;
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
                        else
                            o_reg_write = 1'b0;
                    end
                    3'b101: begin
                        if (funct7 == 7'b0000000)
                            o_alu_op = `OP_ALU_SRL;  // SRLI
                        else if (funct7 == 7'b0100000)
                            o_alu_op = `OP_ALU_SRA;  // SRAI
                        else
                            o_reg_write = 1'b0;
                    end
                    default: o_reg_write = 1'b0;
                endcase
            end

            `Itype_L: begin
                // Address = rs1 + imm_i; writeback comes from data memory.
                o_reg_write  = 1'b1;
                o_alu_op     = `OP_ALU_ADD;
                o_alu_a      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_RS1};
                o_alu_b      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_IMM};
                o_result_mux = `RESULT_MEM;
                o_imm        = imm_i;
            end

            `Stype: begin
                // Address = rs1 + imm_s; memory write data comes from rs2.
                o_mem_write = 1'b1;
                o_alu_op    = `OP_ALU_ADD;
                o_alu_a     = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_RS1};
                o_alu_b     = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_IMM};
                o_imm       = imm_s;
            end

            `Btype: begin
                o_branch    = 1'b1;
                o_branch_op = funct3;
                o_alu_a     = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_RS1};
                o_alu_b     = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_RS2};
                o_imm       = imm_b;
            end

            `Utype: begin
                // LUI: write upper immediate. The ALU is not required for this path.
                o_reg_write  = 1'b1;
                o_result_mux = `RESULT_IMM;
                o_imm        = imm_u;
            end

            `Utype_AUIPC: begin
                // AUIPC: rd = pc + imm_u.
                o_reg_write  = 1'b1;
                o_alu_op     = `OP_ALU_ADD;
                o_alu_a      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_PC};
                o_alu_b      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_IMM};
                o_result_mux = `RESULT_ALU;
                o_imm        = imm_u;
            end

            `Jtype: begin
                // JAL: branch target is pc + imm_j; writeback is pc + 4.
                o_branch     = 1'b1;
                o_branch_op  = `BRANCH_JAL_JALR;
                o_reg_write  = 1'b1;
                o_alu_a      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_PC};
                o_alu_b      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_FOUR};
                o_result_mux = `RESULT_PC4;
                o_imm        = imm_j;
            end

            `Itype_JALR: begin
                // JALR: target is rs1 + imm_i; writeback is pc + 4.
                o_branch     = 1'b1;
                o_branch_op  = `BRANCH_JAL_JALR;
                o_reg_write  = 1'b1;
                o_alu_op     = `OP_ALU_ADD;
                o_alu_a      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_A_RS1};
                o_alu_b      = {{(`DATA_WIDTH-2){1'b0}}, `ALU_B_IMM};
                o_result_mux = `RESULT_PC4;
                o_imm        = imm_i;
            end

            default: begin
                // Should keep the safe defaults that were defined above.
            end
        endcase
    end
endmodule
