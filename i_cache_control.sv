import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module i_cache_control
(
	input clk,
	
	input l2_resp, 
	input mem_read, 
	input hit, 
	
	output logic l2_read, 
	output logic mem_resp,
	output logic lru_write,
	output logic set_vals
);

enum int unsigned {
	spin,
	readin,
	broken
} state, next_state;

always_comb
begin : state_actions
    /* Default assignments */
	 l2_read = 1'b0;
	 mem_resp = 1'b0;
	 lru_write = 1'b0;
	 set_vals = 1'b0;
	 
	 case(state)
		spin: begin
			mem_resp = hit;
			if(hit)
				lru_write = 1'b1;
		end
		
		readin: begin
			if(l2_resp) set_vals = 1'b1;
			l2_read = 1'b1;
		end
		
		broken: begin
			$display("Something Broke");
		end
			
		default: /* Do nothing */;
	endcase		
end

always_comb
begin : next_state_logic
	next_state = state;
	case(state)
		spin: begin
			if (hit) 
				next_state = spin;
			else
				next_state = readin;
		end 

		readin: begin
			if (l2_resp) 
				next_state = spin;
			else
				next_state = readin;
		end
		default: next_state = broken;
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : i_cache_control
