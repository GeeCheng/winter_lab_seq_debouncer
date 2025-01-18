`define TRANSFER    1'b1
`define DELAY       1'b0
`define DELAY_CNT   2'd3  // only for simulation

module Debounce(
  input  wire clk,
  input  wire rst_n,
  input  wire sw,
  output reg  out
);

  reg       state, next_state;
  reg [1:0] delay_cnt, next_delay_cnt;
  reg       previous_sw;
  reg       out_next;

  // Combinational logic for state transitions and outputs
  always @(*) begin
    case (state)
      `TRANSFER: begin
        if (sw != previous_sw) begin
          next_state       = `DELAY;
        end else begin
          next_state       = `TRANSFER;
        end
        next_delay_cnt   = `DELAY_CNT;
        out_next         = sw;
      end

      `DELAY: begin
        if (delay_cnt == 0) begin
          next_state = `TRANSFER;
          next_delay_cnt = `DELAY_CNT;
        end else begin
          next_state = `DELAY;
          next_delay_cnt = delay_cnt - 1;
        end
        out_next = previous_sw;
      end

      default: begin
        next_state       = `TRANSFER;
        next_delay_cnt   = `DELAY_CNT;
        out_next         = 1'b0;
      end
    endcase
  end

  // Sequential logic for state and registers
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state       <= `TRANSFER;
      delay_cnt   <= `DELAY_CNT;
      previous_sw <= 1'b0;
      out         <= 1'b0;
    end else begin
      state       <= next_state;
      delay_cnt   <= next_delay_cnt;
      previous_sw <= out_next;
      out         <= out_next;
    end
  end

endmodule
