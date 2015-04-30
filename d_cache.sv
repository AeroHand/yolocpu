import lc3b_types::*;

module d_cache
(
    input clk,
	
	 /* from CPU */
	 input mem_read, mem_write,
	 input lc3b_mem_wmask mem_byte_enable,
	 input lc3b_word mem_address, mem_wdata,
	 
	 /* to CPU */
	 output mem_resp,
	 output lc3b_word mem_rdata,
	 
	 /* from Pmem */
	 input pmem_resp,
    input lc3b_line pmem_rdata,
	 
	 /* to Pmem */
    output pmem_read, pmem_write,
    output lc3b_word pmem_address,
    output lc3b_line pmem_wdata
);

/* Controller -> Datapath */
logic writemux_sel;
logic datamux_sel;
logic lru_write;
logic write_back;

/* Datapath -> Controller */
logic hit;
logic dirty;


/* Controller */
d_cache_control d_cache_control
(
	.clk,
	
	/* Inputs */
	/* Physical Memory */
	.pmem_resp(pmem_resp),
	/* CPU */
	.mem_read(mem_read),
	.mem_write(mem_write),
	/* Cache Datapath */
	.hit(hit),
	.dirty(dirty),

	
	/* Outputs */
	/* Physical Memory */
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	/* CPU */
	.mem_resp(mem_resp),
	/* Cache Datapath */
	.writemux_sel(writemux_sel),
	.datamux_sel(datamux_sel),
	.lru_write(lru_write),
	.write_back(write_back)

);

/* Datapath */
d_cache_datapath d_cache_datapath
(
    .clk,
	 
	/* Inputs */
	/* Physical Memory */
	.pmem_resp(pmem_resp),
	.pmem_rdata(pmem_rdata),
	/* CPU */
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	/* Cache Controller */
	.writemux_sel(writemux_sel),
	.datamux_sel(datamux_sel),
	.lru_write(lru_write),
	.write_back(write_back),
	 
	/* Outputs */
	/* Physical Memory */
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata),
	/* CPU */
	.mem_rdata(mem_rdata),
	/* Cache Controller */
	.hit(hit),
	.dirty(dirty)

);
endmodule : d_cache
