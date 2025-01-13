`include "Debounce.v"

`timescale  1ns / 1ps

module DebounceTB;


integer PERIOD  = 10;

reg   clk    = 1 ;
reg   rst_n  = 0 ;
reg   sw     = 0 ;

wire  out                                  ;


initial begin
    forever #(PERIOD/2)  clk=~clk;
end

initial begin
  rst_n = 1;
end

Debounce  u_Debounce (
    .clk   ( clk     ),
    .rst_n ( rst_n   ),
    .sw    ( sw      ),

    .out   ( out     )
);

integer i;

initial
begin
  $dumpfile("DebounceTb.vcd");
  $dumpvars(0, DebounceTB);

  for (i = 0; i < 10; i = i + 1) begin
    sw = 0;
    #PERIOD;
  end

  for (i = 0; i < 5; i = i + 1) begin
    sw = 0;
    #PERIOD;
    sw = 1;
    #PERIOD;
  end

  for (i = 0; i < 10; i = i + 1) begin
    sw = 1;
    #PERIOD;
  end

  for (i = 0; i < 5; i = i + 1) begin
    sw = 1;
    #PERIOD;
    sw = 0;
    #PERIOD;
  end

  for (i = 0; i < 10; i = i + 1) begin
    sw = 0;
    #PERIOD;
  end

  $finish;
end

endmodule
