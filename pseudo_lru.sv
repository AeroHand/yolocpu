import lc3b_types::*;

module pseudo_lru
(
	input way_1, way_2, way_3, 
	input lc3b_lru cur_lru,
	output lc3b_lru updated_lru
);

always_comb
begin
	if(way_1)
		updated_lru = {2'b00, cur_lru[0]};
	else if(way_2)
		updated_lru = {2'b01, cur_lru[0]};
	else if(way_3)
		updated_lru = {1'b1, cur_lru[1], 1'b0};
	else 
		updated_lru = {1'b1, cur_lru[1], 1'b1};
end

endmodule : pseudo_lru