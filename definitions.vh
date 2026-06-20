`ifndef DEFINITIONS_VH // If DEFINITIONS_VH is not defined, define it as follows.
`define DEFINITIONS_VH // Apparently considered good practice in larger projects so as to avoid defining it multiple times.

// Testbench utilities
`define assert(signal, value) \
if ((signal) !== (value)) begin \
    $display("FAIL: %s expected=%h got=%h time=%0t", \
    `"signal`", value, signal, $time); \
    $finish; \
    end
    // Debugging has been fine so far, but this might be easier than manually checking the tb for expected and actual values

    // Various constants so that the rationale for length is immediately (or quickly) apparent
    `define DATA_WIDTH 32
    `define INST_WIDTH 32
    `define NUM_REGISTER 32
    `define REG_ADDR_WIDTH 5
    `define ALU_OP_WIDTH 7
    `define FUNCT7_WIDTH 7

    // Branch opcodes. Conditional branch values match funct3.
    `define BRANCH_BEQ 3'b000 // Branch Equal
    `define BRANCH_BNE 3'b001 // Branch Not Equal
    `define BRANCH_BLT 3'b100 // Branch Less Than
    `define BRANCH_BGE 3'b101 // Branch Greater Than Or Equal
    `define BRANCH_BLTU 3'b110 // Branch Less Than Unsigned
    `define BRANCH_BGEU 3'b111 // Branch Greater Than Or Equal Unsigned
    `define BRANCH_JAL_JALR 3'b010 // Jump in case of JAL or JALR instruction
    // opcodes above are from funct3 field. Be careful with 010. It is not specified as a branch code in specs

    // Next-PC control. Used in the decoder to disambiguate next target.
    `define PC_SRC_PC4      2'b00 //+4
    `define PC_SRC_PC_IMM   2'b01 //JAL
    `define PC_SRC_RS1_IMM  2'b10 //JALR

    // RV32I opcodes
    `define Rtype       7'b0110011
    `define Itype_A     7'b0010011 // Integer register-immediate ALU ops
    `define Itype_L     7'b0000011 // Loads
    `define Stype       7'b0100011 // Stores
    `define Btype       7'b1100011 // Conditional branches
    `define Utype       7'b0110111 // LUI
    `define Utype_AUIPC 7'b0010111 // AUIPC
    `define Jtype       7'b1101111 // JAL
    `define Itype_JALR  7'b1100111 // JALR
    `define Itype_SYS   7'b1110011 // SYSTEM; currently decoded as unsupported/NOP

    // ALU operand-A select. Values are placed in o_alu_a[1:0].
    `define ALU_A_RS1 2'b00
    `define ALU_A_PC  2'b01
    `define ALU_A_ZERO 2'b10

    // ALU operand-B select. Values are placed in o_alu_b[1:0].
    `define ALU_B_RS2 2'b00
    `define ALU_B_IMM 2'b01
    `define ALU_B_FOUR 2'b10

    // Writeback/result mux select.
    `define RESULT_ALU 2'b00
    `define RESULT_MEM 2'b01
    `define RESULT_PC4 2'b10
    `define RESULT_IMM 2'b11

    // ALU ops
    // Note: first three bits define type (arithmetic, logic, other)
    // Latter four bits specify specific operation within type.
    `define OP_ALU_NOP    7'b0000000 // Zero/"Universal Identity" operation
    `define OP_ALU_ADD    7'b0010001 // Add
    `define OP_ALU_SUB    7'b0010010 // Subtract
    `define OP_ALU_AND    7'b0100001 // Bitwise AND
    `define OP_ALU_OR     7'b0100010 // Bitwise OR
    `define OP_ALU_XOR    7'b0100011 // Bitwise XOR
    `define OP_ALU_SLT    7'b0110001 // Set Less Than (signed)
    `define OP_ALU_SLTU   7'b0110010 // Set Less Than (unsigned)
    `define OP_ALU_SLL    7'b0110011 // Shift Left Logical
    `define OP_ALU_SRL    7'b0110100 // Shift Right Logical
    `define OP_ALU_SRA    7'b0110101 // Shift Right Arithmetic

    // Additional operations outside basics (though still pretty basic). Includes RV32M operations (MUL,DIV) and custom operations
    // Will likely be expanded later
    `define OP_ALU_INV    7'b0100100
    `define OP_ALU_MUL    7'b0010011
    `define OP_ALU_DIV    7'b0010100
    `define OP_ALU_MOD    7'b0010101

    `endif// Put all future additions to the file above here.
