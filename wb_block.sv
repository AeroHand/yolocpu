import lc3b_types::*;

module wb_block
(
	input clk,
	input lc3b_word inst,			//from ex_wb
	input lc3b_word pc,			//from ex_wb
	input lc3b_word alu,			//from ex_wb
	input lc3b_word mem_rdata,		//read from memory**in cp2 from mem
	input lc3b_control_word ctrl,
	
	output logic reg_load,	//to id
	output lc3b_reg reg_dest,	//to id
	output lc3b_word reg_data,	//to id
	output lc3b_nzp cc_out			//to if
);

lc3b_nzp gencc_out;

assign reg_load = ctrl.reg_load;

mux2 #(.width(3)) dest_mux
(
	.sel(ctrl.dest_mux_sel),
	.a(inst[11:9]),
	.b(3'b111),
	.f(reg_dest)
);

mux4 #(.width(16)) regdatamux
(
	.sel(ctrl.reg_data_mux),//from control
	.a(alu),
	.b(mem_rdata),
	.c(pc),	
	.d(16'h0000),			
	.f(reg_data)
);

negregister #(.width(3)) CC
(
	.clk(clk),
	.load(ctrl.load_cc),
	.in(gencc_out),
	.out(cc_out)
);

gencc gencc
(
    .in(reg_data),
    .out(gencc_out)
);


endmodule : wb_block