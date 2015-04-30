package lc3b_types;

typedef logic  [1:0] lc3b_2bsel;
typedef logic  [2:0] lc3b_3bsel;

typedef logic [127:0] lc3b_line;
typedef logic [15:0] lc3b_word;
typedef logic  [7:0] lc3b_byte;

typedef logic  [3:0] lc3b_imm4;
typedef logic  [4:0] lc3b_imm5;
typedef logic  [5:0] lc3b_imm6;

typedef logic  [5:0] lc3b_offset6;
typedef logic  [8:0] lc3b_offset9;
typedef logic  [10:0] lc3b_offset11;

typedef logic  [7:0] lc3b_trapvect8;

typedef logic  [2:0] lc3b_reg;
typedef logic  [2:0] lc3b_nzp;
typedef logic  [1:0] lc3b_mem_wmask;

typedef logic  [8:0] lc3b_c_tag;
typedef logic  [7:0] lc3b_c2_tag;
typedef logic  [2:0] lc3b_c_set;
typedef logic  [3:0] lc3b_c2_set;
typedef logic  [2:0] lc3b_c_offset;

typedef logic  [2:0] lc3b_lru;

typedef enum bit [3:0] {
    op_add  = 4'b0001,
    op_and  = 4'b0101,
    op_br   = 4'b0000,
    op_jmp  = 4'b1100,   /* also RET */
    op_jsr  = 4'b0100,   /* also JSRR */
    op_ldb  = 4'b0010,
    op_ldi  = 4'b1010,
    op_ldr  = 4'b0110,
    op_lea  = 4'b1110,
    op_not  = 4'b1001,
    op_rti  = 4'b1000,
    op_shf  = 4'b1101,
    op_stb  = 4'b0011,
    op_sti  = 4'b1011,
    op_str  = 4'b0111,
    op_trap = 4'b1111
} lc3b_opcode;

typedef enum bit [3:0] {
    alu_add,
    alu_and,
    alu_not,
    alu_pass,
    alu_sll,
    alu_srl,
    alu_sra,
	alu_bytemask
} lc3b_aluop;

/* CONTROL WORD 17*/
typedef struct packed {
	lc3b_opcode opcode;
	logic src_mux;         	/* ID */

	lc3b_2bsel a_mux_sel;   /* ID */
	logic b1_mux_sel;      	/* ID */
	lc3b_2bsel b2_mux_sel; 	/* ID */
	
	lc3b_aluop aluop;      	/* EX */

	logic ldb_mux_sel;      /* MEM */
	logic stb_mux_sel; 		/* MEM */
	logic ldi_sti; 			/* MEM */
	
	logic load_cc;         	/* WB */

	logic dest_mux_sel;			/* WB */
	logic reg_load;      		/* WB */
	lc3b_2bsel reg_data_mux; 	/* WB */
} lc3b_control_word;

/* IF_ID 16*/
typedef struct packed {
	lc3b_word inst;
	lc3b_word pc;
	lc3b_word pc_off;
	logic forwarding_override;
} lc3b_if_id;

/* ID_EX */
typedef struct packed {
	lc3b_control_word ctrl;
	lc3b_word inst;
	lc3b_word pc;
	lc3b_word a;
	lc3b_word b;
	lc3b_word reg_b;
	logic forwarding_override;
} lc3b_id_ex;

/* EX_MEM */
typedef struct packed {
	lc3b_control_word ctrl;
	lc3b_word inst;
	lc3b_word pc;
	lc3b_word alu;
	lc3b_word reg_b;	
} lc3b_ex_mem;

/* MEM_WB */
typedef struct packed {
	lc3b_control_word ctrl;
	lc3b_word inst;
	lc3b_word pc;
	lc3b_word alu;
	lc3b_word mem_rdata;
} lc3b_mem_wb;

endpackage : lc3b_types
