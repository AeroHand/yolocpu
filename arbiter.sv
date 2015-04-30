import lc3b_types::*;

module arbiter
(
	input clk,

	/* L1 interaction */
	input lc3b_word i_cache_addr, d_cache_addr,
	input lc3b_line d_cache_wdata,
	input i_cache_read, d_cache_read,
	input d_cache_write,
	output lc3b_line i_cache_rdata, d_cache_rdata,
	output logic i_cache_resp, d_cache_resp,
	 
	/* L2 interaction */
	input lc3b_line l2_rdata,
	input l2_resp,
	output lc3b_word l2_addr,
	output lc3b_line l2_wdata,
	output logic l2_read,
	output logic l2_write
);

logic cache_sel;

arb_dpath arbiter_dpath
(
	.i_cache_addr,
	.d_cache_addr,
	.d_cache_wdata,
	.i_cache_read,
	.d_cache_read,
	.d_cache_write,
	.l2_rdata,
	.l2_resp,
	.cache_sel,
	.l2_addr,
	.l2_wdata,
	.l2_read,
	.l2_write,
	.i_cache_rdata,
	.d_cache_rdata,
	.i_cache_resp,
	.d_cache_resp
);

arb_ctrl arbiter_control
(
	.clk,
	.i_cache_read,
	.d_cache_read,
	.d_cache_write,
	.l2_resp,
	.cache_sel
);

endmodule : arbiter