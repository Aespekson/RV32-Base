`define assert(signal, value) \
        if (signal !== value) $finish;

`timescale 1ns/1ns

`define INST_WIDTH 32

module  decode_tb;

  reg clk;
  reg [`INST_WIDTH-1:0] inst = 32'h00000000;

  wire [7:0] o_alu_op;
  wire [31:0] o_alu_a;
  wire [31:0] o_alu_b;
  wire o_mem_write;
//Add more wire outputs after completing other components that require them


  decode dut (
    .inst(inst),
    .o_alu_op(o_alu_op),
    .o_alu_a(o_alu_a),
    .o_alu_b(o_alu_b),
    .o_mem_write(o_mem_write)
  );

  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
    inst = 32'h00000000;
  #10
    inst = 32'hAAAAAAAA;
  #11
    $finish;

  end

  initial begin
    $dumpfile("Instruct_Decode/wave.vcd");
    $dumpvars;
  end

endmodule
