import lc3b_types::*;

module l2_cache_datapath
(
	input clk,

	/* L1 Interaction */
	input lc3b_word mem_addr,
	input lc3b_line mem_wdata,
	input mem_write,
	output lc3b_line mem_rdata,

	/* DRAM Interaction */
	input lc3b_line pmem_rdata,
	output lc3b_word pmem_addr,
	output lc3b_line pmem_wdata, 

	/* Control Interaction */
	input rw_sel,
	input vtd_set,
	input dirty_set,
	input load_mux_sel,
	input lru_set,
	input addr_sel,
	output logic hit,
	output logic dirty
);

/* Internal Signals */
logic dirty_out_1;
logic dirty_out_2;
logic dirty_out_3;
logic dirty_out_4;
logic load_dirty_1;
logic load_dirty_2;
logic load_dirty_3;
logic load_dirty_4;
logic valid_out_1;
logic valid_out_2;
logic valid_out_3;
logic valid_out_4;
lc3b_c2_tag tag_out_1;
lc3b_c2_tag tag_out_2;
lc3b_c2_tag tag_out_3;
lc3b_c2_tag tag_out_4;
lc3b_c2_tag chosen_tag;
lc3b_line data_out_1;
lc3b_line data_out_2;
lc3b_line data_out_3;
lc3b_line data_out_4;
lc3b_line data_load_mux_out;
logic comp_out_1;
logic comp_out_2;
logic comp_out_3;
logic comp_out_4;
logic hit_1;
logic hit_2;
logic hit_3;
logic hit_4;
logic hit_detect_1_out;
logic hit_detect_2_out;
logic dirty_1;
logic dirty_2;
logic dirty_3;
logic dirty_4;
logic dirty_detect_1_out;
logic dirty_detect_2_out;
logic way_1_on;
logic way_2_on;
logic way_3_on;
logic way_4_on;
logic way_1_load_1;
logic way_1_load_2;
logic way_2_load_1;
logic way_2_load_2;
logic way_3_load_1;
logic way_3_load_2;
logic way_4_load_1;
logic way_4_load_2;
logic load_mux_out_1;
logic load_mux_out_2;
logic load_mux_out_3;
logic load_mux_out_4;
lc3b_2bsel data_out_mux_sel;
lc3b_2bsel two_bit_way;
lc3b_lru lru_out;
lc3b_lru update_lru_out;
lc3b_word new_pmem_addr;
lc3b_c2_tag tag;
lc3b_c2_set index;
lc3b_c_offset offset;

/* Modules */

/* DIRTY ARRAYS*/
array2 #(.width(1)) dirty_array_1
(
	 .clk,
	 .write(load_dirty_1),    
	 .set(index),  
	 .datain(1'b1),
	 .dataout(dirty_out_1)  
);

array2 #(.width(1)) dirty_array_2
(
	 .clk,
	 .write(load_dirty_2),       
	 .set(index),
	 .datain(1'b1),
	 .dataout(dirty_out_2)    
);

array2 #(.width(1)) dirty_array_3
(
	 .clk,
	 .write(load_dirty_3),    
	 .set(index),  
	 .datain(1'b1),
	 .dataout(dirty_out_3)  
);

array2 #(.width(1)) dirty_array_4
(
	 .clk,
	 .write(load_dirty_4),       
	 .set(index),
	 .datain(1'b1),
	 .dataout(dirty_out_4)    
);

/* VALID ARRAYS */
array2 #(.width(1)) valid_array_1
(
	 .clk,
	 .write(load_mux_out_1),    
	 .set(index),  
	 .datain(1'b1),
	 .dataout(valid_out_1)  
);

array2 #(.width(1)) valid_array_2
(
	 .clk,
	 .write(load_mux_out_2),       
	 .set(index),
	 .datain(1'b1),
	 .dataout(valid_out_2)    
);

array2 #(.width(1)) valid_array_3
(
	 .clk,
	 .write(load_mux_out_3),    //
	 .set(index),  
	 .datain(1'b1),
	 .dataout(valid_out_3)  
);

array2 #(.width(1)) valid_array_4
(
	 .clk,
	 .write(load_mux_out_4),       //
	 .set(index),
	 .datain(1'b1),
	 .dataout(valid_out_4)    
);

/* TAG ARRAYS */
array2 #(.width(8)) tag_array_1
(
	 .clk,
	 .write(load_mux_out_1),
	 .set(index),
	 .datain(tag),
	 .dataout(tag_out_1)
);

array2 #(.width(8)) tag_array_2
(
	 .clk,
	 .write(load_mux_out_2),
	 .set(index),
	 .datain(tag),
	 .dataout(tag_out_2)
);

array2 #(.width(8)) tag_array_3
(
	 .clk,
	 .write(load_mux_out_3),
	 .set(index),
	 .datain(tag),
	 .dataout(tag_out_3)
);

array2 #(.width(8)) tag_array_4
(
	 .clk,
	 .write(load_mux_out_4),
	 .set(index),
	 .datain(tag),
	 .dataout(tag_out_4)
);

/* DATA ARRAYS */
array2 data_array_1
(
	 .clk,
	 .write(load_mux_out_1),
	 .set(index),
	 .datain(data_load_mux_out),
	 .dataout(data_out_1)
);

array2 data_array_2
(
	 .clk,
	 .write(load_mux_out_2),
	 .set(index),
	 .datain(data_load_mux_out),
	 .dataout(data_out_2)
);

array2 data_array_3
(
	 .clk,
	 .write(load_mux_out_3),
	 .set(index),
	 .datain(data_load_mux_out),
	 .dataout(data_out_3)
);

array2 data_array_4
(
	 .clk,
	 .write(load_mux_out_4),
	 .set(index),
	 .datain(data_load_mux_out),
	 .dataout(data_out_4)
);

/* LRU */ 
array2 #(.width(3)) lru
(
	 .clk,
	 .write(lru_set),
	 .set(index),
	 .datain(update_lru_out),
	 .dataout(lru_out)
);

/* Basic logic gates */

and_gate is_hit_1
(
	.a(comp_out_1),
	.b(valid_out_1),
	.f(hit_1)
);

and_gate is_hit_2
(
	.a(comp_out_2),
	.b(valid_out_2),
	.f(hit_2)
);

and_gate is_hit_3
(
	.a(comp_out_3),
	.b(valid_out_3),
	.f(hit_3)
);

and_gate is_hit_4
(
	.a(comp_out_4),
	.b(valid_out_4),
	.f(hit_4)
);

or_gate hit_detect_1
(
	.a(hit_1),
	.b(hit_2),
	.f(hit_detect_1_out)
);

or_gate hit_detect_2
(
	.a(hit_3),
	.b(hit_4),
	.f(hit_detect_2_out)
);

or_gate hit_detect_main
(
	.a(hit_detect_1_out),
	.b(hit_detect_2_out),
	.f(hit)
);

and_gate is_dirty_1
(
	.a(dirty_out_1),
	.b(way_1_on),
	.f(dirty_1)
);

and_gate is_dirty_2
(
	.a(dirty_out_2),
	.b(way_2_on),
	.f(dirty_2)
);

and_gate is_dirty_3
(
	.a(dirty_out_3),
	.b(way_3_on),
	.f(dirty_3)
);

and_gate is_dirty_4
(
	.a(dirty_out_4),
	.b(way_4_on),
	.f(dirty_4)
);

or_gate dirty_detect_1
(
	.a(dirty_1),
	.b(dirty_2),
	.f(dirty_detect_1_out)
);

or_gate dirty_detect_2
(
	.a(dirty_3),
	.b(dirty_4),
	.f(dirty_detect_2_out)
);

or_gate dirty_detect_main
(
	.a(dirty_detect_1_out),
	.b(dirty_detect_2_out),
	.f(dirty)
);

and_gate dirty_set_1
(
	.a(hit_1),
	.b(dirty_set),
	.f(load_dirty_1)
);

and_gate dirty_set_2
(
	.a(hit_2),
	.b(dirty_set),
	.f(load_dirty_2)
);

and_gate dirty_set_3
(
	.a(hit_3),
	.b(dirty_set),
	.f(load_dirty_3)
);

and_gate dirty_set_4
(
	.a(hit_4),
	.b(dirty_set),
	.f(load_dirty_4)
);

and_gate read_load_1
(
	.a(way_1_on),
	.b(vtd_set),
	.f(way_1_load_1)
);

and_gate write_load_1
(
	.a(hit_1),
	.b(mem_write),
	.f(way_1_load_2)
);

and_gate read_load_2
(
	.a(way_2_on),
	.b(vtd_set),
	.f(way_2_load_1)
);

and_gate write_load_2
(
	.a(hit_2),
	.b(mem_write),
	.f(way_2_load_2)
);

and_gate read_load_3
(
	.a(way_3_on),
	.b(vtd_set),
	.f(way_3_load_1)
);

and_gate write_load_3
(
	.a(hit_3),
	.b(mem_write),
	.f(way_3_load_2)
);

and_gate read_load_4
(
	.a(way_4_on),
	.b(vtd_set),
	.f(way_4_load_1)
);

and_gate write_load_4
(
	.a(hit_4),
	.b(mem_write),
	.f(way_4_load_2)
);

/* Muxes */
mux4 #(.width(128)) data_out_mux 
(
	.sel(data_out_mux_sel),
	.a(data_out_1),
	.b(data_out_2),
	.c(data_out_3),
	.d(data_out_4),
	.f(mem_rdata)
);


mux4 #(.width(8)) tag_select_mux 
(
	.sel(two_bit_way),
	.a(tag_out_1),
	.b(tag_out_2),
	.c(tag_out_3),
	.d(tag_out_4),
	.f(chosen_tag)
);

mux2 #(.width(16)) addr_select_mux
(
	.sel(addr_sel),
	.a(mem_addr),
	.b(new_pmem_addr),
	.f(pmem_addr)
);

mux2 #(.width(128)) data_load_mux
(
	.sel(rw_sel),
	.a(pmem_rdata),
	.b(mem_wdata),
	.f(data_load_mux_out)
);

mux4 #(.width(128)) write_mux 
(
	.sel(two_bit_way),
	.a(data_out_1),
	.b(data_out_2),
	.c(data_out_3),
	.d(data_out_4),
	.f(pmem_wdata)
);

mux2 #(.width(1)) load_mux_1
(
	.sel(load_mux_sel),
	.a(way_1_load_1),
	.b(way_1_load_2),
	.f(load_mux_out_1)
);

mux2 #(.width(1)) load_mux_2
(
	.sel(load_mux_sel),
	.a(way_2_load_1),
	.b(way_2_load_2),
	.f(load_mux_out_2)
);

mux2 #(.width(1)) load_mux_3
(
	.sel(load_mux_sel),
	.a(way_3_load_1),
	.b(way_3_load_2),
	.f(load_mux_out_3)
);

mux2 #(.width(1)) load_mux_4
(
	.sel(load_mux_sel),
	.a(way_4_load_1),
	.b(way_4_load_2),
	.f(load_mux_out_4)
);

/* Other stuff */
comparator #(.width(8)) comp_1
(
	.a(tag),
	.b(tag_out_1),
	.f(comp_out_1)
);

comparator #(.width(8)) comp_2_
(
	.a(tag),
	.b(tag_out_2),
	.f(comp_out_2)
);

comparator #(.width(8)) comp_3
(
	.a(tag),
	.b(tag_out_3),
	.f(comp_out_3)
);

comparator #(.width(8)) comp_4
(
	.a(tag),
	.b(tag_out_4),
	.f(comp_out_4)
);

l2_address_ripper l2_addr_parser
(
	.mem_address(mem_addr),
	.tag,
	.set(index),
	.offset
);

data_select pick_data
(
	.hit_2,
	.hit_3,
	.hit_4,
	.data_select_out(data_out_mux_sel)
);

select_way way_chosen
(
	.cur_lru(lru_out),
	.valid_bit_1(valid_out_1),
	.valid_bit_2(valid_out_2),
	.valid_bit_3(valid_out_3),
	.valid_bit_4(valid_out_4),
	.a(way_1_on),
	.b(way_2_on),
	.c(way_3_on),
	.d(way_4_on),
	.two_bit_way
);

pseudo_lru update_lru
(
	.way_1(way_1_on),
	.way_2(way_2_on),
	.way_3(way_3_on),
	.cur_lru(lru_out),
	.updated_lru(update_lru_out)
); 

rebuild_addr make_pmem_addr
(
	.tag(chosen_tag),
	.index,
	.addr(new_pmem_addr)
);

endmodule : l2_cache_datapath