import lc3b_types::*;

module i_cache
(
    input clk,
	
	/* from CPU */
	input mem_read,
	input lc3b_word mem_address,
	 
	/* to CPU */
	output logic mem_resp,
	output lc3b_word mem_rdata,
	 
	/* from Pmem */
	input l2_resp,
    input lc3b_line l2_rdata,
	 
	/* to Pmem */
    output logic l2_read,
    output lc3b_word l2_addr
);

logic set_vals;
logic lru_write;
logic hit;


/* Controller */
i_cache_control i_cache_control
(
	.clk,
	.l2_resp,
	.mem_read,
	.hit,
	.l2_read,
	.mem_resp,
	.lru_write,
	.set_vals
);

/* Datapath */
i_cache_datapath i_cache_datapath
(
	.clk,
	.l2_rdata,
	.mem_read,
	.mem_address,
	.l2_addr,
	.mem_rdata,
	.set_vals,
	.lru_write,
	.hit
);
endmodule : i_cache
