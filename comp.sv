import lc3b_types::*;

module comp
(
	 input lc3b_reg dest,//inst[11:9]
	 input lc3b_nzp cc_out,
	 input logic [3:0] opcodein,
	 output logic cccomp_out,
	 output logic sel
);

always_comb 
begin
	sel = 0;
	cccomp_out = 0;
	
	if (opcodein == 4'b0000)
	begin
		if (((dest[2] == 1'b1) && (cc_out[2] == 1'b1)) ||  ((dest[1] == 1'b1) && (cc_out[1] == 1'b1)) || ((dest[0] == 1'b1) && (cc_out[0] == 1'b1)))
			cccomp_out = 1;
	end

	if ((opcodein == 4'b0100) && (dest[2] == 1))
	begin
		sel = 1;
		cccomp_out = 1;
	end
end

endmodule : comp
