module Debounce (
  input  wire clk_i,
  input  wire rst_ni,
  input  wire raw_sig_i,
  output reg  debounce_sig_o
);

  /////////////////////////////////////
  // Parameters and Local Parameters //
  /////////////////////////////////////
  parameter  TRANSFER   = 1'b1;
  parameter  DELAY      = 1'b0;
  localparam DELAY_CNT  = 2'd3;  // Only for simulation
  localparam END_DELAY  = 2'd0;  // Only for simulation

  //////////////////////////////////
  // State and Internal Registers //
  //////////////////////////////////
  reg state_q, state_d;
  reg [1:0] delay_cnt_q, delay_cnt_d;
  reg       prev_sw_q, prev_sw_d;
  reg       out_d;

  /////////////////////////
  // Combinational Logic //
  /////////////////////////
  always @(*) begin
    case (state_q)
      TRANSFER: begin
        state_d      = (raw_sig_i != prev_sw_q) ? DELAY : TRANSFER;
        delay_cnt_d  = DELAY_CNT;
        out_d        = raw_sig_i;
        prev_sw_d    = raw_sig_i;
      end

      DELAY: begin
        if (delay_cnt_q == END_DELAY) begin
          state_d      = TRANSFER;
          delay_cnt_d  = DELAY_CNT;
          out_d        = raw_sig_i;
          prev_sw_d    = raw_sig_i;
        end else begin
          state_d      = DELAY;
          delay_cnt_d  = delay_cnt_q - 1;
          out_d        = prev_sw_q;
          prev_sw_d    = prev_sw_q;
        end
      end

      default: begin
        state_d      = TRANSFER;
        delay_cnt_d  = DELAY_CNT;
        out_d        = 1'b0;
        prev_sw_d    = 1'b0;
      end
    endcase
  end

  //////////////////////
  // Sequential Logic //
  //////////////////////
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q        <= TRANSFER;
      delay_cnt_q    <= DELAY_CNT;
      prev_sw_q      <= 1'b0;
      debounce_sig_o <= 1'b0;
    end else begin
      state_q        <= state_d;
      delay_cnt_q    <= delay_cnt_d;
      prev_sw_q      <= prev_sw_d;
      debounce_sig_o <= out_d;
    end
  end

endmodule
