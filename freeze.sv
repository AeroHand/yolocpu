import lc3b_types::*;

module freeze
(
	input inst_resp, mem_resp,
	input mem_read, mem_write,
	input ldi_sti, ldi_sti_state,
	output logic run
);

always_comb
begin
	if(~inst_resp) begin
		run = 0;
	end else if(~mem_resp) begin
		if ( (mem_read | mem_write) ) begin
			run = 0;
		end else begin
			run = 1;
		end
	end else if(ldi_sti) begin
		if ( ~ldi_sti_state ) begin
			run = 0;
		end else begin
			run = 1;
		end
	end else begin
		run = 1;
	end
end

endmodule : freeze