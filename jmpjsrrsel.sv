import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module jmpjsrrsel
(
	input logic [4:0] a,
	output logic b
);

always_comb
begin
	if ((a[4:1] == 4'b1100) || (a == 5'b01000))
		b = 1'b1;
	else
		b = 1'b0;
end
	
endmodule : jmpjsrrsel