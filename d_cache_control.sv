import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module d_cache_control
(
	input clk,
	
	input logic pmem_resp, 
	input logic mem_read, 
	input logic mem_write, 
	input logic hit, 
	input logic dirty,
	
	output logic pmem_read, 
	output logic pmem_write, 
	output logic mem_resp, 
	output logic writemux_sel, 
	output logic datamux_sel,
	output logic lru_write,
	output logic write_back
);

enum int unsigned {
	spin,
	writeback,
	readin,
	broken
} state, next_state;

always_comb
begin : state_actions
    /* Default assignments */
	 pmem_read = 1'b0;
	 pmem_write = 1'b0;
	 mem_resp = 1'b0;
	 writemux_sel = 1'b0;
	 datamux_sel = 1'b0;
	 lru_write = 1'b0;
	 write_back = 1'b0;
	 
	 case(state)
		spin: begin
			mem_resp = hit;
			writemux_sel = 1'b1;
			datamux_sel = 1'b1;
			lru_write = 1'b1;
		end
		
		writeback: begin
			mem_resp = 1'b0;
			pmem_write = 1'b1;
			writemux_sel = 1'b0;
			datamux_sel = 1'b1;
			write_back = 1'b1;
		end
		
		readin: begin
			mem_resp = 1'b0;
			pmem_read = 1'b1;
			writemux_sel = 1'b0;
			datamux_sel = 1'b0;
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
			if(mem_read || mem_write) begin
				if (hit) 
					next_state = spin;
				else
					if (dirty) 
						next_state = writeback;
					else
						next_state = readin;
			end
		end 
		writeback: begin
			if (pmem_resp) 
				next_state = readin;
			else
				next_state = writeback;
		end 
		readin: begin
			if (pmem_resp) 
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

endmodule : d_cache_control
