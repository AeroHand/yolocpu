import lc3b_types::*;

module l2_cache_control
(
	input clk,

	/* L1 interaction */
	input mem_read,
	input mem_write,
	output logic mem_resp,

	/* DRAM interaction */
	input pmem_resp,
	output logic pmem_read,
	output logic pmem_write,

	/* Datapath interaction */
	input hit,
	input dirty,
	output logic lru_set,
	output logic vtd_set,
	output logic dirty_set,
	output logic rw_sel,
	output logic load_mux_sel,
	output logic addr_sel
);

enum int unsigned {
	compare,
	allocate,
	writeback
} state, next_state;

always_comb
begin : state_actions
    /* Default assignments */
    mem_resp = 0;
    pmem_read = 0;
    pmem_write = 0;
    vtd_set = 0;
    dirty_set = 0;
    rw_sel = 0;
    lru_set = 0;
    load_mux_sel = 0;
    addr_sel = 0;

    /* Actions for each state */
    case(state)
    	compare: begin
    		if(mem_read || mem_write) begin
    			if(hit) begin
    				mem_resp = 1;
    				lru_set = 1;
    				if(mem_write) begin
    					vtd_set = 1;
    					dirty_set = 1;
    					rw_sel = 1;
    					load_mux_sel = 1;
    				end
    			end
    		end
    	end

    	allocate: begin
    		pmem_read = 1;
    		if(pmem_resp) vtd_set = 1;
    	end

    	writeback: begin
    		pmem_write = 1;
    		addr_sel = 1;
    	end

    	default: /* do nothing */;
    endcase
end

always_comb
begin: next_state_logic
	next_state = state;
	case(state)
		compare: begin
			if(mem_read || mem_write) begin
				if(!hit) begin
					if(dirty) next_state = writeback;
					else next_state = allocate;
				end
			end
		end

		allocate: if(pmem_resp) next_state = compare;

		writeback: if(pmem_resp) next_state = allocate;

		default: next_state = compare;
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : l2_cache_control