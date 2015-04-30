import lc3b_types::*;

module arb_dpath
(
	 input lc3b_word i_cache_addr, d_cache_addr,
	 input lc3b_line d_cache_wdata,
	 input i_cache_read, d_cache_read,
	 input d_cache_write,
	 input lc3b_line l2_rdata,
	 input l2_resp,
	 input cache_sel,
	 output lc3b_word l2_addr,
	 output lc3b_line l2_wdata,
	 output logic l2_read,
	 output logic l2_write,
	 output lc3b_line i_cache_rdata, d_cache_rdata,
	 output logic i_cache_resp, d_cache_resp
);

assign i_cache_rdata = l2_rdata;
assign d_cache_rdata = l2_rdata; 
assign l2_wdata = d_cache_wdata;
assign l2_write = d_cache_write;

mux2 #(.width(16))arb_addr_mux
(
	.sel(cache_sel),  
	.a(i_cache_addr),
	.b(d_cache_addr),
	.f(l2_addr)
);


mux2 #(.width(1))arb_read_mux
(
	.sel(cache_sel),  
	.a(i_cache_read),
	.b(d_cache_read),
	.f(l2_read)
);

and_gate i_resp
(	
	.a(l2_resp),
	.b(!cache_sel),
	.f(i_cache_resp)
);

and_gate d_resp
(	
	.a(l2_resp),
	.b(cache_sel),
	.f(d_cache_resp)
);

endmodule : arb_dpath

