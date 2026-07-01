`include "definitions.vh"

module register_file(
  input wire clk,
  input wire we,
  input wire rst,
  input wire [$clog2(`NUM_REGISTER)-1:0] write_addr,
  input wire [`DATA_WIDTH-1:0] write_data,
  input wire [$clog2(`NUM_REGISTER)-1:0] rs1_addr,
  input wire [$clog2(`NUM_REGISTER)-1:0] rs2_addr,
  output reg [`DATA_WIDTH-1:0] rs1,
  output reg [`DATA_WIDTH-1:0] rs2
  );

  reg [`DATA_WIDTH-1:0] registers [`NUM_REGISTER-1:0];
  integer i;

  always @* begin
    if (rs1_addr == 0) rs1 = 0;
    else rs1 = registers[rs1_addr];
    if (rs2_addr == 0) rs2 = 0; // x0 hardwired to 0
    else rs2 = registers[rs2_addr];
  end

  always @(posedge clk) begin
    if (rst) begin
      for (int i = 0; i < `NUM_REGISTER; i++)
        registers[i]<= 32'h00000000;
    end else if (we && write_addr!=0)
      registers[write_addr] <= write_data;
  end

endmodule
