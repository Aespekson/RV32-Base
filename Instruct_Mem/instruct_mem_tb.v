/*
Optional diagnostic check message I'm not using.
$display("CHECK FAILED at %2d in %m: signal != value", $time);
*/

`define check(signal, value) \
        if (signal !== value) $finish

module inst_mem_tb;

  localparam MEM_SIZE = 1024;
  reg [$clog2(MEM_SIZE)-1:0] addr = 32'h00000000;
  wire [`INST_WIDTH-1:0] inst;

  instruction_memory dut (
    .i_addr(addr),
    .o_inst(inst)
  );

  initial begin
    // Dumps
    $dumpfile("Instruct_Mem/wave.vcd");
    $dumpvars;

    //Checks
    #10;
    	`check(inst, 32'h00108113);
    #5;
        addr = 32'h00000004;
    #5;
    	`check(inst, 32'h00108193);
    #5;
        addr = 32'h00000008;
    #5;
    	`check(inst, 32'h00310233);
    #5;
        addr = 32'h0000000c;
    #5;
    	`check(inst, 32'hfe218ae3);
    #5;
        addr = 32'h00000010;
    #5;
        `check(inst, 32'h0000000);
    $finish;
  end

endmodule
/*
  always @* begin
    $display("time %2t, addr = %3h, inst = %8h", $time, addr, inst);
  end
*/
