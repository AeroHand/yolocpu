import lc3b_types::*;

module i_cache_datapath
(
    input clk,
	input lc3b_line l2_rdata,
	input mem_read,
	input lc3b_word mem_address,
	output lc3b_word l2_addr,
	output lc3b_word mem_rdata,
	
	/* control signals */
	input set_vals,
	input lru_write,
	output logic hit
);

/* Internal signals */
lc3b_c_tag tag;
lc3b_c_tag tag_out1;
lc3b_c_tag tag_out2;
lc3b_c_set index;
lc3b_c_offset offset;
lc3b_line data_out1;
lc3b_line data_out2;
lc3b_line data_chosen;
logic valid_out1;
logic valid_out2;
logic comp_out1;
logic comp_out2;
logic hit1;
logic hit2;
logic lruout;
logic writes_sig1;
logic writes_sig2;

assign l2_addr = mem_address;

/* Internal modules */

/* ARRAYS */
array #(.width(1)) valid_array_1
(
	 .clk,
	 .write(writes_sig1),    //
	 .set(index),  
	 .datain(1'b1),
	 .dataout(valid_out1)  
);

array #(.width(1)) valid_array_2
(
	 .clk,
	 .write(writes_sig2),       //
	 .set(index),
	 .datain(1'b1),
	 .dataout(valid_out2)    
);

array #(.width(9)) tag_array_1
(
	 .clk,
	 .write(writes_sig1),
	 .set(index),
	 .datain(tag),
	 .dataout(tag_out1)
);

array #(.width(9)) tag_array_2
(
	 .clk,
	 .write(writes_sig2),
	 .set(index),
	 .datain(tag),
	 .dataout(tag_out2)
);

array data_array_1
(
	 .clk,
	 .write(writes_sig1),
	 .set(index),
	 .datain(l2_rdata),
	 .dataout(data_out1)
);

array data_array_2
(
	 .clk,
	 .write(writes_sig2),
	 .set(index),
	 .datain(l2_rdata),
	 .dataout(data_out2)
);

array #(.width(1)) lru
(
	 .clk,
	 .write(lru_write),
	 .set(index),
	 .datain(hit1),
	 .dataout(lruout)
);

/* Comparators */
comparator comp_1
(
	.a(tag),
	.b(tag_out1),
	.f(comp_out1)
);

comparator comp_2
(
	.a(tag),
	.b(tag_out2),
	.f(comp_out2)
);

/* MUXES */ 
mux2 #(.width(128)) data_mux 
(
	.sel(hit2),
	.a(data_out1),
	.b(data_out2),
	.f(data_chosen)
);

/* Basic logic gates */ 
and_gate is_hit_1
(
	.a(comp_out1),
	.b(valid_out1),
	.f(hit1)
);

and_gate is_hit_2
(
	.a(comp_out2),
	.b(valid_out2),
	.f(hit2)
);

or_gate hit_detect
(
	.a(hit1),
	.b(hit2),
	.f(hit)
);

and_gate set_array_and_1
(
	.a(!lruout),
	.b(set_vals),
	.f(writes_sig1)
);

and_gate set_array_and_2
(
	.a(lruout),
	.b(set_vals),
	.f(writes_sig2)
);

/* Other modules */
address_ripper addr_parser
(
	.mem_address,
	.tag,
	.set(index),
	.offset
);

wordgrab byte_parse
(
	.line(data_chosen),
	.offset,
	.out(mem_rdata)
);

endmodule : i_cache_datapath
