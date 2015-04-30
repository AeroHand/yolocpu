import lc3b_types::*;

module data_select
(
	input hit_2, hit_3, hit_4, 
	output lc3b_2bsel data_select_out
);

always_comb
begin
	if(hit_2) 
		data_select_out = 2'b01;
	else if (hit_3)
		data_select_out = 2'b10;
	else if (hit_4)
		data_select_out = 2'b11;
	else 
		data_select_out = 2'b00;
end

endmodule : data_select