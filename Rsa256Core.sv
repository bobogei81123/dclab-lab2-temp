module Rsa256Core(
	input i_clk,
	input i_rst,
	input i_start,
	input [255:0] i_a,
	input [255:0] i_d,
	input [255:0] i_n,
	output [255:0] o_a_pow_e,
	output o_finished
);

typedef logic [255:0] i256;
i256 a, d, n;
i256 ans_r, ans_w;

typedef enum {
  S_IDLE,
  S_CALC
} MainState;
MainState main_state_r, main_state_w;

assign o_finished = (main_state_r == S_IDLE);
assign o_a_pow_e = ans_r;

always_comb begin
  main_state_w = main_state_r;
  ans_w = ans_r;
  case (main_state_r)
    S_IDLE: begin
      main_state_w = i_start ? S_CALC : S_IDLE;
    end
    S_CALC: begin
      ans_w = a ^ d ^ n;
      main_state_w = S_IDLE;
    end
  endcase
end
  
always_ff @(posedge i_clk or posedge i_rst) begin
  if (i_rst) begin
    main_state_r <= S_IDLE;
    ans_r <= 0;
  end else begin
    main_state_r <= main_state_w;
    ans_r <= ans_w;

    if (i_start) begin
      a <= i_a;
      d <= i_d;
      n <= i_n;
    end
  end
end
endmodule
