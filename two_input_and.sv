module twoand
(
	input logic a,b,
	output logic f
);

always_comb
begin
	f=a & b;
end
	
endmodule : twoand