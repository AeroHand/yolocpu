import lc3b_types::*;

module if_block
(
	input clk,
	input run,
	
	input lc3b_word inst_rdata,
	input lc3b_nzp cc,
	
	input lc3b_opcode id_op, ex_op, mem_op,
	input logic id_cc, ex_cc, mem_cc,

	input lc3b_word base_reg,		//from ex instead of id
	input lc3b_word trapvect,		//from wb
	
	output lc3b_word inst_addr,
	output lc3b_word inst,   		// to if_id
	output lc3b_word pc,			// to id JSR
	output lc3b_word pc_off,		// to id LEA
	output logic forwarding_override

);

lc3b_word adj9_out;
lc3b_word adj11_out;
lc3b_word addermux_out;
lc3b_word pcmux_out;
logic pc_load;

// Control Signals 
logic pc_run;
logic addermux_sel;
logic [1:0] pcmux_sel;

//PC Control
pccontrol pccontrol
(	
	.inst_in(inst_rdata),
	.cc(cc),
	.id_op(id_op),
	.ex_op(ex_op),
	.mem_op(mem_op),
	.id_cc(id_cc),
	.ex_cc(ex_cc),
	.mem_cc(mem_cc),

	.inst_out(inst),
	.pc_run(pc_run),
	.addermux_sel(addermux_sel),
	.pcmux_sel(pcmux_sel),
	.forwarding_override(forwarding_override)
);

// PC 
mux4 pcmux
(	
	.sel(pcmux_sel),
	.a(pc),
	.b(pc_off),		//from id
	.c(base_reg),	//from wb
	.d(trapvect),
	.f(pcmux_out)
);

and_gate pc_switch
(
	.a(run),
	.b(pc_run),
	.f(pc_load)
);

register pc_reg
(
	.clk,
	.load(pc_load),          
	.in(pcmux_out),
	.out(inst_addr)
);

plus2 plus2
(
	.in(inst_addr),
	.out(pc)
);


adder compute_addr
(
	.a(pc),
	.b(addermux_out),
	.out(pc_off)
);

mux2 #(.width(16)) addermux
(
	.sel(addermux_sel),
	.a(adj9_out),
	.b(adj11_out),
	.f(addermux_out)
);

ext #(.width(9)) adj9
(
	.zextsext(1'b1),
	.byteword(1'b1),
	.in(inst_rdata[8:0]),
	.out(adj9_out)
);

ext #(.width(11)) adj11
(
	.zextsext(1'b1),
	.byteword(1'b1),
	.in(inst_rdata[10:0]),
	.out(adj11_out)
);



endmodule : if_block


