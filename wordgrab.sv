import lc3b_types::*;

module wordgrab
(
	input lc3b_line line,
	input lc3b_c_offset offset,
	
	output lc3b_word out
);

always_comb
begin
	if (offset == 3'b000) begin
		out = line[15:0];
	end else if( offset == 3'b001) begin
      out = line[31:16];
   end else if( offset == 3'b010) begin
      out = line[47:32];
   end else if( offset == 3'b011) begin
      out = line[63:48];
   end else if( offset == 3'b100) begin
      out = line[79:64];
   end else if( offset == 3'b101) begin
      out = line[95:80];
   end else if( offset == 3'b110) begin
      out = line[111:96];
   end else begin
      out = line[127:112];
	end
end

endmodule : wordgrab
