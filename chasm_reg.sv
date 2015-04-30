module chasm_reg #(parameter width = 16)
(
    input clk,
	 input enable,
    input [width-1:0] in,
    output logic [width-1:0] out
);

logic [width-1:0] data;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */
initial
begin
    data = 1'b0;
end

always_ff @(posedge clk)
begin
	if(enable)
    	data = in;
end

always_comb
begin
    	out = data;
end

endmodule : chasm_reg