import lc3b_types::*;

module address_ripper
(
    input lc3b_word mem_address,
	 
	 output lc3b_c_tag tag,
	 output lc3b_c_set set,
	 output lc3b_c_offset offset
);

always_comb
begin
    tag = mem_address[15:7];
    set = mem_address[6:4];
    offset = mem_address[3:1];
end

endmodule : address_ripper
