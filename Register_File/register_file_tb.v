`define DATA_WIDTH 32
`define NUM_REGISTER 32 //Some reliance on these macros were removed from other modules, but it has the value of adjusting automatically if I wish to change them, so those will be reintroduced there later.

`define assert(signal, value) \
        if (signal !== value) $finish;

module register_file_tb;

reg clk;
reg we;
reg rst;
reg [$clog2(`NUM_REGISTER)-1:0] rd_addr = 32'h00000000;
reg [$clog2(`NUM_REGISTER)-1:0] rs1_addr = 32'h00000000;
reg [$clog2(`NUM_REGISTER)-1:0] rs2_addr = 32'h00000000;
reg [`DATA_WIDTH-1:0] rd = 32'h00000000;
wire [`DATA_WIDTH-1:0] rs1;
wire [`DATA_WIDTH-1:0] rs2;

register_file dut (
    .clk(clk),
    .we(we),
    .rst(rst),
    .rd_addr(rd_addr),
    .rd(rd),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rs1(rs1),
    .rs2(rs2)
    );

  initial begin
    clk = 0;
    we = 0;
    rst = 0;
    rs1_addr = 5'b00000;
    rs2_addr = 5'b00000;
  (@negedge clk);
    `assert(dut.rs1,32'h00000000)
    `assert(dut.rs1,32'h00000000)
  #5;
  $finish;
  end

  always #5 clk = ~clk;

  initial begin
    $dumpfile("Register_File/wave.vcd");
    $dumpvars;
  end
endmodule
