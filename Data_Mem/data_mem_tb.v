`define assert(signal, value) \
        if (signal !== value) $finish;

module  dat_memory_tb;

  localparam MEM_SIZE = 1024;

  reg clk;
  reg we;
  reg [31:0] wdata = 32'h00000000;
  reg [31:0] rdata;
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

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
        we = 1'b0;
    #15;
        raddr = 32'h00000004;
        `assert(dut.rdata, 32'h00000000);
    #15;
        raddr = 32'h00000008;
        `assert(dut.rdata, 32'h00000001);
    #15;
        //Write Data
        we = 1'b1;
        waddr = 32'h00000000;
        wdata = 32'h00000001;
        `assert(dut.rdata, 32'h00000002);
    #15;
        `assert(dut.rdata, 32'h00000001);
    $finish;

  end

  initial begin
    $dumpfile("Data_Mem/wave.vcd");
    $dumpvars;
  end

endmodule
