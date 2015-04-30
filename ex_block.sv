import lc3b_types::*;

module ex_block
(	
	input lc3b_control_word ctrl,
	input lc3b_word inst,
	input lc3b_word src_a,
	input lc3b_word src_b,
	input logic a1_mux_sel, a2_mux_sel, b1_mux_sel, b2_mux_sel, c1_mux_sel, c2_mux_sel,
	input lc3b_word ex_mem_alu, mem_wb_reg,
	input lc3b_word st_wdata,
	output lc3b_word alu_out,
	output lc3b_word st_wdata_out
);

lc3b_word alumux1_out;
lc3b_word alumux2_out;
lc3b_word a2_mux_out;
lc3b_word b2_mux_out;
lc3b_word c2_mux_out;

mux2 #(.width(16)) a1_mux
(
	.sel(a1_mux_sel),
	.a(src_a),
	.b(a2_mux_out),
	.f(alumux1_out)
);

mux2 #(.width(16)) a2_mux
(
	.sel(a2_mux_sel),
	.a(mem_wb_reg),
	.b(ex_mem_alu),
	.f(a2_mux_out)
);

mux2 #(.width(16)) b1_mux
(
	.sel(b1_mux_sel),
	.a(src_b),
	.b(b2_mux_out),
	.f(alumux2_out)
);

mux2 #(.width(16)) b2_mux
(
	.sel(b2_mux_sel),
	.a(mem_wb_reg),
	.b(ex_mem_alu),
	.f(b2_mux_out)
);

mux2 #(.width(16)) c1_mux
(
	.sel(c1_mux_sel),
	.a(st_wdata),
	.b(c2_mux_out),
	.f(st_wdata_out)
);

mux2 #(.width(16)) c2_mux
(
	.sel(c2_mux_sel),
	.a(mem_wb_reg),
	.b(ex_mem_alu),
	.f(c2_mux_out)
);

alu ALU
(
	.aluop(ctrl.aluop),// ctrl_word
	.a(alumux1_out),
	.b(alumux2_out),
	.f(alu_out)
);

endmodule : ex_block