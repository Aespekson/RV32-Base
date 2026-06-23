`include "definitions.vh"

module alu (
    input wire [`FUNCT7_WIDTH-1:0] i_alu_op,
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
            `OP_ALU_SLTU:
            begin
                if(i_a < i_b) o_c = 1;
                else o_c = 0;
            end
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
            `OP_ALU_NOP:// Explicit case for NOP rather than just relying on default
            begin
                o_c = 32'h0;
            end

            default: o_c = 0;
        endcase
    end

endmodule

//(i_a < i_b) ? 32'h1 : 32'h0
