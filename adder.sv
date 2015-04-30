import lc3b_types::*;

module adder 
(
	 input lc3b_word a, b,
	 output lc3b_word out
);

always_comb 
begin 
	 out = a + b;
end 

endmodule : adder 
