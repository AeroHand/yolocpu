import lc3b_types::*;

module mp3
(
    input clk,
    /* DRAM */
    input lc3b_line pmem_rdata,
    input pmem_resp,
    output lc3b_word pmem_addr,
    output lc3b_line pmem_wdata,
	output logic pmem_read,
	output logic pmem_write
);

/* ICache */
lc3b_word pinst_rdata;
lc3b_word pinst_addr;
logic pinst_resp;
/* DCache */
logic l1_resp;
lc3b_word l1_rdata;
logic l1_read;
logic l1_write;
lc3b_mem_wmask l1_byte_enable;
lc3b_word l1_addr;
lc3b_word l1_wdata;
/* L2 Cache*/
lc3b_line l2_rdata;
logic l2_resp;
lc3b_word l2_addr;
lc3b_line l2_wdata;
logic l2_read;
logic l2_write;

/* CPU */
cpu cpu
(
	.clk,
	
	/* from ICache */
	.inst_rdata(pinst_rdata),
	.inst_resp(pinst_resp),

	/* from DCache */
	.mem_resp(l1_resp),
	.mem_rdata(l1_rdata),
	
	/* to ICache */
   	.inst_addr(pinst_addr),
	
	/* to DCache */
   	.mem_read(l1_read),
   	.mem_write(l1_write),
   	.mem_byte_enable(l1_byte_enable),
   	.mem_addr(l1_addr),
   	.mem_wdata(l1_wdata)
);

l1_cache l1_cache
(
	.clk,
	/* I cache */
	.inst_addr(pinst_addr),
	.inst_rdata(pinst_rdata),
	.inst_resp(pinst_resp),
	/* D cache */
	.d_mem_read(l1_read),
	.d_mem_write(l1_write),
	.mem_byte_enable(l1_byte_enable),
	.d_mem_addr(l1_addr),
	.d_mem_wdata(l1_wdata),
	.d_mem_resp(l1_resp),
	.d_mem_rdata(l1_rdata),
	/* Arbiter */
	.l2_rdata,
	.l2_resp,
	.l2_addr,
	.l2_wdata,
	.l2_read,
	.l2_write
);

bad_l2_cache l2_cache
(
	.clk,
	.mem_address(l2_addr),
	.mem_wdata(l2_wdata),
	.mem_read(l2_read),
	.mem_write(l2_write),
	.mem_rdata(l2_rdata),
	.mem_resp(l2_resp),
	.pmem_resp,
	.pmem_rdata,
	.pmem_read,
	.pmem_write,
	.pmem_address(pmem_addr),
	.pmem_wdata
);

endmodule : mp3
