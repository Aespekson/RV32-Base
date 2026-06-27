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
        // Test program 1. Uncomment to load a particular program.
        memory[0] = 32'h00108113; // addi x2, x1, 1   // Adds value at x1 to 1 and stores at x2
        memory[1] = 32'h00108193; // addi x3, x1, 1   // Adds value at x1 to 1 and stores at x3
        memory[2] = 32'h00310233; // add  x4, x2, x3  // Adds x2 and x3 and stores at x4
        memory[3] = 32'hfe218ae3; // beq  x3, x2, -12 // Offsets PC by -12 if values at x3 and x2 equal.
*/
/*
        // Test program 2.
        memory[0]  = 32'h01400093; // addi x1,  x0, 20
        memory[1]  = 32'h00600113; // addi x2,  x0, 6
        memory[2]  = 32'h402081b3; // sub  x3,  x1, x2
        memory[3]  = 32'h0020f233; // and  x4,  x1, x2
        memory[4]  = 32'h0020e2b3; // or   x5,  x1, x2
        memory[5]  = 32'h0020c333; // xor  x6,  x1, x2
        memory[6]  = 32'h00200413; // addi x8,  x0, 2
        memory[7]  = 32'h008113b3; // sll  x7,  x2, x8
        memory[8]  = 32'h0080d4b3; // srl  x9,  x1, x8
        memory[9]  = 32'hff000513; // addi x10, x0, -16
        memory[10] = 32'h408555b3; // sra  x11, x10, x8
        memory[11] = 32'h0000006f; // jal  x0, 0
*/
/*
        // Test program 3.
        memory[0] = 32'hfff00093; // addi  x1, x0, -1
        memory[1] = 32'h0010a113; // slti  x2, x1, 1
        memory[2] = 32'h0010b193; // sltiu x3, x1, 1
        memory[3] = 32'h0ff0c213; // xori  x4, x1, 8'hff
        memory[4] = 32'h15506293; // ori   x5, x0, 12'h155
        memory[5] = 32'h00f2f313; // andi  x6, x5, 4'hf
        memory[6] = 32'h00331393; // slli  x7, x6, 3
        memory[7] = 32'h0023d413; // srli  x8, x7, 2
        memory[8] = 32'h4040d493; // srai  x9, x1, 4
        memory[9] = 32'h0000006f; // jal   x0, 0
*/
/*
        // Test program 4.
        memory[0]  = 32'hfff00093; // addi x1, x0, -1
        memory[1]  = 32'h00100113; // addi x2, x0, 1

        memory[2]  = 32'h0020c463; // blt  x1, x2, +8; taken
        memory[3]  = 32'h06300193; // addi x3, x0, 99; skipped
        memory[4]  = 32'h00100193; // addi x3, x0, 1

        memory[5]  = 32'h00115463; // bge  x2, x1, +8; taken
        memory[6]  = 32'h06300213; // addi x4, x0, 99; skipped
        memory[7]  = 32'h00100213; // addi x4, x0, 1

        memory[8]  = 32'h00116463; // bltu x2, x1, +8; taken
        memory[9]  = 32'h06300293; // addi x5, x0, 99; skipped
        memory[10] = 32'h00100293; // addi x5, x0, 1

        memory[11] = 32'h0020f463; // bgeu x1, x2, +8; taken
        memory[12] = 32'h06300313; // addi x6, x0, 99; skipped
        memory[13] = 32'h00100313; // addi x6, x0, 1

        memory[14] = 32'h00629463; // bne  x5, x6, +8; not taken
        memory[15] = 32'h00100393; // addi x7, x0, 1; executed

        memory[16] = 32'h00628463; // beq  x5, x6, +8; taken
        memory[17] = 32'h06300413; // addi x8, x0, 99; skipped
        memory[18] = 32'h00100413; // addi x8, x0, 1

        memory[19] = 32'h0000006f; // jal x0, 0
*/
/*
        // Test program 5.
        memory[0] = 32'h123450b7; // lui   x1, 0x12345
        memory[1] = 32'h00001117; // auipc x2, 0x1
        memory[2] = 32'h008001ef; // jal   x3, +8
        memory[3] = 32'h06300213; // addi  x4, x0, 99; skipped
        memory[4] = 32'h00400213; // addi  x4, x0, 4

        memory[5] = 32'h02000293; // addi  x5, x0, 32
        memory[6] = 32'h00028367; // jalr  x6, x5, 0
        memory[7] = 32'h06300393; // addi  x7, x0, 99; skipped
        memory[8] = 32'h00700393; // addi  x7, x0, 7

        memory[9] = 32'h0000006f; // jal x0, 0
*/
/*
        // Test program 6.
        memory[0] = 32'h02500113; // addi x2, x0, 37
        memory[1] = 32'h00202023; // sw   x2, 0(x0)
        memory[2] = 32'h00002183; // lw   x3, 0(x0)
        memory[3] = 32'h00518213; // addi x4, x3, 5
        memory[4] = 32'h00402223; // sw   x4, 4(x0)
        memory[5] = 32'h00402283; // lw   x5, 4(x0)
        memory[6] = 32'h0000006f; // jal  x0, 0
*/
    end

    always @* begin
        o_inst = memory[i_addr[ADDR_WIDTH+1:2]];
    end

endmodule
