`include "Debounce.v"

`timescale 1ns / 1ps
`define CYCLE 10

module DebounceTB;

  /////////////////////////
  // Signal Declarations //
  /////////////////////////
  reg  clk_i   = 1'b1;
  reg  rst_ni  = 1'b0;
  reg  raw_sig_i    = 1'b0;
  wire debounce_sig_o;

  //////////////////////
  // Clock Generation //
  //////////////////////
  always #(`CYCLE/2) clk_i = ~clk_i;

  ///////////////////////
  // DUT Instantiation //
  ///////////////////////
  Debounce u_Debounce (
    .clk_i            (clk_i),
    .rst_ni           (rst_ni),
    .raw_sig_i        (raw_sig_i),
    .debounce_sig_o   (debounce_sig_o)
  );

  ///////////////
  // Test Task //
  ///////////////
  task hold_sw(input reg value, input integer cycles);
    begin
      repeat (cycles) @(negedge clk_i) raw_sig_i = value;
    end
  endtask

  task toggle_sw(input integer cycles);
    begin
      repeat (cycles) @(negedge clk_i) raw_sig_i = ~raw_sig_i;
    end
  endtask

  ////////////////////////
  // Main Test Sequence //
  ////////////////////////
  initial begin
    $dumpfile("DebounceTB.vcd");
    $dumpvars(0, DebounceTB);

    rst_ni = 1'b0;
    #(2 * `CYCLE);
    rst_ni = 1'b1;

    hold_sw(1'b0, 10);   // Hold raw_sig_i at 0 for 10 cycles
    toggle_sw(10);       // Toggle raw_sig_i every period for 10 cycles
    hold_sw(1'b1, 10);   // Hold raw_sig_i at 1 for 10 cycles
    toggle_sw(6);        // Toggle raw_sig_i every period for 6 cycles
    hold_sw(1'b0, 10);   // Hold raw_sig_i at 0 for 10 cycles

    $finish;
  end

endmodule
