module Rsa256Core(
	input i_clk,
	input i_rst,
	input i_start,
	input [255:0] i_a,
	input [255:0] i_d,
	input [255:0] i_n,
	output [255:0] o_a_pow_e,
	output o_finished,
	output o_num
);

typedef logic [258:0] i256;
typedef logic [15:0] i16;

i256 a, d, n;
i256 ans_r, ans_w;

i256 cd_r, cd_w, ctemp_r, ctemp_w;
i16 ccount_r, ccount_w;

i256 ma_r, ma_w, mb_r, mb_w, mans_r, mans_w;
i16 mcount_r, mcount_w;


typedef enum {
  S_IDLE,
  S_BEGIN,
  S_CALC
} MainState;
MainState main_state_r, main_state_w;

typedef enum {
  S_IDLEC,
  S_BEGINC,
  S_PRESHIFTC,
  S_LOOP1C,
  S_WAIT1C,
  S_LOOP2C,
  S_WAIT2C,
  S_POSTSHIFTC
} CoreState;
CoreState core_state_r, core_state_w;

typedef enum {
  S_IDLEM,
  S_BEGINM,
  S_LOOPM,
  S_ENDM
} MultiplerState;
MultiplerState mult_state_r, mult_state_w;

logic [15:0] num_r, num_w;

assign o_finished = (main_state_r == S_IDLE);
assign o_a_pow_e = ans_r;
assign o_num = num_r;

wire [258:0] ct1, ct2;
assign ct1 = (ctemp_r << 1);
assign ct2 = (ans_r[0] ? ans_r + n : ans_r);

wire [258:0] mt1, mt2;
assign mt1 = (mb_r[0] ? mans_r + ma_r : mans_r);
assign mt2 = (mt1[0] ? mt1 + n : mt1);

always_comb begin
  main_state_w = main_state_r;
  ans_w = ans_r;

  core_state_w = core_state_r;
  ctemp_w = ctemp_r;
  cd_w = cd_r;
  ccount_w = ccount_r;

  mult_state_w = mult_state_r;
  ma_w = ma_r;
  mb_w = mb_r;
  mans_w = mans_r;
  mcount_w = mcount_r;
  

  case (main_state_r)
    S_IDLE: begin
      main_state_w = i_start ? S_BEGIN : S_IDLE;
    end
    S_BEGIN: begin
      main_state_w = S_CALC;
      core_state_w = S_BEGINC;
    end
    S_CALC: begin
      if (core_state_r == S_IDLEC) begin
        main_state_w = S_IDLE;
      end
    end
  endcase

  case (core_state_r)
    S_BEGINC: begin
      core_state_w = S_PRESHIFTC;
      ctemp_w = a;
      ans_w = 1;
      cd_w = d;
      ccount_w = 255;
    end
    S_PRESHIFTC: begin
      ctemp_w = (ct1 >= n ? ct1 - n : ct1);
      if (ccount_r == 0) begin
        core_state_w = S_LOOP1C;
        ccount_w = 255;
      end else begin
        ccount_w = ccount_r - 1;
      end
    end
    S_LOOP1C: begin
      if (cd_r[0]) begin
        ma_w = ctemp_r;
        mb_w = ans_r;
        core_state_w = S_WAIT1C;
        mult_state_w = S_BEGINM;
      end else begin
        core_state_w = S_LOOP2C;
      end
    end
    S_WAIT1C: begin
      if (mult_state_r == S_IDLEM) begin
        ans_w = mans_r;
        core_state_w = S_LOOP2C;
      end
    end
    S_LOOP2C: begin
      if (ccount_r == 0) begin
        core_state_w = S_IDLEC;
      end else begin
        ma_w = ctemp_r;
        mb_w = ctemp_r;
        core_state_w = S_WAIT2C;
        mult_state_w = S_BEGINM;
        ccount_w = ccount_r - 1;
        cd_w = cd_r >> 1;
      end
    end
    S_WAIT2C: begin
      if (mult_state_r == S_IDLEM) begin
        ctemp_w = mans_r;
        core_state_w = S_LOOP1C;
      end
    end
  endcase

  case(mult_state_r)
    S_BEGINM: begin
      mcount_w = 255;
      mans_w = 0;
      mult_state_w = S_LOOPM;
    end
    S_LOOPM: begin
      mans_w = mt2 >> 1;
      mb_w = mb_r >> 1;
      mcount_w = mcount_r - 1;
      mult_state_w = (mcount_r == 0 ? S_ENDM : S_LOOPM);
    end
    S_ENDM: begin
      if (mans_r >= n) mans_w = mans_r - n;
      mult_state_w = S_IDLEM;
    end
  endcase
end
  
always_ff @(posedge i_clk or posedge i_rst) begin
  if (i_rst) begin
    main_state_r <= S_IDLE;
    mult_state_r <= S_IDLEM;
    core_state_r <= S_IDLEC;
    ans_r <= 0;
    cd_r <= 0;
    ctemp_r <= 0;
    ccount_r <= 0;
    ma_r <= 0;
    mb_r <= 0;
    mans_r <= 0;
    mcount_r <= 0;
    num_r <= 0;
  end else begin
    main_state_r <= main_state_w;
    mult_state_r <= mult_state_w;
    core_state_r <= core_state_w;
    ans_r <= ans_w;
    cd_r <= cd_w;
    ctemp_r <= ctemp_w;
    ccount_r <= ccount_w;
    ma_r <= ma_w;
    mb_r <= mb_w;
    mans_r <= mans_w;
    mcount_r <= mcount_w;
    num_r <= num_w;

    if (i_start) begin
      a <= i_a;
      d <= i_d;
      n <= i_n;
    end
  end
end
endmodule
