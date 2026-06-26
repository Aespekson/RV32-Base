// All definitions moved to definitions.vh
`include "definitions.vh"

module branch_log ( // In short, determines whether a branch should be taken based on certain conditions. The condition is specified via operation code, similar to ALU, and evaluated based on operands a and b.
    input wire i_branch, // Enable signal
    input wire [2:0] i_branch_op,
    input wire [`DATA_WIDTH-1:0] i_a,
    input wire [`DATA_WIDTH-1:0] i_b,
    output reg o_take //Take branch or no
);

wire signed [`DATA_WIDTH-1:0] i_a_sin = i_a;
wire signed [`DATA_WIDTH-1:0] i_b_sin = i_b;

    always @* begin
        o_take = 0;
        if(i_branch) begin
            case (i_branch_op)
                `BRANCH_BEQ: begin
                    if(i_a == i_b) begin
                        o_take = 1;
                    end
                end

                `BRANCH_BNE: begin
                    if(i_a != i_b) begin
                        o_take = 1;
                    end
                end

                `BRANCH_BLT: begin
                    if(i_a_sin < i_b_sin) begin
                        o_take = 1;
                    end
                end

                `BRANCH_BGE: begin
                    if(i_a_sin >= i_b_sin) begin
                        o_take = 1;
                    end
                end

                `BRANCH_BLTU: begin
                    if(i_a < i_b) begin
                        o_take = 1;
                    end
                end

                `BRANCH_BGEU: begin
                    if(i_a >= i_b) begin
                        o_take = 1;
                    end
                end

              	`BRANCH_JAL_JALR: begin //Upon receiving appropriate instruction from deocde, will take branch, as is in-line with the instruction's use case.
              	//For JALR, later, remember the address jumped to is determined by ALU. Do not forget to wire that up. // Upon review, this is optional. It would lead to deduplication of hardware (only using one adder in the ALU rather than using a second elsewhere) but is not strictly necessary.
                    o_take = 1;
                end
                default: o_take = 0;
            endcase
        end
    end

endmodule
