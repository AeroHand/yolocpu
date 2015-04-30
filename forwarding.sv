import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module forwarding
(
	input logic mem_regwrite,ex_regwrite,wb_regwrite,immsel, forwarding_override,
	input lc3b_reg exe_SR1,mem_DR,wb_DR,exe_SR2,exe_DR,
	output logic a1mux,a2mux,b1mux,b2mux,c1mux,c2mux,d1mux
);

logic regcomp1out;
logic regcomp2out;
logic regcomp3out;
logic regcomp4out;
logic regcomp5out;
logic regcomp6out;
logic regcomp7out;
logic not_immsel;
logic no_ex_write;
logic sr1usemem;
logic sr1usewb;
logic sr2usewb;
logic sr2usemem;
logic drusewb;
logic drusemem;

not_gate not1
(
	.a(immsel),
	.f(not_immsel)
);

not_gate not2
(
	.a(ex_regwrite),
	.f(no_ex_write)
);

regcomp regcomp1
(
	.a(exe_SR1),
	.b(mem_DR),
	.f(regcomp1out)
);

regcomp regcomp2
(
	.a(exe_SR1),
	.b(wb_DR),
	.f(regcomp2out)
);

regcomp regcomp3
(
	.a(exe_SR2),
	.b(mem_DR),
	.f(regcomp3out)
);

regcomp regcomp4
(
	.a(exe_SR2),
	.b(wb_DR),
	.f(regcomp4out)
);

regcomp regcomp5
(
	.a(exe_DR),
	.b(mem_DR),
	.f(regcomp5out)
);

regcomp regcomp6
(
	.a(exe_DR),
	.b(wb_DR),
	.f(regcomp6out)
);

regcomp regcomp7
(
	.a(mem_DR),
	.b(wb_DR),
	.f(regcomp7out)
);

twoand and1
(
	.a(regcomp1out),
	.b(mem_regwrite),
	.f(sr1usemem)
);

twoand and2
(
	.a(regcomp2out),
	.b(wb_regwrite),
	.f(sr1usewb)
);

threeand and3
(
	.a(regcomp3out),
	.b(mem_regwrite),
	.c(not_immsel),
	.f(sr2usemem)
);

threeand and4
(
	.a(regcomp4out),
	.b(wb_regwrite),
	.c(not_immsel),
	.f(sr2usewb)
);

threeand and5
(
	.a(regcomp5out),
	.b(mem_regwrite),
	.c(no_ex_write),
	.f(drusemem)
);

threeand and6
(
	.a(regcomp6out),
	.b(wb_regwrite),
	.c(no_ex_write),
	.f(drusewb)
);

twoand and7
(
	.a(regcomp7out),
	.b(wb_regwrite),
	.f(d1mux)
);

assign a1mux = (sr1usemem | sr1usewb) & forwarding_override;
assign a2mux = (sr1usemem & sr1usewb) | sr1usemem;
assign b1mux = (sr2usemem | sr2usewb) & forwarding_override;
assign b2mux = (sr2usemem & sr2usewb) | sr2usemem;
assign c1mux = drusemem | drusewb;
assign c2mux = (drusemem & drusewb) | drusemem;

endmodule : forwarding