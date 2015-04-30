import lc3b_types::*;

module arb_ctrl
(
	 input clk,
	 input i_cache_read, d_cache_read, d_cache_write,
	 input l2_resp,
	 output logic cache_sel
);

enum int unsigned {
    /* List of states */
	 idle,
	 i_cache_hold, 
	 d_cache_hold
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
	 cache_sel = 1'b0;
	 
	 /* Actions for each state */
	 case(state)	
		idle: if(d_cache_read || d_cache_write) cache_sel = 1;
		
		i_cache_hold: /* do nothing */;
		
		d_cache_hold: cache_sel = 1;
		
		default : /* Do nothing */;
	 endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	next_state = state;
	
	case(state)
		idle: begin
			if((d_cache_read || d_cache_write) && !l2_resp) begin
				next_state = d_cache_hold; //check dcache first
			end else if(i_cache_read && !l2_resp) begin
				next_state = i_cache_hold;
			end else begin
				next_state = idle;
			end
		end
	
		i_cache_hold: if (l2_resp) next_state = idle;
		
		d_cache_hold: if(l2_resp) next_state = idle;
		
		default: next_state = idle;
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : arb_ctrl