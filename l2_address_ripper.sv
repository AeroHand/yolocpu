import lc3b_types::*;

module l2_address_ripper
(
    input lc3b_word mem_address,
	 
	 output lc3b_c2_tag tag,
	 output lc3b_c2_set set,
	 output lc3b_c_offset offset
);

always_comb
begin
    tag = mem_address[15:8];
    set = mem_address[7:4];
    offset = mem_address[3:1];
end

endmodule : l2_address_ripper
