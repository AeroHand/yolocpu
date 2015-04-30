import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module pccontrol
(
	input lc3b_word inst_in,
	input lc3b_nzp cc,
	input lc3b_opcode id_op, ex_op, mem_op,
	input logic id_cc, ex_cc, mem_cc,

	output lc3b_word inst_out,
	output logic pc_run, addermux_sel,
	output logic [1:0] pcmux_sel,
	output logic forwarding_override

);

lc3b_opcode if_op;
lc3b_nzp nzp;
logic bit11;
logic nzp_cc_match;



assign if_op = lc3b_opcode'(inst_in[15:12]);
assign nzp = inst_in[11:9];
assign bit11 = inst_in[11];

//NZP CC comparator
nzp_cc_comp nzp_cc_comp
(	
	.nzp(nzp),
	.cc(cc),
	.f(nzp_cc_match)
);

always_comb
begin
	//default output
	pc_run = 1'b1;
	addermux_sel = 1'b0;
	pcmux_sel = 2'b00;
	inst_out = inst_in;
	forwarding_override = 1'b1;

	if( id_op == op_ldb | id_op == op_ldi | id_op == op_ldr ) begin
	// on load stall one cycle
		inst_out = 16'h0000;
		pc_run = 0;
	end

	case(if_op)

		//br
		op_br: begin
			if(nzp != 3'b000) begin 
			//inst not NOP
				if (id_cc | ex_cc | mem_cc) begin 
				// flush setcc instructs
					pc_run = 0;
				end else begin
				// we can branch
					if (nzp_cc_match)
						pcmux_sel = 2'b01;
				end
			end
			forwarding_override = 1'b0;
		end
		
		//jmp and ret
		op_jmp: begin
			if(ex_op == op_jmp) begin
				pcmux_sel = 2'b10;
			end else begin
			// stall until jmp reaches ex
				pc_run = 0;
			end
		end
		
		//jsr and jsrr
		op_jsr: begin
			if(ex_op == op_jsr) begin
				if( bit11 ==  1'b1 ) begin
				// jsr read in the pcoff 
					pcmux_sel = 2'b01;
					addermux_sel = 1'b1;
					forwarding_override = 1'b0;
				end else begin
				// jsrr read in base_reg
					pcmux_sel = 2'b10;
				end
			end else begin
			// stall until jmp reaches ex
				pc_run = 0;
			end
			inst_out[11:9] = 3'b111;
		end
		
		op_lea: begin
			forwarding_override = 1'b0;
		end

		//trap
		op_trap: begin
			if(mem_op == op_trap) begin
			// trap read in the vector
				pcmux_sel = 2'b11;
			end else begin
			// stall until trap reaches mem
				pc_run = 0;
			end
			inst_out[11:9] = 3'b111;
			forwarding_override = 1'b0;
		end

		default: /* Do nothing */;
	endcase
	
	
end

endmodule : pccontrol