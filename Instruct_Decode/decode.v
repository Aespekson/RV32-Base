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

    wire [6:0] i_opcode = inst[6:0]; //Instruction opcode

    always @* begin
        // Default signals
        o_alu_op = 0;
        o_mem_write = 0;
        o_branch = 0;
        o_rs1_addr = 0;
        o_rs2_addr = 0;
        o_rd_addr = 0;
        o_result_mux = 0;
        o_reg_write = 0;
        case (i_opcode)
            `Rtype: begin
                //stuff
            end

            `Itype_A: begin
                //stuff
            end

            `Itype_L: begin
                //stuff
            end

            `Stype: begin
                //
            end

            `Btype: begin
                //
            end

            `Utype: begin
                //
            end

            `Jtype: begin
                //
            end
    end

endmodule
