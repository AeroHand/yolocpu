import lc3b_types::*;

module select_way
(
	input lc3b_lru cur_lru,
	input valid_bit_1, valid_bit_2, valid_bit_3, valid_bit_4,
	output logic a, b, c, d,
	output lc3b_2bsel two_bit_way
);

always_comb
begin
	if(valid_bit_1 && valid_bit_2 && valid_bit_3 && valid_bit_4) begin
		if(cur_lru[2] && cur_lru[1]) begin  
			a = 1; b = 0; c = 0; d = 0; two_bit_way = 2'b00; end
		else if(cur_lru[2] && !cur_lru[1]) begin 
			a = 0; b = 1; c = 0; d = 0; two_bit_way = 2'b01; end
		else if(!cur_lru[2] && cur_lru[0]) begin
			a = 0; b = 0; c = 1; d = 0; two_bit_way = 2'b10; end
		else begin 
			a = 0; b = 0; c = 0; d = 1; two_bit_way = 2'b11; end
	end
	else begin
		if(!valid_bit_1) begin
			a = 1; b = 0; c = 0; d = 0; two_bit_way = 2'b00; end 
		else if (!valid_bit_2) begin
			a = 0; b = 1; c = 0; d = 0; two_bit_way = 2'b01; end
		else if (!valid_bit_3) begin
			a = 0; b = 0; c = 1; d = 0; two_bit_way = 2'b10; end
		else begin
			a = 0; b = 0; c = 0; d = 1; two_bit_way = 2'b11; end
	end 
end

endmodule : select_way