import lc3b_types::*;

module l2_cache
(
	input clk,

	/* L1 interaction */
	input lc3b_word mem_addr,
	input lc3b_line mem_wdata,
	input mem_read,
	input mem_write,
	output lc3b_line mem_rdata,
	output mem_resp, 

	/* DRAM interaction */
	input pmem_resp, 
	input lc3b_line pmem_rdata,
	output pmem_read,
	output pmem_write,
	output lc3b_word pmem_addr,
	output lc3b_line pmem_wdata
);

/* internal signals */
logic rw_sel;	
logic vtd_set;
logic dirty_set;
logic load_mux_sel;
logic lru_set;
logic hit;
logic dirty;
logic addr_sel;

/* Modules */
l2_cache_datapath l2_dpath 
(
	.clk,
	.mem_addr,
	.mem_wdata,
	.mem_write,
	.mem_rdata,
	.pmem_rdata,
	.pmem_addr,
	.pmem_wdata,
	.rw_sel,
	.vtd_set,
	.dirty_set,
	.load_mux_sel,
	.lru_set,
	.hit,
	.dirty,
	.addr_sel
);

l2_cache_control l2_ctrl
(
	.clk,
	.mem_read,
	.mem_write,
	.mem_resp,
	.pmem_resp,
	.pmem_read,
	.pmem_write,
	.hit,
	.dirty,
	.lru_set,
	.vtd_set,
	.dirty_set,
	.rw_sel,
	.load_mux_sel,
	.addr_sel
);

endmodule : l2_cache