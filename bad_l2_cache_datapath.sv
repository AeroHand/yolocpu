import lc3b_types::*;

module bad_l2_cache_datapath
(
   input clk,
	 
	input pmem_resp,
	input lc3b_line pmem_rdata,
	input mem_read,
	input mem_write,
	input lc3b_word mem_address,
	input lc3b_line mem_wdata,
	input writemux_sel,
	input datamux_sel,
	input lru_write,
	input write_back,

	output lc3b_word pmem_address,
	output lc3b_line pmem_wdata,
	output lc3b_line mem_rdata,
	output hit,
	output dirty	
);

/* Internal signals */


/* ADDRESS RIPPER */
lc3b_c_tag tag;
lc3b_c_set set;
lc3b_c_offset offset;

/* LRU */
logic lru_out;
logic lru_write_out;
logic lru_out_not;

/* WAYS */
logic hit0;
logic hit1;
logic dirty0;
logic dirty1;
logic write_back_out_not;
lc3b_word addressout;
lc3b_word addressout0;
lc3b_word addressout1;
lc3b_line dataout0;
lc3b_line dataout1;

/* Internal modules */

/* ADDRESS RIPPER */
address_ripper address_ripper
(
    .mem_address(mem_address),
	 
	 .tag(tag),
	 .set(set),
	 .offset(offset)
);

/* LRU */
array #(.width(1)) lru
(
	.clk,
	.write(lru_write_out),
	.set(set),
	.datain(hit0),
	.dataout(lru_out)
);

and_gate lru_write_and_hit
(
	.a(lru_write),
	.b(hit),
	.f(lru_write_out)
);

not_gate lru_not
(
	.a(lru_out),
	.f(lru_out_not)
);

not_gate write_back_not
(
	.a(write_back),
	.f(write_back_out_not)
);

/*
 *WAYS
 */
l2_way way0
(
    .clk,
	 .tag(tag),
	 .set(set),
	 .offset(offset),
	 .lru_in(lru_out_not),
	 .write_back(write_back_out_not),
	 .mem_write(mem_write),
	 .mem_wdata(mem_wdata),
	 .pmem_rdata(pmem_rdata),
	 .datamux_sel(datamux_sel),
	 .writemux_sel(writemux_sel),
	 
	 .hit(hit0),
	 .dirty(dirty0),
	 .addressout(addressout0),
	 .dataout(dataout0)
);

l2_way way1
(
    .clk,
	 .tag(tag),
	 .set(set),
	 .offset(offset),
	 .lru_in(lru_out),
	 .write_back(write_back_out_not),
	 .mem_write(mem_write),
	 .mem_wdata(mem_wdata),
	 .pmem_rdata(pmem_rdata),
	 .datamux_sel(datamux_sel),
	 .writemux_sel(writemux_sel),
	 
	 .hit(hit1),
	 .dirty(dirty1),
	 .addressout(addressout1),
	 .dataout(dataout1)
);

mux2 #(.width(128)) dataout_mux
(
    .sel(hit1),
    .a(dataout0),
    .b(dataout1),
    .f(mem_rdata)
);

mux2 #(.width(128)) pmem_wdataout_mux
(
    .sel(lru_out),
    .a(dataout0),
    .b(dataout1),
    .f(pmem_wdata)
);

mux2 #(.width(16)) pmem_addressout_mux
(
    .sel(write_back),
    .a(mem_address),
    .b(addressout),
    .f(pmem_address)
);

mux2 #(.width(16)) writeback_addressout_mux
(
    .sel(lru_out),
    .a(addressout0),
    .b(addressout1),
    .f(addressout)
);

or_gate hit0_or_hit1
(
	.a(hit0),
	.b(hit1),
	.f(hit)
);

or_gate dirty0_or_dirty1
(
	.a(dirty0),
	.b(dirty1),
	.f(dirty)
);


endmodule : bad_l2_cache_datapath
