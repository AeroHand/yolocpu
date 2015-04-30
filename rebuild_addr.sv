import lc3b_types::*;

module rebuild_addr
(
	 input lc3b_c2_tag tag,
	 input lc3b_c2_set index,
	 output lc3b_word addr
);

always_comb
begin
	 addr = {tag, index, 4'b0000};
end

endmodule : rebuild_addr