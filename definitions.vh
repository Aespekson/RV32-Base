// Testbench utilities:
`define assert(signal, value) \
if (signal !== value) $finish;

`define DATA_WIDTH 32
`define INST_WIDTH 32
`define NUM_REGISTER 32
`define FUNCT7_WIDTH 7


// Instruction opcodes (identify type of instruction being fetched)
//From included image of RV32I base instruction set
`define Rtype       7'b0110011
`define Itype_A     7'b0010011 //Arithmetic
`define Itype_L     7'b0000011 //Load
`define Stype       7'b0100011
`define Btype       7'b1100011
`define Utype       7'b0110111
`define Jtype       7'b1101111
`define Utype_AUIPC 7'b0010111 // Add upper immediate to PC
`define Itype_JALR  7'b1100111
`define Utype_AUIPC 7'b0010111
`define Itype_JALR  7'b1100111
`define Itype_SYS   7'b1110011
//`define Itype_FENCE 7'b0001111 //Not really necessary as of the current implementation


//Branch opcodes
`define BRANCH_BEQ 3'b000 // Branch Equal
`define BRANCH_BNE 3'b001 // Branch Not Equal
`define BRANCH_BLT 3'b100 // Branch Less Than
`define BRANCH_BGE 3'b101 // Branch Greater Than Or Equal
`define BRANCH_BLTU 3'b110 // Branch Less Than Unsigned
`define BRANCH_BGEU 3'b111 // Branch Greater Than Or Equal Unsigned
`define BRANCH_JAL_JALR 3'b010 // Jump in case of JAL or JALR instruction
// opcodes above are from funct3 field. Be careful with 010. It is not specified as a branch code in specs


// Note on operation codes for ALU
// First four bits define class (arithmetic, logic, and, for lack of better terminology, setting operations (abs, SLT, SLL, etc))
// Latter four bits specify sub operation within each class (add, sub, and, etc)

//ALU ops
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
`define OP_ALU_INV    7'b0100100 // Bitwise Inversion (NOT operation)
`define OP_ALU_MUL    7'b0010011 // Multiplication
`define OP_ALU_DIV    7'b0010100 // Division
`define OP_ALU_MOD    7'b0010101 // Modulus
