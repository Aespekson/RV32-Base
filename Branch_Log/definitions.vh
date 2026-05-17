// Testbenvh utilities:
`define assert(signal, value) \
if (signal !== value) $finish;

`define DATA_WIDTH 32


//Branch opcodes
`define BRANCH_BEQ 3'b000 // Branch Equal
`define BRANCH_BNE 3'b001 // Branch Not Equal
`define BRANCH_BLT 3'b100 // Branch Less Than
`define BRANCH_BGE 3'b101 // Branch Greater Than Or Equal
`define BRANCH_BLTU 3'b110 // Branch Less Than Unsigned
`define BRANCH_BGEU 3'b111 // Branch Greater Than Or Equal Unsigned
`define BRANCH_JAL_JALR 3'b010 // Jump in case of JAL or JALR instruction
// opcodes above are from funct3 field. Be careful with 010. It is not specified as a branch code in specs
