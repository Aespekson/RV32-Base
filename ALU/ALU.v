// Note on operation codes (numbers right of definition)
// First three bits define class (arithmetic, logic, and, for lack of better terminology, setting operations (abs, SLT, SLL, etc))
// Latter three bits specify sub operation within each class (add, sub, and, etc)

// RISC-V ALU Operations
`define OP_ALU_NOP    6'b000000 // Zero/"Universal Identity" operation
`define OP_ALU_ADD    6'b001001 // Add
`define OP_ALU_SUB    6'b001010 // Subtract
`define OP_ALU_AND    6'b010001 // Bitwise AND
`define OP_ALU_OR     6'b010011 // Bitwise OR
`define OP_ALU_XOR    6'b010100 // Bitwise XOR
`define OP_ALU_SLT    6'b011001 // Set Less Than (signed)
//`define OP_ALU_SLTU   6'b011010 // Set Less Than (unsigned)  //Currently disabled. Sticking with just SLT for now
`define OP_ALU_SLL    6'b011011 // Shift Left Logical
`define OP_ALU_SRL    6'b011100 // Shift Right Logical
`define OP_ALU_SRA    6'b011101 // Shift Right Arithmetic

// Additional operations outside basics (though still pretty basic). Includes RV32M operations (MUL,DIV)
// Will likely be expanded later
`define OP_ALU_INV    6'b001110 // Bitwise Inversion (NOT operation)
`define OP_ALU_MUL    6'b001011 // Multiplication
`define OP_ALU_DIV   6'b001100 // Division

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
            default: o_c = 0;
        endcase
    end

endmodule

//(i_a < i_b) ? 32'h1 : 32'h0
