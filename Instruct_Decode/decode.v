`include "definitions.vh"

module decode (
    input  wire [`INST_WIDTH-1:0]     inst,

    output reg  [`ALU_OP_WIDTH-1:0]   o_alu_op,
    output reg  [1:0]                 o_alu_a,
    output reg  [1:0]                 o_alu_b,

    output reg                        o_branch,
    output reg  [2:0]                 o_branch_op,
    output wire [6:0]                 o_opcode, // Going to keep for testing purposes
    output reg  [1:0]                 o_result_mux,
    output reg                        o_reg_write,
    output wire [`REG_ADDR_WIDTH-1:0] o_rs1_addr,
    output wire [`REG_ADDR_WIDTH-1:0] o_rs2_addr,
    output wire [`REG_ADDR_WIDTH-1:0] o_write_addr,
    output reg  [`DATA_WIDTH-1:0]     o_imm,
    output reg                        o_mem_write,

    output reg [1:0]                  o_pc_src, // Next PC, defaults to +4

    //Pipelining use signals/flags.
    output reg                        o_uses_rs1,
    output reg                        o_uses_rs2,
    output reg                        o_illegal // Check if illegal instruction. Should make debugging much easier

    /*
    Consider the following flags for the future. They may not be necessary, but they might make things easier. Decide later, during pipelining, whether these are or are not useful
    output reg o_is_load;
    output reg o_is_store;
    output reg o_is_branch;
    output reg o_is_jump;
    */
);
    wire [6:0] opcode = inst[6:0];
    wire [4:0] rd     = inst[11:7];
    wire [2:0] funct3 = inst[14:12];
    wire [4:0] rs1    = inst[19:15];
    wire [4:0] rs2    = inst[24:20];
    wire [6:0] funct7 = inst[31:25];
    wire [31:0] PC;
    wire [31:0] rs1_data;

    wire [`DATA_WIDTH-1:0] imm_i = {{20{inst[31]}}, inst[31:20]};
    wire [`DATA_WIDTH-1:0] imm_s = {{20{inst[31]}}, inst[31:25], inst[11:7]};
    wire [`DATA_WIDTH-1:0] imm_b = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
    wire [`DATA_WIDTH-1:0] imm_u = {inst[31:12], 12'b0};
    wire [`DATA_WIDTH-1:0] imm_j = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};

    assign o_opcode   = opcode; //Remove if o_opcode is removed
    assign o_write_addr  = rd;
    assign o_rs1_addr = rs1;
    assign o_rs2_addr = rs2;

    always @* begin
        o_illegal    = 1'b1;
        o_uses_rs1   = 1'b0;
        o_uses_rs2   = 1'b0;
        // Safe defaults: unsupported instructions behave like a NOP.
        // Note that this makes things safe but may make debugging malformed ones harder
        // Must also note that, in the final pipeline, illegal instructions must not be allowed to retire as an ordinary NOP.

        o_alu_op     = `OP_ALU_NOP;
        o_alu_a      = `ALU_A_RS1;
        o_alu_b      = `ALU_B_RS2;
        o_result_mux = `RESULT_ALU;
        o_reg_write  = 1'b0;
        o_mem_write  = 1'b0;
        o_branch     = 1'b0;
        o_branch_op  = 3'b000;
        o_imm        = {`DATA_WIDTH{1'b0}};
        o_pc_src     = `PC_SRC_PC4;

        case (opcode)
            `Rtype: begin
                // Removed central assignment of common signal values (o_illegal, o_uses_rs1, o_uses_rs2, and o_reg_write). Now, we need not assign the signals more than once by reverting them in the default block if the opcode is Rtype but funct7, funct3 do not match a given instruction within the type.
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: begin // ADD
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_ADD;
                    end
                    {7'b0100000, 3'b000}: begin // SUB
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_SUB;
                    end
                    {7'b0000000, 3'b111}: begin // AND
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_AND;
                    end
                    {7'b0000000, 3'b110}: begin // OR
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_OR;
                    end
                    {7'b0000000, 3'b100}: begin // XOR
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_XOR;
                    end
                    {7'b0000000, 3'b010}: begin // SLT
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_SLT;
                    end
                    {7'b0000000, 3'b011}: begin // SLTU
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_SLTU;
                    end
                    {7'b0000000, 3'b001}: begin // SLL
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_SLL;
                    end
                    {7'b0000000, 3'b101}: begin // SRL
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_SRL;
                    end
                    {7'b0100000, 3'b101}: begin // SRA
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_SRA;
                    end
                    default: begin
                        // Illegal; no assignments required; retains safe defaults.
                    end
                endcase
            end

            `Itype_A: begin
                //Same removal of central assignments as Rtype.
                case (funct3)
                    3'b000: begin // ADDI
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_ADD;
                        o_alu_b      = `ALU_B_IMM;
                        o_imm        = imm_i;
                    end
                    3'b010: begin // SLTI
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_SLT;
                        o_alu_b      = `ALU_B_IMM;
                        o_imm        = imm_i;
                    end
                    3'b011: begin // SLTIU
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_SLTU;
                        o_alu_b      = `ALU_B_IMM;
                        o_imm        = imm_i;
                    end
                    3'b100: begin // XORI
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_XOR;
                        o_alu_b      = `ALU_B_IMM;
                        o_imm        = imm_i;
                    end
                    3'b110: begin // ORI
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_OR;
                        o_alu_b      = `ALU_B_IMM;
                        o_imm        = imm_i;
                    end
                    3'b111: begin // ANDI
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_reg_write  = 1'b1;
                        o_alu_op     = `OP_ALU_AND;
                        o_alu_b      = `ALU_B_IMM;
                        o_imm        = imm_i;
                    end
                    3'b001: begin
                        if (funct7 == 7'b0000000) begin // SLLI
                            o_illegal    = 1'b0;
                            o_uses_rs1   = 1'b1;
                            o_reg_write  = 1'b1;
                            o_alu_op     = `OP_ALU_SLL;
                            o_alu_b      = `ALU_B_IMM;
                            o_imm        = imm_i;
                        end
                    end
                    3'b101: begin
                        if (funct7 == 7'b0000000) begin // SRLI
                            o_illegal    = 1'b0;
                            o_uses_rs1   = 1'b1;
                            o_reg_write  = 1'b1;
                            o_alu_op     = `OP_ALU_SRL;
                            o_alu_b      = `ALU_B_IMM;
                            o_imm        = imm_i;
                        end
                        else if (funct7 == 7'b0100000) begin // SRAI
                            o_illegal    = 1'b0;
                            o_uses_rs1   = 1'b1;
                            o_reg_write  = 1'b1;
                            o_alu_op     = `OP_ALU_SRA;
                            o_alu_b      = `ALU_B_IMM;
                            o_imm        = imm_i;
                        end
                    end
                    default: begin
                        // Still no assignments required
                    end
                endcase
            end

            `Itype_L: begin
              if (funct3 == 3'b010) begin
                //LW only. Will extend to LH and the like later. As of now, LB, LH, LBU, LHU are technically illegal
                o_illegal    = 1'b0;
                o_uses_rs1   = 1'b1;
                o_reg_write  = 1'b1;
                o_alu_op     = `OP_ALU_ADD;
                o_alu_a      = `ALU_A_RS1;
                o_alu_b      = `ALU_B_IMM;
                o_result_mux = `RESULT_MEM;
                o_imm        = imm_i;
              end

            end

            `Itype_JALR: begin
                // JALR: target is rs1 + imm_i; writeback is pc + 4.
              if (funct3 == 3'b000) begin //JALR requires this condition. Otherwise, it is illegal
                o_illegal    = 1'b0;
                o_uses_rs1   = 1'b1;
                o_branch     = 1'b1;
                o_branch_op  = `BRANCH_JAL_JALR;
                o_reg_write  = 1'b1;
                o_alu_op     = `OP_ALU_ADD;
                o_alu_a      = `ALU_A_RS1;
                o_alu_b      = `ALU_B_IMM;
                o_result_mux = `RESULT_PC4;
                o_imm        = imm_i;
                o_pc_src = `PC_SRC_RS1_IMM;
              end
            end

            `Stype: begin
              if (funct3 == 3'b010) begin // SW only. May extend later. SB, SH will have no effect.
                // Address = rs1 + imm_s; memory write data comes from rs2.
                o_illegal    = 1'b0;
                o_uses_rs1   = 1'b1;
                o_uses_rs2   = 1'b1;
                o_mem_write  = 1'b1;
                o_alu_op     = `OP_ALU_ADD;
                o_alu_a      = `ALU_A_RS1;
                o_alu_b      = `ALU_B_IMM;
                o_imm        = imm_s;
              end
            end

            `Btype: begin
                case (funct3)
                    `BRANCH_BEQ,
                    `BRANCH_BNE,
                    `BRANCH_BLT,
                    `BRANCH_BGE,
                    `BRANCH_BLTU,
                    `BRANCH_BGEU: begin
                        o_illegal    = 1'b0;
                        o_uses_rs1   = 1'b1;
                        o_uses_rs2   = 1'b1;
                        o_branch     = 1'b1;
                        o_branch_op  = funct3;
                        o_alu_a      = `ALU_A_RS1;
                        o_alu_b      = `ALU_B_RS2;
                        o_imm        = imm_b;
                        o_pc_src = `PC_SRC_PC_IMM;
                    end
                    default: begin
                        // Defaults already safe
                    end
                endcase
            end

            `Utype: begin
                // LUI
                o_illegal    = 1'b0;
                o_reg_write  = 1'b1;
                o_result_mux = `RESULT_IMM;
                o_imm        = imm_u;
            end

            `Utype_AUIPC: begin
                // AUIPC: rd = pc + imm_u.
                o_illegal    = 1'b0;
                o_reg_write  = 1'b1;
                o_alu_op     = `OP_ALU_ADD;
                o_alu_a      = `ALU_A_PC;
                o_alu_b      = `ALU_B_IMM;
                o_result_mux = `RESULT_ALU;
                o_imm        = imm_u;
            end

            `Jtype: begin
                // JAL: branch target is pc + imm_j; writeback is pc + 4.
                o_illegal    = 1'b0;
                o_branch     = 1'b1;
                o_branch_op  = `BRANCH_JAL_JALR;
                o_reg_write  = 1'b1;
                o_alu_a      = `ALU_A_PC;
                o_alu_b      = `ALU_B_FOUR;
                o_result_mux = `RESULT_PC4;
                o_imm        = imm_j;
                o_pc_src = `PC_SRC_PC_IMM;
            end

            default: begin
                // Unsupported opcode. May add illegal opcode specific flag for debugging purposes later.
            end
        endcase
    end
endmodule
