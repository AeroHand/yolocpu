import lc3b_types::*;

module way
(
   input clk,

	input lc3b_c_tag tag,
	input lc3b_c_set set,
	input lc3b_c_offset offset,

	input lru_in,
	input write_back,
	input mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	input lc3b_word mem_wdata,
	input lc3b_line pmem_rdata,
	input datamux_sel,
	input writemux_sel,
	 
	output hit,
	output dirty,
	output lc3b_word addressout,
	output lc3b_line dataout
);

/* Internal signals */

/* WRITEMUX */
logic hit_and_write_out;
logic writemux_out;
logic lru_and_write_back_out;

/* DATAMUX */
lc3b_line insertword_out;
lc3b_line datamux_out;

/* TAGCOMPARATOR */
logic tagcomparator_out;

/* ARRAYS */
logic validarray_out;
logic dirtyarray_out;
lc3b_c_tag tagarray_out;
lc3b_line dataarray_out;

/* Internal modules */

assign dataout = dataarray_out;
assign addressout = {tagarray_out, set, 4'b0000};

/* WRITEMUX */
mux2 #(.width(1)) writemux
(
    .sel(writemux_sel),
    .a(lru_and_write_back_out),
    .b(hit_and_write_out),
    .f(writemux_out)
);

and_gate lru_and_write_back
(
	.a(lru_in),
	.b(write_back),
	.f(lru_and_write_back_out)
);

and_gate hit_and_write
(
	.a(hit),
	.b(mem_write),
	.f(hit_and_write_out)
);

/* DATAMUX */
mux2 #(.width(128)) datamux
(
    .sel(datamux_sel),
    .a(pmem_rdata),
    .b(insertword_out),
    .f(datamux_out)
);

insertword insertword
(
	.line(dataout),
	.word(mem_wdata),
	.offset(offset),
	.mem_byte_enable(mem_byte_enable),
	
	.out(insertword_out)
);

/* TAGCOMPARATOR */
comparator #(.width(9)) tagcomparator
(
	.a(tag),
	.b(tagarray_out),
	.f(tagcomparator_out)
);

and_gate valid_and_tag
(
	.a(validarray_out),
	.b(tagcomparator_out),
	.f(hit)
);

and_gate write_and_dirty
(
	.a(lru_in),
	.b(dirtyarray_out),
	.f(dirty)
);

/* ARRAYS */
array #(.width(1)) validarray
(
	.clk,
	.write(writemux_out),
	.set(set),
	.datain(1'b1),
	.dataout(validarray_out)
);

array #(.width(1)) dirtyarray
(
	.clk,
	.write(writemux_out),
	.set(set),
	.datain(mem_write),
	.dataout(dirtyarray_out)
);

array #(.width(9)) tagarray
(
	.clk,
	.write(writemux_out),
	.set(set),
	.datain(tag),
	.dataout(tagarray_out)
);

array #(.width(128)) dataarray
(
	.clk,
	.write(writemux_out),
	.set(set),
	.datain(datamux_out),
	.dataout(dataarray_out)
);
endmodule : way