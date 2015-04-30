import lc3b_types::*;

module regcomp
(
    input lc3b_reg a,
	 input lc3b_nzp b,
    output logic f
);

always_comb
begin

    if ((a[2] == b[2]) && (a[1] == b[1]) && (a[0] == b[0]))
        f = 1'b1;
    else
        f = 1'b0;
end

endmodule : regcomp
