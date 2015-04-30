import lc3b_types::*;

module l1_cache
(
	input clk,

	/* I cache */
	input lc3b_word inst_addr,
	output lc3b_word inst_rdata,
	output logic inst_resp,    

	/* D cache */
	input d_mem_read,
	input d_mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	input lc3b_word d_mem_addr,
	input lc3b_word d_mem_wdata,
	output logic d_mem_resp,
	output lc3b_word d_mem_rdata,

	/* Arbiter */
	input lc3b_line l2_rdata,
	input l2_resp,
	output lc3b_word l2_addr,
	output lc3b_line l2_wdata,
	output logic l2_read,
	output logic l2_write
);

lc3b_word i_cache_addr;
lc3b_word d_cache_addr;
lc3b_line d_cache_wdata;
logic i_cache_read;
logic d_cache_read;
logic d_cache_write;
lc3b_line i_cache_rdata;
lc3b_line d_cache_rdata;
logic i_cache_resp;
logic d_cache_resp;

arbiter arbiter
(
	.clk,
	.i_cache_addr,
	.d_cache_addr,
	.d_cache_wdata,
	.i_cache_read,
	.d_cache_read,
	.d_cache_write,
	.l2_rdata,     
	.l2_resp,      
	.l2_addr,	
	.l2_wdata,		
	.l2_read,		
	.l2_write,		
	.i_cache_rdata, 
	.d_cache_rdata,
	.i_cache_resp, 	
	.d_cache_resp 	
);

i_cache i_cache
(
	.clk,
	.mem_read(1'b1),			 // change this for CP3
	.mem_address(inst_addr),
	.mem_resp(inst_resp),                   // add something for CP3
	.mem_rdata(inst_rdata),
	.l2_resp(i_cache_resp),
	.l2_rdata(i_cache_rdata),
	.l2_read(i_cache_read),
	.l2_addr(i_cache_addr)
);

d_cache d_cache
(
	.clk,
	.mem_read(d_mem_read),
	.mem_write(d_mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_address(d_mem_addr),
	.mem_wdata(d_mem_wdata),
	.mem_resp(d_mem_resp),
	.mem_rdata(d_mem_rdata),
	.pmem_resp(d_cache_resp),
	.pmem_rdata(d_cache_rdata),
	.pmem_read(d_cache_read),
	.pmem_write(d_cache_write),
	.pmem_address(d_cache_addr),
	.pmem_wdata(d_cache_wdata)
);

endmodule : l1_cache