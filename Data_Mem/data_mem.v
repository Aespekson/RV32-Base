`define DATA_WIDTH 32

module data_memory #(
    parameter MEM_SIZE = 1024 //words
) (
    input wire clk,
    input wire we,
    input wire [31:0] waddr,
    input wire [31:0] raddr,
    input wire [31:0] wdata,
    output reg [31:0] rdata
);

    reg [31:0] memory [0:MEM_SIZE-1];
    integer i;

    initial begin
        //Initializing all words; having undefined memory bothers me, even if I don't see it.
        for (i = 0; i < MEM_SIZE; i = i + 1) memory[i] = 32'h0;
        memory[0] = 32'h00000000;
        memory[1] = 32'h00000001;
        memory[2] = 32'h00000010;
        memory[3] = 32'h00000100;
        memory[4] = 32'h00001000;
    end

    // Assigning new wires to widx and ridx for convenience.
    wire [$clog2(MEM_SIZE)-1:0] widx = waddr[31:2];
    wire [$clog2(MEM_SIZE)-1:0] ridx = raddr[31:2];

    // Write iff we && on positive edge of clk
    //Read implemented and fixed.
    always @(posedge clk) begin
        if (we) memory[widx] <= wdata;

        // Write first if raddr = waddr on the same cycle
        if (we && (widx == ridx)) rdata <= wdata;
        else rdata <= memory[ridx];
    end

endmodule
