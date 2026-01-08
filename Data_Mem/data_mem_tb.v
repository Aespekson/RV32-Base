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

  // A 12.9 GiB wave.vcd file was generated earlier. Hopefully, this will prevent that.
  // The cause was the wait_cycle clock value being passed by value to a task that was declared ouside the module. So, the task was moved inside and the clock was deparameterized, resulting in functional code.
  initial begin
    #1000;
    $display("WATCHDOG: timeout");
    $finish;
  end

  task wait_cycle;
    begin
        @(posedge clk);
        @(negedge clk);
    end
  endtask

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
        we = 0;
        waddr = 0;
        raddr = 0; //Not really necessary because it is reset right after, but initializing all of them is neater, I think.
        wdata = 0;
    // Logic and check timing fixed to be less arbitrary
    // Also to provide time for logic to be visible before checking results.
        raddr = 32'h00000004;
    @(negedge clk);
        `assert(rdata, 32'h00000001);
    @(posedge clk);
        raddr = 32'h00000008;
    wait_cycle; //Need to wait for the next posedge to pass so that the module changes rdata. Then, rdata can be checked on the negedge.
        `assert(dut.rdata, 32'h00000010);
    @(posedge clk);
        //Write Data
        we = 1'b1;
        waddr = 32'h0000000C;
        wdata = 32'h00000001;
    @(posedge clk);
        raddr = 32'h0000000C;
    wait_cycle;
        `assert(dut.rdata, 32'h00000001);
    $finish;
  end

initial begin
  $dumpfile("Data_Mem/wave.vcd");
  $dumpvars(0, dat_memory_tb);
end

endmodule
