import lc3b_types::*;

module cpu
(
    input clk,
	 
	/* Instruction Memory signals */
	input inst_resp,
	input lc3b_word inst_rdata,
	output lc3b_word inst_addr,

    /* Data Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_addr,
    output lc3b_word mem_wdata
);

/* Forward Unit Signals */
logic 	a1_mux_sel;
logic  	a2_mux_sel;
logic  	b1_mux_sel;
logic 	b2_mux_sel;
logic  	c1_mux_sel;
logic  	c2_mux_sel;
logic 	d1_mux_sel;

/* Write Back Signals */
logic 		reg_load;
lc3b_word 	reg_data;
lc3b_reg  	reg_dest;
lc3b_nzp  	cc;

/* Chasm Register Signals */
lc3b_if_id if_id_in;
lc3b_if_id if_id_out;

lc3b_id_ex id_ex_in;
assign id_ex_in.inst = if_id_out.inst;
assign id_ex_in.pc = if_id_out.pc;
assign id_ex_in.forwarding_override = if_id_out.forwarding_override;
lc3b_id_ex id_ex_out;

lc3b_ex_mem ex_mem_in;
assign ex_mem_in.ctrl = id_ex_out.ctrl;
assign ex_mem_in.inst = id_ex_out.inst;
assign ex_mem_in.pc   = id_ex_out.pc;
lc3b_ex_mem ex_mem_out;

lc3b_mem_wb mem_wb_in;
assign mem_wb_in.ctrl = ex_mem_out.ctrl;
assign mem_wb_in.inst = ex_mem_out.inst;
assign mem_wb_in.pc   = ex_mem_out.pc;
assign mem_wb_in.alu  = ex_mem_out.alu;
lc3b_mem_wb mem_wb_out;

lc3b_control_word ctrl_out;
logic run;
logic ldi_sti_state;


/* CONTROL ROM */
control_rom control_rom
(
	.opcode(lc3b_opcode'(if_id_out.inst[15:12])),
	.bit11(if_id_out.inst[11]),
	.bit5(if_id_out.inst[5]),
	.bit4(if_id_out.inst[4]),
	.ctrl(ctrl_out)
);

/* STAGE BLOCKS */
/* IF */
if_block if_block
(
	.clk,
	.run(run),
	.inst_rdata(inst_rdata),	// from Icache
	.cc(cc),					// from wb_block

	.base_reg(ex_mem_in.alu),		//from ex alu
	.trapvect(mem_wb_in.mem_rdata),	//from wb_block
	
	.id_op(ctrl_out.opcode),
	.ex_op(id_ex_out.ctrl.opcode),
	.mem_op(ex_mem_out.ctrl.opcode),

	.id_cc(ctrl_out.load_cc),
	.ex_cc(id_ex_out.ctrl.load_cc),
	.mem_cc(ex_mem_out.ctrl.load_cc),
	
	.inst_addr(inst_addr),		// to Icache
	.inst(if_id_in.inst),   	// to if_id
	.pc(if_id_in.pc),			// to if_id
	.pc_off(if_id_in.pc_off),	// to if_id
	.forwarding_override(if_id_in.forwarding_override) // to ex_mem
);

/* ID */
id_block id_block
(
	.clk,
	.ctrl(ctrl_out),			// from control rom
	
	.inst(if_id_out.inst),		// from if_id
	.pc(if_id_out.pc),			// from if_id
	.pc_off(if_id_out.pc_off),	// from if_id
	
	.reg_load(reg_load),	// from wb_block
	.reg_dest(reg_dest),	// from wb_block
	.reg_data(reg_data),  // from wb_block
	
	.ctrl_out(id_ex_in.ctrl),
	.a(id_ex_in.a),			// to id_ex 
	.b(id_ex_in.b),			// to id_ex
	.reg_b(id_ex_in.reg_b)	// to id_ex
);

/* EX */
ex_block ex_block
(
	.ctrl(id_ex_out.ctrl), 		// from id_ex
	.inst(id_ex_out.inst),		// from id_ex
	.src_a(id_ex_out.a),		// from id_ex
	.src_b(id_ex_out.b),		// from id_ex
	.st_wdata(id_ex_out.reg_b),	// from id_ex
	
	.a1_mux_sel(a1_mux_sel), // from data forwarding
	.a2_mux_sel(a2_mux_sel), // from data forwarding
	.b1_mux_sel(b1_mux_sel), // from data forwarding
	.b2_mux_sel(b2_mux_sel), // from data forwarding
	.c1_mux_sel(c1_mux_sel), // from data forwarding
	.c2_mux_sel(c2_mux_sel), // from data forwarding
	.ex_mem_alu(ex_mem_out.alu), // from ex_mem
	.mem_wb_reg(reg_data),// from wb_block 

	.alu_out(ex_mem_in.alu), 				// to ex_mem & if
	.st_wdata_out(ex_mem_in.reg_b)			// to ex_mem
);

/* MEM */
mem_block mem_block
(
	.clk,
	.run(run),
	
	.ctrl(ex_mem_out.ctrl),
	.inst(ex_mem_out.inst), 		// from ex_mem
	.alu(ex_mem_out.alu),			// from ex_mem
	.st_wdata(ex_mem_out.reg_b),	// from ex_mem
	.mem_rdata_in(mem_rdata),
	.mem_resp(mem_resp),
	
	.d1_mux_sel(d1_mux_sel),
	.mem_wb_reg(reg_data),

	/* THIS WE NEED TO TALK ABOUT */
	.ldi_sti_state(ldi_sti_state),		// to freeze logic

	.mem_write(mem_write),				// to Dcache
	.mem_read(mem_read),				// to Dcache
	.mem_byte_enable(mem_byte_enable),	// to Dcache
	.mem_addr(mem_addr),				// to Dcache
	.mem_wdata(mem_wdata),				// to Dcache
	.mem_rdata_out(mem_wb_in.mem_rdata)	// to Dcache
);

/* WB */
wb_block wb_block
(
	.clk,
	
	.ctrl(mem_wb_out.ctrl),				// from mem_wb
	.inst(mem_wb_out.inst),				// from mem_wb
	.pc(mem_wb_out.pc),					// from mem_wb	
	.alu(mem_wb_out.alu),   			// from mem_wb
	.mem_rdata(mem_wb_out.mem_rdata),	// from mem_wb

	.cc_out(cc),						//to if_block
	
	.reg_load(reg_load),			//to id_block
	.reg_data(reg_data),			//to id_block
	.reg_dest(reg_dest)			//to id_block

);

/* FREEZE UNIT */
freeze freeze
(
	.inst_resp(inst_resp),
	.mem_resp(mem_resp),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.ldi_sti(ex_mem_out.ctrl.ldi_sti),
	.ldi_sti_state(ldi_sti_state),
	.run(run)
);

/* FORWARDING UNIT */
forwarding forwarding
(

	.ex_regwrite(id_ex_out.ctrl.reg_load),
	.mem_regwrite(ex_mem_out.ctrl.reg_load),
	.wb_regwrite(mem_wb_out.ctrl.reg_load),
	.immsel(id_ex_out.ctrl.b1_mux_sel),
	.forwarding_override(id_ex_out.forwarding_override),

	.exe_SR1(id_ex_out.inst[8:6]),
	.exe_SR2(id_ex_out.inst[2:0]),
	.exe_DR(id_ex_out.inst[11:9]),
	.mem_DR(ex_mem_out.inst[11:9]),
	.wb_DR(mem_wb_out.inst[11:9]),

	.a1mux(a1_mux_sel),
	.a2mux(a2_mux_sel),
	.b1mux(b1_mux_sel),
	.b2mux(b2_mux_sel),
	.c1mux(c1_mux_sel),
	.c2mux(c2_mux_sel),
	.d1mux(d1_mux_sel)
);

/* CHASM REGISTERS */
/* IF-ID */
chasm_reg  #($bits(lc3b_if_id)) if_id
(
	.clk,
	.enable(run),				// from stall logic
	.in(if_id_in),
	.out(if_id_out)
);
/* ID-EX */
chasm_reg  #($bits(lc3b_id_ex)) id_ex
(
	.clk,
	.enable(run),				// from stall logic
	.in(id_ex_in),
	.out(id_ex_out)
);
/* EX-MEM */
chasm_reg  #($bits(lc3b_ex_mem)) ex_mem
(
	.clk,
	.enable(run),				// from stall logic
	.in(ex_mem_in),
	.out(ex_mem_out)
);
/* MEM-WB */
chasm_reg  #($bits(lc3b_mem_wb))  mem_wb
(
	.clk,
	.enable(run),				// from stall logic
	.in(mem_wb_in),
	.out(mem_wb_out)
);

endmodule : cpu
