

module register_file_tb;

reg clk;
wire we,
wire rst,
wire [4:0] rd_addr,
wire [4:0] rs1_addr.
wire [4:0] rs2_addr,
wire [31:0] rs1,
wire [31:0] rs2

register_file dut (
    .clk(clk)
    .we(we)
    .rst(rst)
    .rd_addr(rd_addr)
    .rs1_addr(rs1_addr)
    .rs2_addr(rs2_addr)
    .rs1(rs1)
    .rs2(rs2))


