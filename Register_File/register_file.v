`define DATA_WIDTH 32
`define NUM_REGISTER 32 //Some reliance on these macros were removed from other modules, but it has the value of adjusting automatically if I wish to change them, so those will be reintroduced there later.

module register_file(
  input wire clk,
  input wire we,
  input wire rst,
  input wire [$clog2(`NUM_REGISTER)-1:0] rd_addr,
  input wire [`DATA_WIDTH-1:0] rd,
  input wire [$clog2(`NUM_REGISTER)-1:0] rs1_addr,
  input wire [$clog2(`NUM_REGISTER)-1:0] rs2_addr,
  output logic [`DATA_WIDTH-1:0] rs1,
  output logic [`DATA_WIDTH-1:0] rs2);


  reg [31:0] registers [31:0]; //Registers declared as nested (2-dim) array. Do not be mistaken; the former 31 comes from the number of registers (32) while the latter comes from the data width of 32.
  integer i;

  initial begin //Important that this only valid in simulation for testing
      for (i = 0; i < `NUM_REGISTER; i = i + 1) begin //Not really necessary but avoids leaving things undefined.
          registers[i] = 32'h00000000;
      end
      registers[1] = 2;
      registers[2] = 3;
      registers[29] = 3;
      registers[30] = 2;
      registers[31] = 1;
  end

  always_comb begin
    if (rs1_addr == 0) rs1 = 0;
    else rs1 = registers[rs1_addr];
    if (rs2_addr == 0) rs2 = 0; // x0 hardwired to 0
    else rs2 = registers[rs2_addr];
  end
  // Note: Same-cycle read-write behavior is not defined here. This will likely be addressed later via forwarding in the decoder module.
  always_ff @(posedge clk) begin
    if (we && rd_addr!=0) registers[rd_addr] = rd;
  end

endmodule
