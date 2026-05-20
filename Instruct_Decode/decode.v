`include "definitions.vh"

module decode (
    input wire[`INST_WIDTH-1:0] inst,

    output reg [`FUNCT7_WIDTH-1:0] o_alu_op,
    output reg [`DATA_WIDTH-1:0] o_alu_a,
    output reg [`DATA_WIDTH-1:0] o_alu_b,

    output reg o_branch,
    output reg [2:0] o_branch_op,
    output wire [`FUNCT7_WIDTH-1:0] o_opcode,
    output reg [1:0] o_result_mux,
    output reg o_reg_write,
    output wire [$clog2(`NUM_REGISTER)-1:0] o_rs1_addr,
    output wire [$clog2(`NUM_REGISTER)-1:0] o_rs2_addr,
    output wire [$clog2(`NUM_REGISTER)-1:0] o_rd_addr,

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
