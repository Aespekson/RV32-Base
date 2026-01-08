`define assert(signal, value) \
        if (signal !== value) $finish;

module  dat_memory_tb;

  localparam MEM_SIZE = 1024;

  reg clk;
  reg we;
  reg [31:0] wdata = 32'h00000000;
  wire [31:0] rdata;
  reg [31:0] waddr = 32'h00000000;
  reg [31:0] raddr = 32'h00000000;

  data_memory dut (
    .clk(clk),
    .we(we),
    .raddr(raddr),
    .waddr(waddr),
    .wdata(wdata),
    .rdata(rdata)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
        we = 0;
        waddr = 0;
        raddr = 0;
        wdata = 0;
    // Logic and check timing fixed to be less arbitrary
    // Also to provide time for logic to be visible before checking results.
    @(posedge clk);
        raddr = 32'h00000004;
    @(negedge clk);
        `assert(rdata, 32'h00000001);
    @(posedge clk);
        raddr = 32'h00000008;
    @(negedge clk);
        `assert(dut.rdata, 32'h00000010);
    @(posedge clk);
        //Write Data
        we = 1'b1;
        waddr = 32'h00000000;
        wdata = 32'h00000001;
    @(negedge clk);
        `assert(dut.rdata, 32'h00000001);
    $finish;
  end

  initial begin
    $dumpfile("Data_Mem/wave.vcd");
    $dumpvars;
  end

endmodule
