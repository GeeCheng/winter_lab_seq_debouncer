`define TRANSFER    1'b1
`define DELAY       1'b0
`define DELAY_CNT   2'd3  // only for simulation

module Debounce(
  input  wire clk,
  input  wire rst_n,
  input  wire sw,
  output reg  out
);

  reg       state;
  reg [1:0] delay_cnt;
  reg       previous_sw;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= `TRANSFER;
      delay_cnt <= `DELAY_CNT;
      previous_sw <= 1'b0;
      out <= 1'b0;
    end else begin
      case (state)
        `TRANSFER: begin
          if (sw != previous_sw) begin
            state <= `DELAY;
            delay_cnt <= `DELAY_CNT;
          end
          previous_sw <= sw;
          out <= sw;
        end
        `DELAY: begin
          if (delay_cnt == 0) begin
            state <= `TRANSFER;
          end else begin
            delay_cnt <= delay_cnt - 1;
          end
          out <= previous_sw;
        end
        default: begin
          state <= `TRANSFER;
          delay_cnt <= `DELAY_CNT;
          previous_sw <= 1'b0;
          out <= 1'b0;
        end
      endcase
    end
  end

endmodule
