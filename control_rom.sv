import lc3b_types::*;

module control_rom
(
	input lc3b_opcode opcode,
	input logic bit11,
	input logic bit5,
	input logic bit4
	,
	output lc3b_control_word ctrl
);

always_comb
begin
	/* Default assignments */
	ctrl.opcode     = opcode;
	ctrl.src_mux    	= 1'b0;     /* ID */

	ctrl.a_mux_sel  = 2'b00;      	/* ID */
	ctrl.b1_mux_sel = 1'b0;      	/* ID */
	ctrl.b2_mux_sel = 2'b00;     	/* ID */

	ctrl.aluop 	= alu_pass;  		/* EX */

	ctrl.ldb_mux_sel = 1'b0;      	/* MEM */
	ctrl.stb_mux_sel = 1'b0;     	/* MEM */
	ctrl.ldi_sti 	 = 1'b0;     	/* MEM */
	
	ctrl.load_cc    	= 1'b0;     /* WB */
	ctrl.dest_mux_sel	= 1'b0;     /* WB */
	ctrl.reg_load		= 1'b0;     /* WB */
	ctrl.reg_data_mux 	= 2'b00;    /* WB */
	
	/* Assign control signals based on opcode */
	case(opcode)
		op_add: begin
			if(bit5 == 1)
				ctrl.b1_mux_sel = 1'b1;

			ctrl.aluop = alu_add;

			ctrl.reg_load= 1'b1;
			ctrl.load_cc = 1'b1;
		end
		
		op_and: begin
			if(bit5 == 1)
				ctrl.b1_mux_sel = 1'b1;

			ctrl.aluop = alu_and;

			ctrl.load_cc = 1'b1;
			ctrl.reg_load= 1'b1;
		end

		op_br: begin
			//nothing here
		end

		op_jmp: begin
			//nothing here
		end

		op_jsr: begin
			ctrl.dest_mux_sel 	= 1'b1;
			ctrl.reg_data_mux 	= 2'b10;
			ctrl.reg_load		= 1'b1;
		end
		
		op_ldb: begin
			ctrl.b1_mux_sel = 1'b1;
			ctrl.b2_mux_sel = 2'b10;

			ctrl.aluop 	= alu_add;

			ctrl.ldb_mux_sel = 1'b1;

			ctrl.load_cc    = 1'b1;
			ctrl.reg_data_mux= 2'b01;
			ctrl.reg_load  = 1'b1;
		end

		op_ldi: begin
			ctrl.b1_mux_sel = 1'b1;
			ctrl.b2_mux_sel = 2'b01;

			ctrl.aluop 	= alu_add;

			ctrl.ldi_sti 	= 1'b1;
			
			ctrl.load_cc    = 1'b1;
			ctrl.reg_data_mux= 2'b01;
			ctrl.reg_load  = 1'b1;
		end

		op_ldr: begin 
			ctrl.b1_mux_sel = 1'b1;
			ctrl.b2_mux_sel = 2'b01;
			
			ctrl.aluop 		= alu_add;
			
			ctrl.load_cc    = 1'b1;
			ctrl.reg_data_mux= 2'b01;
			ctrl.reg_load  = 1'b1;
		end

		op_lea: begin 
			ctrl.a_mux_sel = 2'b10;

			ctrl.aluop 	= alu_pass;

			ctrl.load_cc    = 1'b1;
			ctrl.reg_load  = 1'b1;
		end

		op_not: begin
			ctrl.aluop = alu_not;
			
			ctrl.load_cc = 1'b1;
			ctrl.reg_load= 1'b1;
		end

		op_shf: begin
			ctrl.b1_mux_sel = 1'b1;
			ctrl.b2_mux_sel = 2'b11;

			if(bit4 == 0)
				ctrl.aluop = alu_sll;
			else begin
				if(bit5 == 0)
					ctrl.aluop = alu_srl;
				else
					ctrl.aluop = alu_sra;
			end

			ctrl.reg_load= 1'b1;
			ctrl.load_cc = 1'b1;
		end
		
		op_stb: begin
			ctrl.src_mux = 1'b1;
			ctrl.b1_mux_sel = 1'b1;
			ctrl.b2_mux_sel = 2'b10;
			
			ctrl.aluop = alu_add;

			ctrl.stb_mux_sel = 1'b1;
		end
		
		op_sti: begin
			ctrl.src_mux = 1'b1;
			ctrl.b1_mux_sel = 1'b1;
			ctrl.b2_mux_sel = 2'b01;

			ctrl.aluop = alu_add; 
			
			ctrl.ldi_sti 	= 1'b1;
		end

		op_str: begin
			ctrl.src_mux = 1'b1;
			ctrl.b1_mux_sel = 1'b1;
			ctrl.b2_mux_sel = 2'b01;

			ctrl.aluop = alu_add; 
		end

		op_trap: begin
			ctrl.a_mux_sel = 2'b11;

			ctrl.aluop = alu_pass;

			ctrl.dest_mux_sel 	= 1'b1;
			ctrl.reg_data_mux   = 2'b10;
			ctrl.reg_load 		= 1'b1;
		end
		
		/* ... other opcodes ... */
		default: begin
			ctrl = 0; /* Unknown opcode, set control word to zero */
		end
	endcase
end
endmodule : control_rom