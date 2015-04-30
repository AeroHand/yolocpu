import lc3b_types::*;

module nzp_cc_comp
(
	input lc3b_nzp nzp, cc,
	output logic f
);

always_comb
begin
	if (nzp & cc)
		f = 1'b1;
	else
		f = 1'b0;
end

endmodule : nzp_cc_comp
