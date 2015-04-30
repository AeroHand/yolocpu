import lc3b_types::*;

module not_gate (output wire f, input wire a);

assign f = ~a;

endmodule : not_gate