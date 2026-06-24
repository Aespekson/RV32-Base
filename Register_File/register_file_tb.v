`define DATA_WIDTH 32
`define NUM_REGISTER 32 //Some reliance on these macros were removed from other modules, but it has the value of adjusting automatically if I wish to change them, so those will be reintroduced there later.

`define assert(signal, value) \
        if (signal !== value) $finish;

module register_file_tb;

  reg clk;
  reg we;
  reg rst;

  reg [$clog2(`NUM_REGISTER)-1:0] write_addr = 5'b00000;
  reg [$clog2(`NUM_REGISTER)-1:0] rs1_addr = 5'b00000;
  reg [$clog2(`NUM_REGISTER)-1:0] rs2_addr = 5'b00000;

  reg [`DATA_WIDTH-1:0] write_data = 32'h00000000;
  wire [`DATA_WIDTH-1:0] rs1;
  wire [`DATA_WIDTH-1:0] rs2;

  reg success = 1'b0; // It's easier to read a signal to check if it is successful on GTKWave than to look at every operation each time.

register_file dut (
    .clk(clk),
    .we(we),
    .rst(rst),
    .write_addr(write_addr),
    .write_data(write_data),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rs1(rs1),
    .rs2(rs2)
    );

  initial begin
    clk = 0;
    we = 0;
    rst = 1;
    rs1_addr = 5'b00000;
    rs2_addr = 5'b00000;
  @(negedge clk);
    rst = 1'b0;
  @(negedge clk);
    `assert(dut.rs1,32'h00000000)
    `assert(dut.rs2,32'h00000000)

  //The following has been added because the original test register intialization (kept in an initial block for simulation only) was moved to the always_ff block for synthesizability, and as such, the read will be tested after we have written the data via the tb. This, unfortunately, does not test the read independently of the write, but it was tested before, and the logic is small enough that it should be perfectly fine.
  @(negedge clk)
    we = 1'b1;// write_addr does not change independently of write_data, so there should be no danger of keeping write enabled until the end.
    write_addr = 5'b00001;
    write_data = 2;
  @(negedge clk)
    write_addr = 5'b00010;
    write_data = 3;
  // End of writing for read testing.

  @(negedge clk)
    rs1_addr = 5'b00001;
    rs2_addr = 5'b00010;
  @(negedge clk);
    `assert(dut.rs1,2)
    `assert(dut.rs2,3)
    rs1_addr = 5'b11111;
    rs2_addr = 5'b00000;
    write_addr = 5'b11111;
    write_data = 32'h00000010;
  @(negedge clk);
    `assert(dut.rs1,32'h00000010);
    `assert(dut.rs2,32'h00000000);
    success = 1'b1;
  #5;
  $finish;
  end

  always #5 clk = ~clk;

  initial begin
    $dumpfile("Register_File/wave.vcd");
    $dumpvars;
  end
endmodule
