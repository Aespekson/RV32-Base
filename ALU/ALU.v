// Note on operation codes (numbers right of definition)
// First four bits define class (arithmetic, logic, and, for lack of better terminology, setting operations (abs, SLT, SLL, etc))
// Latter four bits specify sub operation within each class (add, sub, and, etc)

// RISC-V ALU Operations
`define OP_ALU_NOP    7'b00000000 // Zero/"Universal Identity" operation
`define OP_ALU_ADD    7'b0010001 // Add
`define OP_ALU_SUB    7'b0010010 // Subtract
`define OP_ALU_AND    7'b0100001 // Bitwise AND
`define OP_ALU_OR     7'b0100010 // Bitwise OR
`define OP_ALU_XOR    7'b0100011 // Bitwise XOR
`define OP_ALU_SLT    7'b0110001 // Set Less Than (signed)
//`define OP_ALU_SLTU   8'b00110010 // Set Less Than (unsigned)  //Currently disabled. Sticking with just SLT for now
`define OP_ALU_SLL    7'b0110011 // Shift Left Logical
`define OP_ALU_SRL    7'b0110100 // Shift Right Logical
`define OP_ALU_SRA    7'b0110101 // Shift Right Arithmetic

// Additional operations outside basics (though still pretty basic). Includes RV32M operations (MUL,DIV) and custom operations
// Will likely be expanded later
`define OP_ALU_INV    7'b0100100 // Bitwise Inversion (NOT operation)
`define OP_ALU_MUL    7'b0010011 // Multiplication
`define OP_ALU_DIV    7'b0010100 // Division
`define OP_ALU_MOD    7'b0010101 // Modulus

`define DATA_WIDTH 32

module alu (
    input wire [7:0] i_alu_op,
    input wire [`DATA_WIDTH-1:0] i_a,
    input wire [`DATA_WIDTH-1:0] i_b,
    output reg [`DATA_WIDTH-1:0] o_c
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
            `OP_ALU_MUL:
            begin
                logic [63:0] prod;
                prod = $signed(i_a) * $signed(i_b);
                o_c  = prod[`DATA_WIDTH-1:0];
            end
            `OP_ALU_DIV:
            begin
                if (i_b == 32'h0) o_c = 32'hffffffff;
                else if (i_a == 32'h80000000 && i_b == 32'hffffffff) o_c = 32'h80000000;
                else o_c = $signed(i_a) / $signed(i_b);
            end
            `OP_ALU_MOD:
            begin
                if (i_b == 32'h0) o_c = i_a;
                else if (i_a == 32'h8000_0000 && i_b == 32'hffff_ffff) o_c = 32'h0;
                else o_c = $signed(i_a) % $signed(i_b);
            end

            default: o_c = 0;
        endcase
    end

endmodule

//(i_a < i_b) ? 32'h1 : 32'h0
