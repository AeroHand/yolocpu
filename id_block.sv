import lc3b_types::*
;
module id_block
(
	input clk,
	input lc3b_control_word ctrl,
	input lc3b_word inst,
	input lc3b_word pc,
	input lc3b_word pc_off,

	input logic reg_load,
	input lc3b_reg reg_dest,
	input lc3b_word reg_data,

	output lc3b_control_word ctrl_out,
	output lc3b_word a,   
	output lc3b_word b,
	output lc3b_word reg_b		//to id_ex
);

assign ctrl_out = ctrl;

lc3b_reg srcbmux_out;

lc3b_word zext4_out;
lc3b_word sext5_out;
lc3b_word sext6_out;
lc3b_word adj6_out;
lc3b_word ext8_out;

lc3b_word reg_a;
lc3b_word b2mux_out;

regfile regfile
(
	.clk,
	.load(reg_load),
	.in(reg_data),
	.src_a(inst[8:6]),
	.src_b(srcbmux_out),
	.dest(reg_dest),
	.reg_a(reg_a),
	.reg_b(reg_b)
);

mux2 #(.width(3)) srcbmux
(
	.sel(ctrl.src_mux),
	.a(inst[2:0]),
	.b(inst[11:9]),
	.f(srcbmux_out)
);

mux4 #(.width(16)) amux
(
	.sel(ctrl.a_mux_sel),
	.a(reg_a),
	.b(pc),
	.c(pc_off),
	.d(ext8_out),
	.f(a)
);

mux2 #(.width(16)) b1mux
(
	.sel(ctrl.b1_mux_sel),
	.a(reg_b),
	.b(b2mux_out),
	.f(b)
);

mux4 #(.width(16)) b2mux
(
	.sel(ctrl.b2_mux_sel),
	.a(sext5_out),
	.b(adj6_out),
	.c(sext6_out),
	.d(zext4_out),
	.f(b2mux_out)
);

ext #(.width(5)) sext5
(
	.zextsext(1'b1),
	.byteword(1'b0),
	.in(inst[4:0]),
	.out(sext5_out)
);

ext #(.width(6)) adj6
(
	.zextsext(1'b1),
	.byteword(1'b1),
	.in(inst[5:0]),
	.out(adj6_out)
);

ext #(.width(6)) sext6
(
	.zextsext(1'b1),
	.byteword(1'b0),
	.in(inst[5:0]),
	.out(sext6_out)
);

ext #(.width(4)) zext4
(
	.zextsext(1'b0),
	.byteword(1'b0),
	.in(inst[3:0]),
	.out(zext4_out)
);

ext #(.width(8)) ext8
(
	.zextsext(1'b0),
	.byteword(1'b1),
	.in(inst[7:0]),
	.out(ext8_out)
);

endmodule : id_block
