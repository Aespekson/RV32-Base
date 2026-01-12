

module register_file(
  input wire clk,
  input wire we,
  input wire rst,
  input wire [4:0] rd_addr,
  input wire [4:0] rs1_addr.
  input wire [4:0] rs2_addr,
  output wire [31:0] rs1,
  output wire [31:0] rs2);
