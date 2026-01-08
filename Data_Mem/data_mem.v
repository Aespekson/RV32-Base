`define DATA_WIDTH 32

module data_memory #(
    // MEM_SIZE in Words (1024 * 4)
    parameter MEM_SIZE = 1024
) (
    input wire clk,
    input wire we,
    input wire [31:0] waddr,
    input wire [31:0] raddr,
    input wire [31:0] wdata,
    output wire [31:0] rdata
);

    reg [31:0] memory [0:MEM_SIZE-1];
    integer i;

    initial begin
        memory[0] = 32'h00000000;
        memory[1] = 32'h00000001;
        memory[2] = 32'h00000010;
        memory[3] = 32'h00000100;
        memory[4] = 32'h00001000;
    end

    // Write iff we && on positive edge of clk
    always @(posedge clk) begin
    if (we) memory[waddr[31:2]] <= wdata;
    end

endmodule
