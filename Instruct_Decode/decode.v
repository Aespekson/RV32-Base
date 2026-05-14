// Note on operation codes (numbers right of definition)
// First four bits define class (arithmetic, logic, and, for lack of better terminology, setting operations (abs, SLT, SLL, etc))
// Latter four bits specify sub operation within each class (add, sub, and, etc)

// RISC-V ALU Operations
`define OP_ALU_NOP    8'b00000000 // Zero/"Universal Identity" operation
`define OP_ALU_ADD    8'b00010001 // Add
`define OP_ALU_SUB    8'b00010010 // Subtract
`define OP_ALU_AND    8'b00100001 // Bitwise AND
`define OP_ALU_OR     8'b00100010 // Bitwise OR
`define OP_ALU_XOR    8'b00100011 // Bitwise XOR
`define OP_ALU_SLT    8'b00110001 // Set Less Than (signed)
//`define OP_ALU_SLTU   8'b00110010 // Set Less Than (unsigned)  //Currently disabled. Sticking with just SLT for now
`define OP_ALU_SLL    8'b00110011 // Shift Left Logical
`define OP_ALU_SRL    8'b00110100 // Shift Right Logical
`define OP_ALU_SRA    8'b00110101 // Shift Right Arithmetic

// Additional operations outside basics (though still pretty basic). Includes RV32M operations (MUL,DIV) and custom operations
// Will likely be expanded later
`define OP_ALU_INV    8'b00100100 // Bitwise Inversion (NOT operation)
`define OP_ALU_MUL    8'b00010011 // Multiplication
`define OP_ALU_DIV    8'b00010100 // Division
`define OP_ALU_MOD    8'b00010101 // Modulus

`define DATA_WIDTH 32

`define INST_WIDTH 32 //32 bit instructions

//Going to need all definitions above + more

module decode (
    input wire[`INST_WIDTH-1:0] inst,

    output reg [7:0] o_alu_op,
    output reg [31:0] o_alu_a,
    output reg [31:0] o_alu_b,
    output reg o_mem_write
);

    reg ran;

    always @* begin
        o_alu_op = 0;
        o_alu_a = inst;//Temporary, to test that it runs
        o_alu_b = inst;
        o_mem_write = 0;
        // Add more default signals later when we actually have the modules we need.

    end

endmodule
