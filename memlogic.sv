import lc3b_types::*;

module mem_logic
(
	input lc3b_word inst,
	input lc3b_word alu,
	input logic sti,
	output logic mwrite,
	output logic mread,
	output lc3b_mem_wmask mbytesenable
);

always_comb
begin
	mwrite = 0;
	mread = 0;
	mbytesenable = 2'b11;

	case(inst[15:12])
		op_add:;
		op_and:;	
		op_not:;
		op_ldr: mread = 1;
		op_str: mwrite = 1;
		op_br:;
		op_jmp:;  /* also RET */
		op_jsr:;  /* also JSRR */
		op_ldb: mread = 1;	
		op_ldi: mread = 1;
		op_lea:;
		op_shf:;
		op_stb: begin
			mwrite = 1;
			if(alu[0]==0)
				mbytesenable = 2'b01;
			else
				mbytesenable = 2'b10;		
		end
		
		op_sti: begin
			if(sti == 1'b1)
			begin
				mwrite = 1;
				mread = 0;
			end else begin
				mread = 1;
				mwrite = 0;				
			end
		end
		
		default: $display("Mem Unknown opcode", inst[15:12]);
	endcase


end
	
endmodule : mem_logic