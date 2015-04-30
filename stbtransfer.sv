import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module stbtransfer
(
	input logic a,//0 low 1 high
	input lc3b_word b,
	output lc3b_word f
);

always_comb
begin
	if (a == 1'b0)
		f = b;
	else
		f = b << 8;
end
	
endmodule : stbtransfer