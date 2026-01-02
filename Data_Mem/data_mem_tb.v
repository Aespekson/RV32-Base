`define assert(signal, value) \
        if (signal !== value) $finish;

module  dat_memory_tb;

  localparam MEM_SIZE = 1024;

  reg clk;
  reg we;
  reg [31:0] i_data = 32'h00000000;
  reg [31:0] addr = 32'h00000000;

  wire [31:0] o_data;

  data_memory dut (
    .clk(clk),
    .we(we),
    .addr(addr),
    .wdata(wdata),
    .rdata(rdata)
  );

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
        we = 1'b0;
    #100;
        addr = 32'h00000004;
        `assert(dut.rdata, 32'h00000000);
    #10;
        addr = 32'h00000008;
        `assert(dut.rdata, 32'h00000001);
    #10;
        //Write Data
        we = 1'b1;
        addr = 32'h00000000;
        i_data = 32'h00000001;
        `assert(dut.rdata, 32'h00000002);
    #10;
        `assert(dut.rdata, 32'h00000001);
    $finish;

  end

  initial begin
    $dumpfile("Data_Mem/wave.vcd");
    $dumpvars;
  end



endmodule
/*
  always @(posedge clk) begin
    $display("time %2t, clk = %b, we = %b, addr = %3h, i_data = %8h, o_data = %8h", $time, clk, we, addr, i_data, o_data);
  end
*/
