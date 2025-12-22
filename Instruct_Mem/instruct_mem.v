`define INST_WIDTH 32

module instruction_memory (
    input wire [`INST_WIDTH:0] i_addr,
    output reg [`INST_WIDTH-1:0] o_inst
);

    reg [`INST_WIDTH-1:0] memory [0:`INST_WIDTH-1];

    initial begin
        memory[0] = 32'h00108113;
        memory[1] = 32'h00108193;
        memory[2] = 32'h00310233;
        memory[3] = 32'hfe218ae3;
        memory[4] = 32'h00000000;
    end

    always @* begin
        o_inst = memory[i_addr[`INST_WIDTH-1:2]];
    end
endmodule

/*(
    // MEM_SIZE in Words
    // Currently commented out because it doesn't seem to be necessary but I want to keep it just in case as a reminder
    // parameter MEM_SIZE = 1024
)*/
