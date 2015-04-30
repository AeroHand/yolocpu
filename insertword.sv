import lc3b_types::*;

module insertword
(
	 input  lc3b_line line,
	 input lc3b_word word,
	 input lc3b_c_offset offset,
	 input lc3b_mem_wmask mem_byte_enable,
	 output  lc3b_line out
);	

always_comb
begin
	 if(offset == 3'b000) begin
		 if(mem_byte_enable == 2'b01)
			 out = {line[127:8], word[7:0]};
		 else if(mem_byte_enable == 2'b10)
			 out = {line[127:16], word[15:8], line[7:0]};
		 else 
			 out = {line[127:16], word};
	 end
	 else if(offset == 3'b001) begin
		 if(mem_byte_enable == 2'b01)
			 out = {line[127:24], word[7:0], line[15:0]};
		 else if(mem_byte_enable == 2'b10)
			 out = {line[127:32], word[15:8], line[23:0]};
		 else 
			 out = {line[127:32], word, line[15:0]};
	 end
	 else if(offset == 3'b010) begin
		 if(mem_byte_enable == 2'b01)
			 out = {line[127:40], word[7:0], line[31:0]};
		 else if(mem_byte_enable == 2'b10)
			 out = {line[127:48], word[15:8], line[39:0]};
		 else 
			 out = {line[127:48], word, line[31:0]};
	 end
	 else if(offset == 3'b011) begin
		 if(mem_byte_enable == 2'b01)
			 out = {line[127:56], word[7:0], line[47:0]};
		 else if(mem_byte_enable == 2'b10)
			 out = {line[127:64], word[15:8], line[55:0]};
		 else 
			 out = {line[127:64], word, line[47:0]};
	 end 
	 else if(offset == 3'b100) begin
		 if(mem_byte_enable == 2'b01)
			 out = {line[127:72], word[7:0], line[63:0]};
		 else if(mem_byte_enable == 2'b10)
			 out = {line[127:80], word[15:8], line[71:0]};
		 else 
			 out = {line[127:80], word, line[63:0]};
	 end
	 else if(offset == 3'b101) begin
		 if(mem_byte_enable == 2'b01)
			 out = {line[127:88], word[7:0], line[79:0]};
		 else if(mem_byte_enable == 2'b10)
			 out = {line[127:96], word[15:8], line[87:0]};
		 else 
			 out = {line[127:96], word, line[79:0]};
	 end
	 else if(offset == 3'b110) begin
		 if(mem_byte_enable == 2'b01) 
			 out = {line[127:104], word[7:0], line[95:0]};
		 else if(mem_byte_enable == 2'b10)
			 out = {line[127:112], word[15:8], line[103:0]};
		 else 
			 out = {line[127:112], word, line[95:0]};
	 end
	 else begin
		 if(mem_byte_enable == 2'b01)
			 out = {line[127:120], word[7:0], line[111:0]};
		 else if(mem_byte_enable == 2'b10)
			 out = {word[15:8], line[119:0]};
		 else 
			 out = {word, line[111:0]};
	 end
end

endmodule : insertword