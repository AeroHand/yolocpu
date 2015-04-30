import lc3b_types::*;

module ext #(parameter width = 8)
(
	input logic zextsext, byteword,
	input [width-1:0] in,
	output lc3b_word out
);

always_comb
begin
	if (zextsext == 1'b0) begin
	/* ZEXT */
		if (byteword == 1'b0) begin
		/* BYTE */
			out = $unsigned(in);
		end else begin
			/* WORD */
			out = $unsigned({in, 1'b0});
		end
	end 
	else begin
		if (byteword == 1'b0) begin
			/* BYTE */
			out = $signed(in);
		end else begin
			/* WORD */
			out = $signed({in, 1'b0});
		end
	end
end

endmodule : ext