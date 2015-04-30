import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module ldbtransfer
(
	input logic a,
	input lc3b_word b,
	output lc3b_word f
);

always_comb
begin
	if (a == 1'b0)
		f = b & 16'h00FF;
	else
		f = b >> 8;
end
	
endmodule : ldbtransfer