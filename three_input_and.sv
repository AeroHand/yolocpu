module threeand
(
	input logic a,b,c,
	output logic f
);

always_comb
begin
	f=a & b & c;
end
	
endmodule : threeand