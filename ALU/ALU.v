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
`define OP_ALU_SLT    8'b00110101 // Set Less Than (signed)
//`define OP_ALU_SLTU   8'b00110010 // Set Less Than (unsigned)  //Currently disabled. Sticking with just SLT for now
`define OP_ALU_SLL    8'b00110011 // Shift Left Logical
`define OP_ALU_SRL    8'b00110100 // Shift Right Logical
`define OP_ALU_SRA    8'b00110101 // Shift Right Arithmetic

// Additional operations outside basics (though still pretty basic). Includes RV32M operations (MUL,DIV)
// Will likely be expanded later
`define OP_ALU_INV    8'b00100100 // Bitwise Inversion (NOT operation)
`define OP_ALU_MUL    8'b00010011 // Multiplication
`define OP_ALU_DIV    8'b00010100 // Division
`define OP_ALU_MOD    8'b00010101 // Modulus

`define DATA_WIDTH 32

module alu (
    input wire [5:0] i_alu_op,
    input wire [31:0] i_a,
    input wire [31:0] i_b,
    output reg [31:0] o_c
);

    always @* begin
        case (i_alu_op)
            `OP_ALU_ADD:    o_c = i_a + i_b;
            `OP_ALU_SUB:    o_c = i_a - i_b;
            `OP_ALU_AND:    o_c = i_a&i_b;
            `OP_ALU_OR:     o_c = i_a|i_b;
            `OP_ALU_XOR:    o_c = (i_a|i_b)&(~(i_a&i_b));
            `OP_ALU_SLT:
            begin
                if(i_a<i_b) o_c = 1;
                else o_c = 0;
            end
            /*`OP_ALU_SLTU:
            begin
                if($signed(i_a) < $signed(i_b)) o_c = 1;
                else o_c = 0;
            end*/
            `OP_ALU_SLL:    o_c = i_a << i_b[4:0];
            `OP_ALU_SRL:    o_c = i_a >> i_b[4:0];
            `OP_ALU_SRA:    o_c = $signed(i_a) >>> i_b[4:0];
            `OP_ALU_INV:    o_c = ~i_a;
            `OP_ALU_MUL:    ;
            `OP_ALU_DIV:    ;
            `OP_ALU_MOD:    ;
            default: o_c = 0;
        endcase
    end

endmodule

//(i_a < i_b) ? 32'h1 : 32'h0
