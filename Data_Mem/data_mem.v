`define DATA_WIDTH 32

module data_memory #(
    // MEM_SIZE in Words (1024 * 4)
    parameter MEM_SIZE = 1024
) (
    input wire clk,
    input wire we,
    input wire [31:0] addr,
    input wire [`DATA_WIDTH-1:0] wdata,
    output wire [`DATA_WIDTH-1:0] rdata
);

    reg [`DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];
    integer i;

    initial begin
        memory[0] = 32'h00000000;
        memory[1] = 32'h00000001;
        memory[2] = 32'h00000002;
        memory[3] = 32'h00000003;
        memory[4] = 32'h00000004;
    end

    // Write iff we && on positive edge of clk
    always @(posedge clk) begin
    if (we)
        memory[addr[31:2]] <= wdata;
        end


endmodule
