import lc3b_types::*;

module mem_block
(
	input clk,
	input logic run,

	input lc3b_control_word ctrl,
	input lc3b_word inst,
	input lc3b_word alu,
	input lc3b_word st_wdata,
	input lc3b_word mem_rdata_in,
	input logic mem_resp,
	
	input logic d1_mux_sel,
	input lc3b_word mem_wb_reg,
	
	output logic ldi_sti_state,

	output logic mem_write,
	output logic mem_read,
	output lc3b_mem_wmask mem_byte_enable,
	output lc3b_word mem_addr,
	output lc3b_word mem_wdata,
	output lc3b_word mem_rdata_out
);


lc3b_word ldb_out;
lc3b_word d1_mux_out;
lc3b_word STbtransfer_out;
lc3b_word ldi_sti_reg_out;
logic sel_in;
logic selreg_out;

mem_logic MEMlogic
(
	.inst(inst),
	.alu(alu),
	.sti(ldi_sti_state),
	.mwrite(mem_write),
	.mread(mem_read),
	.mbytesenable(mem_byte_enable)
);

register ldi_sti_reg
(
	.clk,
	.load(mem_resp & ctrl.ldi_sti),
	.in(mem_rdata_in),
	.out(ldi_sti_reg_out)
);

register #(.width(1)) ldi_sti_state_reg
(
	.clk,
	.load(mem_resp & ctrl.ldi_sti),
	.in(~ldi_sti_state),
	.out(ldi_sti_state)
);

mux2 addrmux
(
	.sel(ldi_sti_state),
	.a(alu),
	.b(ldi_sti_reg_out),
	.f(mem_addr)
);

mux2 d1_mux
(
	.sel(d1_mux_sel),
	.a(st_wdata),
	.b(mem_wb_reg),
	.f(d1_mux_out)
);

mux2 stb_mux
(
	.sel(ctrl.stb_mux_sel),
	.a(d1_mux_out),
	.b(STbtransfer_out),
	.f(mem_wdata)
);

stbtransfer STBtrans
(
	.a(alu[0]),
	.b(st_wdata),
	.f(STbtransfer_out)
);


mux2 #(.width(16)) ldb_mux
(
	.sel(ctrl.ldb_mux_sel),
	.a(mem_rdata_in),
	.b(ldb_out),
	.f(mem_rdata_out)
);

ldbtransfer LDBtrans
(
	.a(alu[0]),
	.b(mem_rdata_in),
	.f(ldb_out)
);

endmodule: mem_block