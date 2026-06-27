`include "definitions.vh"

module instruction_memory #(
    parameter integer ADDR_WIDTH = $clog2(`INST_MEM_DEPTH)
) (
    input  wire [`INST_WIDTH-1:0] i_addr,
    output reg  [`INST_WIDTH-1:0] o_inst
);

    reg [`INST_WIDTH-1:0] memory [0:`INST_MEM_DEPTH-1];

    integer i;

    initial begin
        // Fill other addresses
        for (i = 0; i < `INST_MEM_DEPTH; i = i + 1)
            memory[i] = 32'h00000013; // addi x0, x0, 0
/*
        // Test program 1. Uncomment to load.
        memory[0] = 32'h00108113; // addi x2, x1, 1   // Adds value at x1 to 1 and stores at x2
        memory[1] = 32'h00108193; // addi x3, x1, 1   // Adds value at x1 to 1 and stores at x3
        memory[2] = 32'h00310233; // add  x4, x2, x3  // Adds x2 and x3 and stores at x4
        memory[3] = 32'hfe218ae3; // beq  x3, x2, -12 // Offsets PC by -12 if values at x3 and x2 equal.
*/
    end

    always @* begin
        o_inst = memory[i_addr[ADDR_WIDTH+1:2]];
    end

endmodule
